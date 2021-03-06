require 'hiera'
class Hiera
  module Backend
    class Yamll_backend
      VERSION = "0.3.1"
      # This is left blank because we are hacking hiera backend logic
      # to get around a limitation of hiera where you cannot have
      # multiple backends of the same type.
      # This class is just a subclass of the built in yaml backend.
      # there is no difference in the backends other than the namespace

      def initialize(cache=nil)
        require 'yaml'
        Hiera.debug("Hiera YAMLL backend starting")
        @cache = cache || Filecache.new
      end

      # context is for newer versions of hiera and we will use that variable as a way to determine versions of hiera
      def lookup(key, scope, order_override, resolution_type, context=nil)
        answer = nil
        found = false
        newer_hiera_version = Hiera::VERSION >= '3.0.0'

        Hiera.debug("Looking up #{key} in YAMLL backend")
        Backend.datasourcefiles(:yamll, scope, "yaml", order_override) do |source, yamlfile|
          data = @cache.read_file(yamlfile, Hash) do |data|
            YAML.load(data) || {}
          end

          next if data.empty?
          next unless data.include?(key)
          found = true

          # Extra logging that we found the key. This can be outputted
          # multiple times if the resolution type is array or hash but that
          # should be expected as the logging will then tell the user ALL the
          # places where the key is found.
          Hiera.debug("Found #{key} in #{source}")

          # for array resolution we just append to the array whatever
          # we find, we then goes onto the next file and keep adding to
          # the array
          #
          # for priority searches we break after the first found data item
          if newer_hiera_version
            # versions of newer hiera use a context
            new_answer = Backend.parse_answer(data[key], scope, {}, context)
          else
            new_answer = Backend.parse_answer(data[key], scope, {})
          end
          case resolution_type.is_a?(Hash) ? :hash : resolution_type
          when :array
            raise Exception, "Hiera type mismatch for key '#{key}': expected Array and got #{new_answer.class}" unless new_answer.kind_of? Array or new_answer.kind_of? String
            answer ||= []
            answer << new_answer
          when :hash
            raise Exception, "Hiera type mismatch for key '#{key}': expected Hash and got #{new_answer.class}" unless new_answer.kind_of? Hash
            answer ||= {}
            if newer_hiera_version
              answer = Backend.merge_answer(new_answer, answer, resolution_type)
            else
              answer = Backend.merge_answer(new_answer, answer)
            end
          else
            answer = new_answer
            break
          end
        end
        if newer_hiera_version
          throw :no_such_key unless found
        end
        return answer
      end
    end
  end
end

require 'test_helper'

class Hiera::Backend::Yamll_backend_Test < Minitest::Test

  def setup
    Hiera.new(config: {
                default: nil,
                backends: ['yamll'],
                hierarchy: %w(main common),
                scope: {},
                key: nil,
                verbose: false,
                resolution_type: :priority,
                format: :ruby } )
  end

  def test_that_it_has_a_version_number
    refute_nil ::Hiera::Backend::Yamll_backend::VERSION
  end

  def test_it_does_something_useful
    assert ::Hiera::Backend::Yamll_backend.new
  end
end

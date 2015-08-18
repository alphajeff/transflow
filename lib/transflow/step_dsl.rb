require 'transflow/publisher'

module Transflow
  class StepDSL
    attr_reader :name

    attr_reader :options

    attr_reader :handler

    attr_reader :container

    attr_reader :steps

    attr_reader :publish

    attr_reader :monadic

    def initialize(name, options, container, steps, &block)
      @name = name
      @options = options
      @handler = options.fetch(:with, name)
      @publish = options.fetch(:publish, false)
      @monadic = options.fetch(:monadic, false)
      @container = container
      @steps = steps
      instance_exec(&block) if block
    end

    def step(name, new_options = {}, &block)
      self.class.new(name, options.merge(new_options), container, steps, &block).call
    end

    def call
      operation = container[handler]

      step =
        if publish
          Publisher[name, operation, monadic: monadic]
        else
          operation
        end

      steps[name] = step
    end
  end
end

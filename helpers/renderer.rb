# frozen_string_literal: true

# # not needed when running in a Jupyter Notebook that has
# # set IRuby as the Kernel for the Notebook
# require 'iruby'

# The OutputStrategy class is responsible for rendering output.
# It provides a consistent interface for different types of output.
class OutputStrategy
  def write(data)
    raise NotImplementedError, 'You must implement the write method'
  end
end

# The FileOutput class is a concrete output strategy that writes output to a file.
class FileOutput < OutputStrategy
  def initialize(filename)
    @filename = filename
    super
  end

  def write(data)
    File.open(@filename, 'w') { |file| file.write(data) }
  end
end

# The ConsoleOutput class is a concrete output strategy that writes output to the console.
class ConsoleOutput < OutputStrategy
  def write(data)
    IRuby.display IRuby.svg(data)
  end
end

# The Renderer class uses an output strategy to render output in a specific format.
class Renderer
  def initialize(strategy: ConsoleOutput.new)
    @strategy = strategy
  end

  def render(data)
    # Do some rendering with data...
    rendered = data.to_s  # Simplified for the example
    @strategy.write(rendered)
  end
end

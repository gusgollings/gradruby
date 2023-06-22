class OutputStrategy
  def write(data)
    raise NotImplementedError, 'You must implement the write method'
  end
end

class FileOutput < OutputStrategy
  def initialize(filename)
    @filename = filename
  end

  def write(data)
    File.open(@filename, 'w') { |file| file.write(data) }
  end
end

class ConsoleOutput < OutputStrategy
  def write(data)
    IRuby.display IRuby.svg(data)
  end
end

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

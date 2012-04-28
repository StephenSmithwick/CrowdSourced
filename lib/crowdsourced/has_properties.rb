module HasProperties
  attr_accessor :props

  def has_properties *args
    @props = args
    instance_eval { attr_reader *args }
  end

  def self.included base
    base.extend self
  end

  def initialize(args)
    args.each {|k,v|
      instance_variable_set "@#{k}", v if self.class.props.member?(k)
    } if args.is_a? Hash
  end
end

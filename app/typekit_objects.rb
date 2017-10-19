# Class representing a Typekit kit.
class Kit
  attr_reader :id, :name, :analytics, :domains, :families, :optimize_performance

  # Fields that make up a Kit, and acceptable datatypes for each.
  VALID_FIELDS_AND_TYPES = {'analytics' => [TrueClass, FalseClass], 
                            'domains' => [Array], 
                            'families' => [Array], 'id' => [String], 
                            'name' => [String], 
                            'optimize_performance' => [TrueClass, FalseClass]}

  # Takes the API's JSON response as 'params' and assigns each attribute to the
  # appropriate variable. 
  def initialize(params)
    unless params.keys.sort == VALID_FIELDS_AND_TYPES.keys.sort
      raise ArgumentError.new "Keys of Kit initialization hash don't match " \
                              "acceptable values."
    end

    params.keys.each do |attr|
      unless VALID_FIELDS_AND_TYPES[attr].include? params[attr].class
        raise ArgumentError.new "Data type mismatch in Kit initialization."
      end
    end

    # Families are going to be stored as FontFamily classes, so seperate them.
    params.each { |k,v| instance_variable_set("@#{k}", v) unless k == 'families' }
    @families = params['families'].map { |f| FontFamily.new(f) }
  end
end

# Class representing a Typekit family of fonts.
class FontFamily
  attr_reader :id, :name, :slug, :css_names, :css_stack, :subset, :variations

  VALID_FIELDS_AND_TYPES = {'css_names' => [Array], 'css_stack' => [String],
                            'id' => [String], 'name' => [String], 
                            'slug' => [String], 'subset' => [String],
                            'variations' => [Array]}

  def initialize(params)
    unless params.keys.sort == VALID_FIELDS_AND_TYPES.keys.sort
      raise ArgumentError.new "Keys of FontFamily initialization hash don't " \
                              "match acceptable values."
    end

    params.keys.each do |attr|
      unless VALID_FIELDS_AND_TYPES[attr].include? params[attr].class
        raise ArgumentError.new "Data type mismatch in FontFamily initialization."
      end
    end

    params.each { |k,v| instance_variable_set("@#{k}", v) }
  end
end

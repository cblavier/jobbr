# mixin setting destination root needed by generator_spec
module GeneratorDestinationRoot

  def initialize(*args)
    super(*args)
    self.destination_root = SPEC_TMP_ROOT
  end

end

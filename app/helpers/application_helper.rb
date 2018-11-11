module ApplicationHelper
  def translate_enum(object, enum_name)
    model_name = object.model_name.i18n_key
    enums = enum_name.to_s.pluralize
    enum_value = object.send(enum_name)
    I18n.t("activerecord.attributes.#{model_name}.#{enums}.#{enum_value}")
  end
end

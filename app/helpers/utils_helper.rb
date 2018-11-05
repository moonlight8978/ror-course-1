module UtilsHelper
  def classnames(*classes, **conditional_classes)
    element_classes = [*classes]
    conditional_classes.each do |class_name, condition|
      element_classes.push(class_name) if condition
    end
    element_classes.join(' ')
  end

  def error_message_for(model, attribute)
    error_messages = model.errors.messages[attribute]
    return nil if error_messages.empty?

    content_tag(
      :span, nil, class: 'helper-text', data: { error: error_messages.first }
    )
  end

  def breadcrumbs_for(*links)
    render 'layouts/breadcrumbs', links: links
  end
end

module ApplicationHelper
  def classnames(*classes, **conditional_classes)
    element_classes = [*classes]
    conditional_classes.each do |class_name, condition|
      element_classes.push(class_name) if condition
    end
    element_classes.join(' ')
  end
end

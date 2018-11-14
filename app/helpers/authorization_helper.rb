module AuthorizationHelper
  def button_if_signed_in(url, &block)
    if signed_in?
      link_to url, class: 'waves-effect waves-light btn', &block
    else
      data = {
        position: 'bottom',
        tooltip: t('helpers.authorization.authentication.tooltip')
      }
      content_tag :button, class: 'btn tooltipped', data: data, &block
    end
  end

  def link_if_signed_in(url, options = {}, &block)
    destination = signed_in? ? url : 'javascript:void(0);'
    classname = classnames(options[:class], tooltipped: !signed_in?)
    data =
      if signed_in?
        {}
      else
        {
          position: 'bottom',
          tooltip: t('helpers.authorization.authentication.tooltip')
        }
      end
    link_to destination, class: classname, data: data, &block
  end
end

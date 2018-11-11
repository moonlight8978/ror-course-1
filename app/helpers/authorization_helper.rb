module AuthorizationHelper
  def button_if_signed_in(url, &block)
    if signed_in?
      link_to url, class: 'waves-effect waves-light btn', &block
    else
      content_tag(
        :button,
        class: 'btn tooltipped',
        data: {
          position: 'bottom',
          tooltip: t('helpers.authorization.authentication.tooltip')
        },
        &block
      )
    end
  end
end

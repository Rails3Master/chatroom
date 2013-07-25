module ApplicationHelper

  # AJAX paginate
  def will_paginate_remote(paginator, options={})
    url = options.delete(:url)
    str = will_paginate(paginator, options)
    if str != nil
      str.gsub(/href="(.*?)"/) do
        "href=\"#\" onclick=\"new Ajax.Request('" + (url ? url + $1.sub(/[^\?]*/, '') : $1) +
            "'); return false;\""
      end
    end
  end


end

module ApplicationHelper
  def join_error_messages(a_messages)
    result = ""

    a_messages.each do |m|
      result = (result + content_tag(:li, m)).html_safe
    end

    content_tag(:ul, result).html_safe
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  class String
    def is_i?
      !!(self =~ /\A[-+]?[0-9]+\z/)
    end
  end

end

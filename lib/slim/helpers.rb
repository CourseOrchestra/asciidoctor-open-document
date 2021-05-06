unless RUBY_ENGINE == 'opal'
  require 'asciidoctor'
end

module Slim::Helpers

  # manages cell styles subelements
  def set_current_cell_style op, cell_style = ""
    $aod_tl += op
    $aod_current_cell_style[$aod_tl] = "in_cell_#{$aod_tl} #{cell_style}" if $aod_tl > 0
  end

  def set_current_list_item_style op, list_item_style = ""
    $aod_ll += op
    $aod_current_list_item_style[$aod_ll] = "in_list_item_#{$aod_tl} #{list_item_style}" if $aod_ll > 0
  end

  # Calculates style based on role and position in some elements
  def get_basic_style
    ("#{role} #{$aod_current_cell_style[$aod_tl]} #{$aod_current_list_item_style[$aod_ll]}").strip
  end
  def content_frame cftype
    pstyle = "adoc_cfp cft_#{cftype} #{get_basic_style}"
    fstyle = "adoc_cf cft_#{cftype} #{get_basic_style}"
    id = "#{id.nil? ? '' : id}"
    "<text:p text:style-name='#{pstyle}'><draw:frame draw:style-name='#{fstyle}' draw:name='#{id}'>#{yield}</draw:frame></text:p>"
  end
end



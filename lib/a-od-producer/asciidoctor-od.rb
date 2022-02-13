#!/usr/bin/ruby -w
require 'nokogiri'
require 'optparse'
require_relative 'misc'

$aodp_sn_p = "Text_20_body"
$aodp_sn_tp = "Table_20_Contents"
$aodp_sn_tp_head = "Table_20_Heading"
$aodp_sn_tca = "Table"
$aodp_sn_a = "Internet_20_link"
$aodp_sn_a_visited = "Visited_20_Internet_20_Link"
$aodp_sn_h1 = "Heading_20_1"
$aodp_sn_h2 = "Heading_20_2"
$aodp_sn_h3 = "Heading_20_3"
$aodp_sn_h4 = "Heading_20_4"
$aodp_sn_h5 = "Heading_20_5"
$aodp_sn_h6 = "Heading_20_6"
$aodp_sn_h7 = "Heading_20_7"
$aodp_sn_h8 = "Heading_20_8"
$aodp_sn_h1_discrete = "Heading_20_1_20_Discrete"
$aodp_sn_h2_discrete = "Heading_20_2_20_Discrete"
$aodp_sn_h3_discrete = "Heading_20_3_20_Discrete"
$aodp_sn_h4_discrete = "Heading_20_4_20_Discrete"
$aodp_sn_h5_discrete = "Heading_20_5_20_Discrete"
$aodp_sn_h6_discrete = "Heading_20_6_20_Discrete"
$aodp_sn_h7_discrete = "Heading_20_7_20_Discrete"
$aodp_sn_h8_discrete = "Heading_20_8_20_Discrete"
$aodp_sn_appendix = "Appendix"
$aodp_sn_span_emphasis = "Emphasis"
$aodp_sn_span_strong = "Strong_20_Emphasis"
$aodp_sn_span_subscript = "Subscript"
$aodp_sn_span_superscript = "Superscript"
$aodp_sn_span_mark = "Mark"
$aodp_sn_span_monospaced = "Source_20_Text"
$aodp_sn_span_unquoted_small = "Small"
$aodp_sn_span_unquoted_table_small = "Table_20_Small"
$aodp_sn_span_unquoted_big = "Big"
$aodp_sn_span_unquoted_table_big = "Table_20_Big"
$aodp_sn_span_unquoted_underline = "Underline"
$aodp_sn_list_arabic = "Numbering_20_123"
$aodp_sn_list_decimal = "Numbering_20_dec"
$aodp_sn_list_loweralpha = "Numbering_20_abc"
$aodp_sn_list_upperalpha = "Numbering_20_ABC"
$aodp_sn_list_lowerroman = "Numbering_20_ivx"
$aodp_sn_list_upperroman = "Numbering_20_IVX"
$aodp_sn_list_lowergreek = "Numbering_20_lg"
$aodp_sn_list_callouts = "Callouts_20_Numbering"
$aodp_sn_lca = "List_20_Caption"
$aodp_sn_tlca = "Table_20_List_20_Caption"
$aodp_sn_lp = "List"
$aodp_sn_list_disk = "Bullet_20_Disk"
$aodp_sn_list_circle = "Bullet_20_Circle"
$aodp_sn_list_square = "Bullet_20_Square"
$aodp_sn_list_none = "Bullet_20_None"
$aodp_sn_list_no_bullet  = "Bullet_20_None"
$aodp_sn_list_default  = "Bullet_20_Default"
$aodp_sn_tlp = "Table_20_List"
$aodp_sn_if = "Graphic"
$aodp_sn_bip = "Block_20_Image"
$aodp_100_percent_mm = 170
$aodp_sn_ica = "Figure"
$aodp_inline_height_mm = 5
$aodp_sn_orientation_portrait = "Standard"
$aodp_sn_orientation_landscape = "Landscape"
$aodp_sn_footnote_anchor = "Footnote_20_anchor"
$aodp_stem_dpi = 80
$aodp_sn_sp = "Equation"
$aodp_sn_cfp = "Content_20_Frame_20_Paragraph"
$aodp_sn_tcfp = "Table_20_Content_20_Frame_20_Paragraph"
$aodp_sn_af = "Admonition"
$aodp_sn_ahp = "Admonition_20_Heading"
$aodp_sn_aca = "Admonition_20_Caption"
$aodp_sn_taca = "Table_20_Admonition_20_Caption"
$aodp_sn_tahp = "Table_20_Admonition_20_Heading"
$aodp_sn_ef = "Example"
$aodp_sn_eca = "Example_20_Caption"
$aodp_sn_teca = "Table_20_Example_20_Caption"
$aodp_sn_lica = "Listing_20_Caption"
$aodp_sn_tlica = "Table_20_Listing_20_Caption"
$aodp_sn_lip = "Listing"
$aodp_sn_tlip = "Table_20_Listing"
$aodp_sn_span_callout = "Callout"
$aodp_sn_colp = "Callout_20_List"
$aodp_sn_tcolp = "Table_20_Callout_20_List"
$aodp_sn_span_callout_list_callout_number = "Callout_20_List_20_Callout_20_Number"
$aodp_table_margin_top = "0cm"
$aodp_table_margin_bottom = "0.25cm"
$aodp_ntable_margin_top = "0.1cm"
$aodp_ntable_margin_bottom = "0.1cm"
$aodp_toc_pn_column = "15mm"
$aodp_toc_title_column = "155mm"
$aodp_sn_toc_h1 = "TOC_20_Level_20_1"
$aodp_sn_toc_h2 = "TOC_20_Level_20_2"
$aodp_sn_toc_h3 = "TOC_20_Level_20_3"
$aodp_sn_toc_h4 = "TOC_20_Level_20_4"
$aodp_sn_toc_h5 = "TOC_20_Level_20_5"
$aodp_sn_toc_pn_h1 = "TOC_20_Page_20_Number"
$aodp_sn_toc_pn_h2 = "TOC_20_Page_20_Number"
$aodp_sn_toc_pn_h3 = "TOC_20_Page_20_Number"
$aodp_sn_toc_pn_h4 = "TOC_20_Page_20_Number"
$aodp_sn_toc_pn_h5 = "TOC_20_Page_20_Number"
$aodp_sn_toc_header = "Contents_20_Heading"
$aodp_sn_toc_dots_title = "TOC_20_Dots_20_Title"
$aodp_sn_toc_dots_page_number = "TOC_20_Dots_20_Page_20_Number"
$aodp_sn_toc_dots_space_page_number = "TOC_20_Dots_20_Space_20_Page_20_Number"
$aodp_sn_index_separator = "Index_20_Separator"
$aodp_sn_index_heading = "Zero_20_Height"
$aodp_sn_index_1 = "Index_20_1"
$aodp_sn_index_2 = "Index_20_2"
$aodp_sn_index_3 = "Index_20_3"
$aodp_sn_alphabetical_index_pagenum = "Alphabetical_20_Index_20_Pagenum"
$aodp_assume_src_dpi = 130
$aodp_list_first_level_indent = "12.7mm"
$aodp_list_other_levels_indent = "6.4mm"
$aodp_sn_preamble_before_paragraph = "Preamble_20_Before_20_Paragraph"

=begin
tag::algorithm_description[]
== Setting predefined styles

"`You should create documentation in Word, RIGHT WAY`". 

MS Word as well as Open Office suggest that each element should have only one style. That greatly contradicts to the concept of cascaded styles (CSS), but makes things easier. If we can define such a unique style for text or paragraph, then we need nothing more.

It is always the case with list styles, but sometimes with text or less often paragraph styles.

StyleSubstitor just sets the predefined style for certain elements.

Here we may also do any xml preprocessing. Change the order of elements, insert custom elements. As we do it with xml, such preprocessing is extremely fast.

To extend setting predefined styles routine just make a descendant of `StyleSubstitutor` in your custom library.

end::algorithm_description[]
=end

class Initiator
  def initialize template
    @template = template
    h_init_globals_from_template
  end
  def h_init_globals_from_template
    meta_user_defineds = @template.xpath("//meta:user-defined",
                                         'meta' => 'urn:oasis:names:tc:opendocument:xmlns:meta:1.0' )
    meta_user_defineds.each do |meta_user_defined|
      meta_name = meta_user_defined.xpath("@meta:name",
                                          'meta' => 'urn:oasis:names:tc:opendocument:xmlns:meta:1.0').to_s
      text = meta_user_defined.text.to_s
      aod_param = "$aodp_#{meta_name.gsub! '-', '_'}"
      if eval("defined?(#{aod_param})") == 'global-variable'
        eval("#{aod_param} = '#{text}'")
      end
    end
  end
end

class StyleSubstitutor
  def initialize pre, template
    @pre = pre
    @template = template
    if descendants.count == 0
      methods.each do |method|
        method(method).call if !!(method =~ /^h_/)
      end
    # If there are subclasses, we instantiate them. Can't make it clever, be it so
    else
      descendants.each do |descendant|
        descendant.new @pre, @template
      end
    end
  end
  def descendants
    ObjectSpace.each_object(::Class).select {|c| c < self.class}
  end
  def h_subs_index
    index_style_list = @pre.xpath("//text:alphabetical-index-source//*/@text:style-name",
                                 'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0')
    index_style_list.each do |index_style|
      snr = " #{index_style} "
      index_style.value = $aodp_sn_index_separator if !!(snr =~ / index\_separator /)
      index_style.value = $aodp_sn_index_heading if !!(snr =~ / index\_heading /)
      index_style.value = $aodp_sn_index_1 if !!(snr =~ / index\_1 /)
      index_style.value = $aodp_sn_index_2 if !!(snr =~ / index\_2 /)
      index_style.value = $aodp_sn_index_3 if !!(snr =~ / index\_3 /)
      index_style.value = $aodp_sn_alphabetical_index_pagenum if !!(snr =~ / alphabetical\_index\_pagenum /)
    end
  end
  def h_subs_lists
    list_style_list = @pre.xpath("//text:list/@text:style-name", 
              'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0') 
    list_style_list.each do |list_style|
      re = / [ou]lp_s_([a-z-]+) /
      substitued_olist_style = " #{list_style} ".match(re)[1].gsub "-", "_"
      list_style.value = eval("$aodp_sn_list_#{substitued_olist_style}")
    end
  end
  def h_subs_links
    anchor_list = @pre.xpath("//text:a", 
              'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0') 
    anchor_list.each do |anchor|
      snr = ' ' + anchor['text:style-name'] + ' '
      if !!(snr =~ / adoc_a /) 
        if !!(snr =~ / toc\_entry /)
          anchor['text:style-name'] = "Index_20_Link"
          anchor['text:visited-style-name'] = "Index_20_Link"
        else
          anchor['text:style-name'] = $aodp_sn_a
          anchor['text:visited-style-name'] = $aodp_sn_a_visited
        end
      end
    end
  end
  def h_subs_footnotes
    footnotes_ref_style_list = 
      @pre.xpath("//text:span/@text:style-name[starts-with(., 'adoc_fra ')]", 
        'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0') 
    footnotes_ref_style_list.each do |footnote_ref_style|
      footnote_ref_style.value = $aodp_sn_footnote_anchor
    end
  end
  def h_subs_variable_set_fields
    variable_fields =
      @template.xpath("//text:variable-set|//text:variable-get",
        'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0')
    variable_fields.each do |variable_field|
      attr_name = variable_field["text:name"]
      if attr_name == 'title'
        node_to_insert = @pre.xpath("//a-od-params/title/node()",
                  'office' => 'urn:oasis:names:tc:opendocument:xmlns:office:1.0',
                  'xlink' => 'http://www.w3.org/1999/xlink')
        variable_field.after(node_to_insert)
        variable_field.remove
      end
      if attr_name == 'subtitle'
        node_to_insert = @pre.xpath("//a-od-params/subtitle/node()",
                                    'office' => 'urn:oasis:names:tc:opendocument:xmlns:office:1.0',
                                    'xlink' => 'http://www.w3.org/1999/xlink')
        variable_field.after(node_to_insert)
        variable_field.remove
      end
      pre_attribute = @pre.xpath("//a-od-params/attribute[@name='#{attr_name}']")
      unless pre_attribute.count == 0
        value = pre_attribute[0]["value"]
        unless value.nil?
          text_node = Nokogiri::XML::Text.new(value, @template)
          variable_field.after(text_node)
          variable_field.remove
        end
        #variable_set_field.content = value unless value.nil?
      end
    end
  end
end

=begin
tag::algorithm_description[]
== `Automatic styles` calculation

If you add you custom formatting to any paragraph Open Office simply generates `automatic style` that references parent (predefined style) and adds properties. Thee properties add or replace predefined style formatting.

Templating technology can't generate styles, but this converter adds formatting hints to the name of the style.  `AutoStyleSetter` transforms this hint into `automatic styles`.

`BasicPropSetSorter` chooses the right property setter class and property setter class sets parent (predefined) class and additional properties.

To extend style substitution just inherit from any property setter class, for example `BasicBlockImageParagraph`. Or from the basic sorter class `BasicPropSetSorter`.

All methods should start with `h_`.

end::algorithm_description[]
=end

class AutoStyleSetter
  def initialize(style_rep, contents)
    @style_rep = style_rep
    @contents = contents
    init_style_types
  end
  def init_style_types
    @style_types = 
      {
        "graphic": {
          "applies": ["draw:frame"],
          "name_attribute_prefix": "draw",
          "property_types": [
            "style:graphic-properties"
          ]
        },
        "text": {
          "applies": ["text:a", "text:span"],
          "name_attribute_prefix": "text",
          "property_types": [
            "style:text-properties"
          ]
        },
        "paragraph": {
          "applies": ["text:p", "text:h"],
          "name_attribute_prefix": "text",
          "property_types": [
            "style:paragraph-properties",
            "style:text-properties"
          ]
        },
        "table": {
          "applies": ["table:table"],
          "name_attribute_prefix": "table",
          "property_types": [
            "style:table-properties"
          ]
        },
        "table-column": {
          "applies": ["table:table-column"],
          "name_attribute_prefix": "table",
          "property_types": [
            "style:table-column-properties"
          ]
        },
        "table-row": {
          "applies": ["table:table-row"],
          "name_attribute_prefix": "table",
          "property_types": [
            "style:table-row-properties"
          ]
        },
        "table-cell": {
          "applies": ["table:table-cell"],
          "name_attribute_prefix": "table",
          "property_types": [
            "style:table-cell-properties"
          ]
        }
      }
  end
  def setAutoStyles
    @style_types.each do |type, definition|
      definition[:applies].each do |applied_tag|
        nodes = @contents.xpath("//#{applied_tag}/@#{definition[:name_attribute_prefix]}:style-name|//#{applied_tag}/@#{definition[:name_attribute_prefix]}:visited-style-name",
                           'table' => 'urn:oasis:names:tc:opendocument:xmlns:table:1.0',
                           'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0',
                           'draw' => 'urn:oasis:names:tc:opendocument:xmlns:drawing:1.0'
                          )
        nodes.each do |node|
          if !!("#{node}" =~ /^adoc_/) and not @style_rep.key?("#{node}")
            @style_rep["#{node}"] = {applies: applied_tag, type: "#{type}"}
            definition[:property_types].each do |property_type|
              @style_rep["#{node}"][property_type] = {}
            end
            BasicPropSetSorter.new "#{node}", @style_rep["#{node}"]
          end
          node.value = MiscMethods.normilize_style_name node.value
        end
      end
    end
  end
end

class BasicHelper
  def initialize(sn, sd)
    @sn = sn
    @snr = " #{sn} "
    @sd = sd
    # If no subclasses, we just run its methods
    if descendants.count == 0
      methods.each do |method|
        method(method).call if !!(method =~ /^h_/)
      end
    # If there are subclasses, we instantiate them. Can't make it clever, be it so
    else
      descendants.each do |descendant|
        descendant.new @sn, @sd
      end
    end
  end
  def descendants
    ObjectSpace.each_object(::Class).select {|c| c < self.class}
  end
end

class BasicPropSetSorter < BasicHelper
  def h_basic_table; BasicTable.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_t[ ]/) end
  def h_basic_table_column; BasicTableColumn.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_tc[ ]/) end
  def h_basic_table_row; BasicTableRow.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_tr[ ]/) end
  def h_basic_table_cell; BasicTableCell.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_tce[ ]/) end
  def h_basic_paragraph 
    if !!(@sn =~ /^adoc_p[ ]/)
      if !!(@snr =~ / in_cell_[0-9] /) and !!(@snr =~ / in_list_item_[0-9] /)
        BasicTableListParagraph.new(@sn, @sd)
      elsif !!(@snr =~ / in_cell_[0-9] /)
        BasicTableParagraph.new(@sn, @sd)
      elsif !!(@snr =~ / in_list_item_[0-9] /)
        BasicListParagraph.new(@sn, @sd)
      else
        BasicParagraph.new(@sn, @sd)  
      end
    end
  end
  def h_basic_blockimage_paragraph; BasicBlockImageParagraph.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_bip[ ]/) end
  def h_basic_table_caption; BasicTableCaption.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_tca[ ]/) end
  def h_basic_header; BasicSectionHeader.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_s[ ]/) end
  def h_basic_inline_quoted; BasicInlineQuoted.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_iq[ ]/) end
  def h_basic_list_caption; BasicListCaption.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_lca[ ]/) end
  def h_basic_image_frame; BasicImageFrame.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_if[ ]/) end
  def h_basic_image_caption; BasicImageCaption.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_ica[ ]/) end
  def h_basic_orientation; BasicOrientation.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_(p|s|tca|ica|lca|eca)[ ]/) end
  def h_basic_content_frame; BasicContentFrame.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_cf[ ]/) end
  def h_basic_content_frame_paragraph; BasicContentFrameParagraph.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_cfp[ ]/) end
  def h_basic_admonition_heading_paragraph; BasicAdmonitionHeadingParagraph.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_ahp[ ]/) end
  def h_basic_admonition_caption; BasicAdmonitionCaption.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_aca[ ]/) end
  def h_basic_example_caption; BasicExampleCaption.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_eca[ ]/) end
  def h_basic_listing_caption; BasicListingCaption.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_lica[ ]/) end
  def h_basic_listing_paragraph; BasicListingParagraph.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_lip[ ]/) end
  def h_basic_inline_callout; BasicInlineCallout.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_ic[ ]/) end
  def h_basic_callout_list_item_paragraph; BasicCalloutListItemParagraph.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_colp[ ]/) end
  def h_basic_callout_list_callout_number; BasicCalloutListCalloutNumber.new(@sn, @sd) if 
    !!(@sn =~ /^adoc_colcn[ ]/) end
  def h_basic_toc_table_column; BasicTocTableColumn.new(@sn, @sd) if
    !!(@sn =~ /^adoc_tocc[ ]/) end
  def h_basic_toc_cell; BasicTocCell.new(@sn, @sd) if
    !!(@sn =~ /^adoc_tocce[ ]/) end
  def h_basic_toc_paragraph; BasicTocParagraph.new(@sn, @sd) if
    !!(@sn =~ /^adoc_tocp[ ]/) end
  def h_basic_toc_header; BasicTocHeader.new(@sn, @sd) if
    !!(@sn =~ /^adoc_toch[ ]/) end
  def h_basic_toc_inline_quoted; BasicTocInlineQuoted.new(@sn, @sd) if
    !!(@sn =~ /^adoc_tociq[ ]/) end
  def h_basic_preamble_first_paragraph; BasicPreambleFirstParagraph.new(@sn, @sd) if
    !!(@sn =~ /^adoc_pr[ ]/) end
end


=begin
tag::notimplemented[]
== Table properties

* `frame` and `grid` are implemented only if (1) both are none, (2) `frame` is `topbot` and `grid` is `rows`, (3) `frame` is `sides` and `grid` is `cols`
* `float`
* `width` (always `100%`)
* `options = autowidth`

end::notimplemented[]
=end

class BasicTable < BasicHelper
  def h_general
    @sd["style:table-properties"]["style:rel-width"] = "100%"
  end
  def h_style_may_break_between_rows
    @sd["style:table-properties"]["style:may-break-between-rows"] =
      "false" if !!(@snr =~ / tp_o_unbreakable /)
  end
  def h_style_keep_with_next
    @sd["style:table-properties"]["fo:keep-with-next"] =
      "always" if !!(@snr =~ / keep_with_next /)
  end
  def h_fo_margins
    @sd["style:table-properties"]["fo:margin-top"] = $aodp_table_margin_top
    @sd["style:table-properties"]["fo:margin-bottom"] = $aodp_table_margin_bottom unless
      (@snr =~ / no_margin_bottom /)
    if !!(@snr =~ / in_cell_[0-9] /)
      @sd["style:table-properties"]["fo:margin-top"] = $aodp_ntable_margin_top
      @sd["style:table-properties"]["fo:margin-bottom"] = $aodp_ntable_margin_bottom unless
        (@snr =~ / no_margin_bottom /)
    end
  end
end


class BasicTableColumn < BasicHelper
  def h_style_rel_column_width 
    re = / tcp_rcw_([\d]+) /
    @sd["style:table-column-properties"]["style:rel-column-width"] = 
      @snr.match(re)[1] + '00*' if !!(@snr =~ re)
  end
end

class BasicTableRow < BasicHelper
  def h_set_row_keep_together
    @sd["style:table-row-properties"]["fo:keep-together"] =
      "always" if !!(@snr =~ / row_keep_together /)
  end
end

class BasicTableCell < BasicHelper
  def h_general
    @sd["style:table-cell-properties"]["fo:padding"] = "0.1cm"
  end
  def h_fo_border
    if !!(@snr =~ / tp_f_none /) and !!(@snr =~ / tp_g_none /)
    elsif !!(@snr =~ / tp_f_topbot /) and !!(@snr =~ / tp_g_rows /)
      @sd["style:table-cell-properties"]["fo:border-top"] = "0.5pt solid #000000"
      @sd["style:table-cell-properties"]["fo:border-bottom"] = "0.5pt solid #000000"
    elsif !!(@snr =~ / tp_f_sides /) and !!(@snr =~ / tp_g_cols /)
      @sd["style:table-cell-properties"]["fo:border-right"] = "0.5pt solid #000000"
      @sd["style:table-cell-properties"]["fo:border-left"] = "0.5pt solid #000000"
    else
      @sd["style:table-cell-properties"]["fo:border"] = "0.5pt solid #000000"
    end
  end
  def h_style_vertical_align
    re = / tcep_va_([a-z]+) /
    @sd["style:table-cell-properties"]["style:vertical-align"] =
      @snr.match(re)[1] if !!(@snr =~ re)      
  end
  def h_fo_background_color
    @sd["style:table-cell-properties"]["fo:background-color"] =
      "#f7f7f8" if !!(@snr =~ /( head )|( foot)/)
    @sd["style:table-cell-properties"]["fo:background-color"] =
      "#f7f7f8" if !!(@snr =~ / tcep_s_header /)
  end
end

class BasicParagraph < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_p
  end
end

class BasicTableParagraph < BasicHelper
  def h_parent_style_name
    re = /( head )|( tcep_s_header )/
    if !!(@snr =~ re)
      @sd[:parent_style_name] = $aodp_sn_tp_head
    else 
      @sd[:parent_style_name] = $aodp_sn_tp
    end
  end
  def h_fo_text_align
    # First cell properties
    re = / tcep_ha_([a-z]+) /
    @sd["style:paragraph-properties"]["fo:text-align"] =
      @snr.match(re)[1] if !!(@snr =~ re)   
    # Then custom properties   
    re = / text-align-([a-z]+) /
    @sd["style:paragraph-properties"]["fo:text-align"] = 
      @snr.match(re)[1] if !!(@snr =~ re)      
  end
end

class BasicTableCaption < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_tca
  end
end

class BasicSectionHeader < BasicHelper
  def h_parent_style_name
    re = / sp_sl_([1-8]) /
    section_level = @snr.match(re)[1]
    if !!(@snr =~ / sp_sn_appendix /)
      @sd[:parent_style_name] = $aodp_sn_appendix
    else
      if !!(@snr =~ / sp_s_discrete /)
        @sd[:parent_style_name] = eval("$aodp_sn_h#{section_level}_discrete")
      else
        @sd[:parent_style_name] = eval("$aodp_sn_h#{section_level}")
      end
    end
  end
end

class BasicInlineQuoted < BasicHelper
  def h_parent_style_name
    re = / t_([a-z]+) /
    type = @snr.match(re)[1]
    if type != "unquoted"
      @sd[:parent_style_name] = eval("$aodp_sn_span_#{type}")
    else
      ['small', 'big', 'underline'].each do |unquoted_type|
        if !!(@snr =~ / #{unquoted_type} /)
          @sd[:parent_style_name] = eval("$aodp_sn_span_unquoted_#{unquoted_type}")
          @sd[:parent_style_name] = eval("$aodp_sn_span_unquoted_table_#{unquoted_type}") if !!(@snr =~ / in_cell_[0-9] /)
        end
      end
    end
  end
end


class BasicListCaption < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_lca
    @sd[:parent_style_name] = $aodp_sn_tlca if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicListParagraph < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_lp
  end
end

class BasicTableListParagraph < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_tlp
  end
end

class BasicBlockImageParagraph < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_bip
    @sd[:parent_style_name] = $aodp_sn_sp if !!(@snr =~ / ip_s_amp /)
  end
end

=begin
tag::plusfeatures[]
== Image attributes

* fitrect -- dimensions to fit image in like `100x50mm`. Only mm unit is supported
* srcdpi -- resolution of the source image. Usually when we add something to our diagram (like new process to the process diagram), the dimensions of the image change, but resolution doesn't change. Default -- 100 dpi.
* svgunit -- units, in which svg dimensions are defined

This attribute doesn't eliminate the need to have a set of image for each resolution, but for simple situation it is quite enough.

If `fitrect` is not defined in inline images it is assumed from the following attributes:

* def_100_percent_mm -- width
* def_inline_height_mm -- height
end::plusfeatures[]
=end

class BasicImageFrame < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_if
  end
  def h_svg_width_height
    if !!(@snr =~ / ip_ibt_inline /) and !!(@snr !~ / ip_w_/) and !!(@snr !~ / ip_fr_/)
      @snr += "ip_fr_#{$aodp_100_percent_mm}x#{$aodp_inline_height_mm}mm "
    end

    if !!(@snr =~ / ip_s_amp /)
      # maximum as a square with max percent for formulae looks quite logical 
      # at least when writing this comment
        @snr += "ip_fr_#{$aodp_100_percent_mm}x#{$aodp_100_percent_mm}mm ip_sd_#{$aodp_stem_dpi} "
    end

    re = / ip_w_([0-9\.]+[a-z_]+) /
    unless !!(@snr =~ re)
      img_ew = "70_prc"
    else
      img_ew = @snr.match(re)[1]
    end



    re = / ip_t_([a-z]+) /
    type = @snr.match(re)[1]

    re = / ip_x2y_([0-9]+)x([0-9]+) /
    img_rw = @snr.match(re)[1].to_f 
    img_rh = @snr.match(re)[2].to_f

    re = / ip_fr_([0-9\.]+x[0-9\.]+[a-z]+) /
    if !!(@snr =~ re)
      fitrect = MiscMethods.get_normalized_fitrect_attribute @snr.match(re)[1]
      re = /([0-9\.]+)x([0-9\.]+)/
      rect_w = fitrect.match(re)[1].to_f
      rect_h = fitrect.match(re)[2].to_f
    end

    re = / ip_sd_([0-9]+) /
    srcdpi = $aodp_assume_src_dpi
    srcdpi = @snr.match(re)[1].to_f if !!(@snr =~ re)

    re = / ip_su_([a-z]+) /
    svgunit = 'px'
    svgunit = @snr.match(re)[1] if !!(@snr =~ re)

    # if guessing then use fictrect strategy with a 100% square minus list indent
    # todo should count 100% from parent inner width
    guess_width = false
    if !!(@snr !~ / ip_fr_/) && !!(@snr !~ / ip_w_[0-9]/)
      list_level = 0
      re = / in_list_item_([0-9]) /
      list_level = @snr.match(re)[1].to_f if !!(@snr =~ re)
      list_first_level_indent_mm = MiscMethods.text_measurement_to_mm $aodp_list_first_level_indent
      list_other_levels_indent_mm = MiscMethods.text_measurement_to_mm $aodp_list_other_levels_indent
      rect_w = $aodp_100_percent_mm
      rect_h = $aodp_100_percent_mm
      if list_level > 0
        rect_w = rect_w - list_first_level_indent_mm - (list_level - 1) *  list_other_levels_indent_mm
      end
      guess_width = true
    end


    if !!(@snr !~ / ip_fr_/) && !guess_width
      re = /([0-9\.]+)([a-z_]+)/
      img_cw = img_ew.match(re)[1].to_f
      img_cunit = img_ew.match(re)[2]
      if img_cunit == "_px"
        img_cw = img_cw / srcdpi * 25.4
        img_cunit = "mm"
      elsif img_cunit == "_prc"
        img_cw = ($aodp_100_percent_mm * img_cw/100).round(1)
        img_cunit = "mm"
      end
      y2x_ratio = 100.0
      y2x_ratio = img_rh / img_rw * 100.0
      img_ch = (img_cw * y2x_ratio.to_f / 100).round(1)
      @sd["style:graphic-properties"]["svg:width"] = "#{img_cw}#{img_cunit}"
      @sd["style:graphic-properties"]["svg:height"] = "#{img_ch}#{img_cunit}"
    else
      if type == "svg" and svgunit != 'px'
        img_rw = MiscMethods.measurement_to_mm(img_rw, svgunit)
        img_rh = MiscMethods.measurement_to_mm(img_rh, svgunit)
      else
        img_rw = img_rw / srcdpi * 25.4
        img_rh = img_rh / srcdpi * 25.4
      end
      optimal_dimensions = MiscMethods.get_optimal_dimensions(img_rw, img_rh, rect_w, rect_h)
      @sd["style:graphic-properties"]["svg:width"] =  "#{optimal_dimensions[:img_cw]}mm"
      @sd["style:graphic-properties"]["svg:height"] = "#{optimal_dimensions[:img_ch]}mm"
    end
  end
  def h_style_vertical_pos
    @sd["style:graphic-properties"]["style:vertical-pos"] = 
      "middle"
  end
  def h_style_vertical_rel
    @sd["style:graphic-properties"]["style:vertical-rel"] = 
      "text"
  end
end

class BasicImageCaption < BasicHelper 
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_ica
  end
end


=begin
tag::plusfeatures[]

== Page orientation

Page orientation is regulated by special roles: portrait, landscape.

The role can be applied to paragraph, section and caption (table, figure, list, example) elements.

NOTE: Page orientation roles switch orientation for all elements to the end of the document. It can be switched back starting at any supported element

end::plusfeatures[]
=end

class BasicOrientation < BasicHelper 
  def h_master_page_name
    re = / (portrait|landscape) /
    @sd[:master_page_name] = eval("$aodp_sn_orientation_#{@snr.match(re)[1]}") if !!(@snr =~ re)
  end
end

=begin
tag::notimplemented[]

== Frame usage

Admonitions and examples are created with the help of a frame. 

Frame width in Open Document format can't be defined in relation to paragraph, only paragraph area. So in lists frames will start from the left page margin.

As frames are aligned to right, it is possible to introduce some attribute that would decrease frame width. The example is in the `a-od-my` custom library of this project: list-level1-admonition.

IMPORTANT: Frames don't flow across pages

end::notimplemented[]
=end

class BasicContentFrame < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_af if !!(@snr =~ / cft_admonition /)
    @sd[:parent_style_name] = $aodp_sn_ef if !!(@snr =~ / cft_example /)
  end
  def h_style_vertical_pos
    @sd["style:graphic-properties"]["style:vertical-pos"] = "from-top"
    @sd["style:graphic-properties"]["style:vertical-rel"] = "paragraph-content"
    @sd["style:graphic-properties"]["text:anchor-type"] = "paragraph" 
    @sd["style:graphic-properties"]["style:flow-with-text"] = "true" 
    @sd["style:graphic-properties"]["style:wrap"] = "none" 
  end
  def h_horizontal_pos
    @sd["style:graphic-properties"]["style:horizontal-pos"] = "right"
    @sd["style:graphic-properties"]["style:horizontal-rel"] = "paragraph"
    @sd["style:graphic-properties"]["style:rel-width"] = "100%"
    #@sd["style:graphic-properties"]["svg:width"] = $aodp_100_percent_mm
  end
end


class BasicContentFrameParagraph < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_cfp
    @sd[:parent_style_name] = $aodp_sn_tcfp if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicAdmonitionHeadingParagraph < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_ahp
    @sd[:parent_style_name] = $aodp_sn_tahp if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicAdmonitionCaption < BasicHelper 
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_aca
    @sd[:parent_style_name] = $aodp_sn_taca if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicExampleCaption < BasicHelper 
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_eca
    @sd[:parent_style_name] = $aodp_sn_teca if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicListingCaption < BasicHelper 
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_lica
    @sd[:parent_style_name] = $aodp_sn_tlica if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicListingParagraph < BasicHelper 
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_lip
    @sd[:parent_style_name] = $aodp_sn_tlip if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicInlineCallout < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = eval("$aodp_sn_span_callout")
  end
end

class BasicCalloutListItemParagraph < BasicHelper 
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_colp
    @sd[:parent_style_name] = $aodp_sn_tcolp if !!(@snr =~ / in_cell_[0-9] /)
  end
end

class BasicCalloutListCalloutNumber < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_span_callout_list_callout_number
  end
end


class BasicTocTableColumn < BasicHelper
  def h_style_column_width
    re = / sec_pn /
    @sd["style:table-column-properties"]["style:column-width"] =
      "#{$aodp_toc_pn_column}"  if !!(@snr =~ re)
    re = / sec_title /
    @sd["style:table-column-properties"]["style:column-width"] =
      "#{$aodp_toc_title_column}"  if !!(@snr =~ re)
  end
end

class BasicTocCell < BasicHelper
  def h_style_vertical_align
    re = / sec_pn /
    @sd["style:table-cell-properties"]["style:vertical-align"] = "bottom" if !!(@snr =~ re)
  end
end

class BasicTocParagraph < BasicHelper
  def h_parent_style_name
    re = / slevel\_([0-9]) /
    slevel = @snr.match(re)[1]
    @sd[:parent_style_name] = eval("$aodp_sn_toc_h#{slevel}")
    re = / sec_pn /
    @sd[:parent_style_name] = eval("$aodp_sn_toc_pn_h#{slevel}") if !!(@snr =~ re)
  end
  def h_style_margin_left
    re = / sec_pn /
    @sd["style:paragraph-properties"]["fo:margin-left"] = "0mm" if !!(@snr =~ re)
  end
end

class BasicTocHeader < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = eval("$aodp_sn_toc_header")
  end
end

class BasicTocInlineQuoted < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_toc_dots_title if !!(@snr =~ / dots_title /)
    @sd[:parent_style_name] = $aodp_sn_toc_dots_page_number if !!(@snr =~ / dots_page_number /)
    @sd[:parent_style_name] = $aodp_sn_toc_dots_space_page_number if !!(@snr =~ / dots_space_page_number /)
  end
end

class BasicPreambleFirstParagraph < BasicHelper
  def h_parent_style_name
    @sd[:parent_style_name] = $aodp_sn_preamble_before_paragraph if !!(@snr =~ / before-paragraph /)
  end
end

class StyleToXml
  def self.to_doc style_rep, xml_node
    style_rep.each do |sn, sd|
      #puts sn, sd if !!(sn =~ /^adoc_tce /)   # main debug
      style_node =  Nokogiri::XML::Node.new "style:style", xml_node.document
      style_node["style:name"] = MiscMethods.normilize_style_name sn
      style_node["style:family"] = sd[:type]
      style_node["style:parent-style-name"] = 
        sd[:"parent_style_name"] if sd.key?(:"parent_style_name")
      style_node["style:master-page-name"] = 
        sd[:"master_page_name"] if sd.key?(:"master_page_name")
      sd.each do |sd_attribute, sd_attribute_value|
        if not [:applies, :type, :parent_style_name, :master_page_name].include?(sd_attribute)  
          style_family = sd_attribute.match(/:(.*)/)[1]
          property_node = Nokogiri::XML::Node.new "style:#{style_family}", xml_node.document
          style_node.add_child property_node
          sd_attribute_value.each do |property_attribute, value|
            property_node[property_attribute] = value
          end
        end
      end
      xml_node.add_child style_node 
    end
  end
end

custom_processors = []
input_file = ""
output_file = ""
template_file = "#{__dir__}/basic-template.fodt"

OptionParser.new do |parser|
  parser.on("-c", "--custom LIBRARY",
            "Require the custom processor (several processors are allowed)") do |p_custom_processor|
    custom_processors << p_custom_processor
  end
  parser.on("-i", "--input FILE",
            "Input file") do |p_input_file|
    input_file = p_input_file
  end
  parser.on("-o", "--output FILE",
            "Output file") do |p_output_file|
    output_file = p_output_file
  end
  parser.on("-f", "--template FILE",
            "Template .fodt file") do |p_template_file|
    template_file = p_template_file
  end
  parser.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

custom_processors.each do |cp|
  cp = "./#{cp}" if cp[0] != '/'
  require cp
end

template = File.open(template_file) { |f| Nokogiri::XML(f) }
pre = File.open(input_file) { |f| Nokogiri::XML(f) }

Initiator.new(template)
StyleSubstitutor.new(pre, template)

tagged_nodes =
  template.xpath("/*/*/office:text/*[descendant-or-self::*[contains(text(),'asciidoc-od')]" + 
      " and local-name() != 'table-of-content']",
       "office" => "urn:oasis:names:tc:opendocument:xmlns:office:1.0")
body_to_insert =  
  pre.xpath("/office:body/office:text/*", 
            'office' => 'urn:oasis:names:tc:opendocument:xmlns:office:1.0', 
            'xlink' => 'http://www.w3.org/1999/xlink') 
tagged_nodes[0].add_previous_sibling(body_to_insert) if tagged_nodes.count > 0
done = false
tagged_nodes[0].xpath("following-sibling::*").each do |node|
  done = 
    true if node.xpath("descendant-or-self::*[contains(text(),'asciidoc-od')]").count > 0
  node.remove
  break if done
end

tagged_nodes[0].remove

AutoStyleSetter.new(style_rep = Hash.new, template).setAutoStyles
StyleToXml.to_doc style_rep,
                  template.xpath("//office:automatic-styles",
                                 "office" => "urn:oasis:names:tc:opendocument:xmlns:office:1.0").first

File.write(output_file, template.to_xml)





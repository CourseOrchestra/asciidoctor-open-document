require 'rouge'

class MyBasicPropSetSorter < BasicPropSetSorter
  # Rouge syntax highlighter
  def h_my_list_chunk 
    # puts @sn
    MyListChunk.new(@sn, @sd) if !!(@sn =~ /^adoc_lich[ ]/) 
  end
end

# You may define paragraph alignment with the role 
# text-align-[left|center|justified|right]
class MyParagraph < BasicParagraph
  def h_fo_text_align
    re = / text-align-([a-z]+) /
    @sd["style:paragraph-properties"]["fo:text-align"] = 
      " #{@sn} ".match(re)[1] if !!(" #{@sn} " =~ re)      
  end
end

# an example of list-level1-admonition
class MyBasicContentFrame < BasicContentFrame
  # this method is redefined
  def h_horizontal_pos
    @sd["style:graphic-properties"]["style:horizontal-pos"] = "right"
    @sd["style:graphic-properties"]["style:horizontal-rel"] = "paragraph"
    if !!(@snr =~ / list-level1-admonition /)
      @sd["style:graphic-properties"]["style:rel-width"] = 
        "#{($def_100_percent_mm.to_f - 13.3) / $def_100_percent_mm * 100}%)"
    else
      @sd["style:graphic-properties"]["style:rel-width"] = "100%"
    end
  end
end

# an example of custom handling equation number

class MyPreprocessor < StyleSubstitutor
  def h_eq_caption_preprocess
    eq_caption_nodes = 
      @pre.xpath("//text:p[starts-with(@text:style-name, 'adoc_ica ')]", 
        'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0') 
    eq_caption_nodes.each do |eq_caption_node|
      if !!(eq_caption_node['text:style-name'] + ' ' =~ / ip_s_amp /)
        # puts eq_caption_node.text, eq_caption_node['text:style-name'] #, eq_node
        tn = Nokogiri::XML::Text.new("#{eq_caption_node.text}", @pre)

        eq_node = eq_caption_node.xpath('preceding-sibling::*[1]')[0]
        # Looks like some Libre Office bug without the following line
        # vertical centering works wrong
        eq_node.first_element_child.before('<text:s text:c="1"/>')
        eq_node.last_element_child.after('<text:s text:c="3"/>')
        eq_node.add_child(tn)
        eq_caption_node.remove
      end
    end
  end


  def h_rouge_syntax_highlighting
    color_scheme = {
      "w": "adoc_lich hl_r_clr_303030",
      "err": "adoc_lich hl_r_clr_151515 hl_r_bcgclr_ac4142",
      "c": "adoc_lich hl_r_clr_505050",
      "cd": "adoc_lich hl_r_clr_505050",
      "cm": "adoc_lich hl_r_clr_505050",
      "c1": "adoc_lich hl_r_clr_505050",
      "cs": "adoc_lich hl_r_clr_505050",
      "cp": "adoc_lich hl_r_clr_f4bf75",
      "nt": "adoc_lich hl_r_clr_f4bf75",
      "o": "adoc_lich hl_r_clr_d0d0d0",
      "ow": "adoc_lich hl_r_clr_d0d0d0",
      "p": "adoc_lich hl_r_clr_d0d0d0",
      "pi": "adoc_lich hl_r_clr_d0d0d0",
      "gi": "adoc_lich hl_r_clr_90a959",
      "gd": "adoc_lich hl_r_clr_ac4142",
      "gh": "adoc_lich hl_r_clr_6a9fb5 hl_r_bcgclr_151515 hl_r_fw_bold",
      "k": "adoc_lich hl_r_clr_aa759f",
      "kn": "adoc_lich hl_r_clr_aa759f",
      "kp": "adoc_lich hl_r_clr_aa759f",
      "kr": "adoc_lich hl_r_clr_aa759f",
      "kv": "adoc_lich hl_r_clr_aa759f",
      "kc": "adoc_lich hl_r_clr_d28445",
      "kt": "adoc_lich hl_r_clr_d28445",
      "kd": "adoc_lich hl_r_clr_d28445",
      "s": "adoc_lich hl_r_clr_90a959",
      "sb": "adoc_lich hl_r_clr_90a959",
      "sc": "adoc_lich hl_r_clr_90a959",
      "sd": "adoc_lich hl_r_clr_90a959",
      "s2": "adoc_lich hl_r_clr_90a959",
      "sh": "adoc_lich hl_r_clr_90a959",
      "sx": "adoc_lich hl_r_clr_90a959",
      "s1": "adoc_lich hl_r_clr_90a959",
      "sr": "adoc_lich hl_r_clr_75b5aa",
      "si": "adoc_lich hl_r_clr_8f5536",
      "se": "adoc_lich hl_r_clr_8f5536",
      "nn": "adoc_lich hl_r_clr_f4bf75",
      "nc": "adoc_lich hl_r_clr_f4bf75",
      "no": "adoc_lich hl_r_clr_f4bf75",
      "na": "adoc_lich hl_r_clr_6a9fb5",
      "nf": "adoc_lich hl_r_clr_6a9fb5",
      "n": "adoc_lich hl_r_clr_6a9fb5",
      "m": "adoc_lich hl_r_clr_90a959",
      "mf": "adoc_lich hl_r_clr_90a959",
      "mh": "adoc_lich hl_r_clr_90a959",
      "mi": "adoc_lich hl_r_clr_90a959",
      "il": "adoc_lich hl_r_clr_90a959",
      "mo": "adoc_lich hl_r_clr_90a959",
      "mb": "adoc_lich hl_r_clr_90a959",
      "mx": "adoc_lich hl_r_clr_90a959",
      "vi": "adoc_lich hl_r_clr_6a9fb5",
      "vg": "adoc_lich hl_r_clr_6a9fb5",
      "ss": "adoc_lich hl_r_clr_90a959"}
    listing_caption_nodes = 
      @pre.xpath("//text:p[starts-with(@text:style-name, 'adoc_lip ')]", 
        'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0') 

    listing_caption_nodes.each do |listing_caption_node|
      snr = " " +  listing_caption_node["text:style-name"] + " "
      re = / lip_l_([a-zA-Z0-9-]+) /

      if !!(snr =~ re)
        language = snr.match(re)[1]
      else
        next 
      end
      begin
        Rouge.highlight('abc', language, 'html')
      rescue Exception => e
         unknown_lexer = true if e.message.strip == 'unknown lexer'
      end
      if unknown_lexer
        puts "Warning: #{e.message} #{language}"
        next
      end 
      # replace callout with a number of `~` for them to be interpreted as a chunk
      callouts = listing_caption_node.xpath(".//text:span[starts-with(@text:style-name, 'adoc_ic ')]", 
        'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0')
      callouts.each do |callout|
        call_out_r = "~" * callout.text.to_i
        callout.after "~~~~" + call_out_r
        callout.remove
      end
      # replace line-breaks
      eols = listing_caption_node.xpath(".//text:line-break", 
        'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0')
      eols.each do |eol|
        eol.after("\n")
        eol.remove
      end
      # replace spaces
      spaces = listing_caption_node.xpath(".//text:s", 
        'text' => 'urn:oasis:names:tc:opendocument:xmlns:text:1.0')
      spaces.each do |space|
        space.after(' ')
        space.remove
      end


      listing_content = listing_caption_node.text
      listing_caption_node.children.remove
      
      # rouge html back to open document
      Rouge.highlight(listing_content, language, 'html') do |chunk|
        content_node = listing_caption_node
        chunk_text = chunk

        if !!("#{chunk}" =~ /span/)
          chunk_xml = Nokogiri::XML(chunk)
          chunk_text = chunk_xml.xpath("/span")[0].text
          chunk_class = chunk_xml.xpath("/span/@class")[0].text
          chunk_style = color_scheme[chunk_class.to_sym]
          Nokogiri::XML::Builder.with(listing_caption_node) do |xml|
            xml['text'].span('text:style-name' => chunk_style) 
          end
          content_node = listing_caption_node.last_element_child 
        end
        
        loop_s = chunk_text
        while loop_s.length > 0
          if loop_s[0] == " "
            Nokogiri::XML::Builder.with(content_node) do |xml|
              xml['text'].s('text:c' => '1')
            end
            loop_s = loop_s[1..-1]
          elsif loop_s[0] == "\n"
            Nokogiri::XML::Builder.with(content_node) do |xml|
              xml['text'].send(:"line-break")
            end
            loop_s = loop_s[1..-1]
          elsif !!(loop_s =~ /~~~~[~]+/)
            callout_num = chunk.match(/~~~~([~]+)/)[1].length.to_s
            Nokogiri::XML::Builder.with(content_node) do |xml|
              xml['text'].span(callout_num, 'text:style-name' => 'adoc_ic ') 
            end
            next_char_start = callout_num.to_i + 4
            loop_s = loop_s[next_char_start..-1]
          else
            Nokogiri::XML::Builder.with(content_node) do |xml|
              xml.text loop_s[0]
            end
            loop_s = loop_s[1..-1]
          end
              
        end
      end
      # puts listing_caption_node
    end
  end
end

class MyListChunk < BasicHelper
  def h_fo_color
    re = / hl_r_clr_([0-9a-f]{6}) /
    @sd["style:text-properties"]["fo:color"] = "#" + @snr.match(re)[1] if !!(@snr =~ re)
  end
  def h_fo_background_color
    re = / hl_r_bcgclr_([0-9a-f]{6}) /
    @sd["style:text-properties"]["fo:background-color"] = "#" + @snr.match(re)[1] if !!(@snr =~ re)
  end
  def h_fo_font_weight
    re = / hl_r_fw_bold /
    @sd["style:text-properties"]["fo:font-weight"] = "bold" if !!(@snr =~ re)
  end
end


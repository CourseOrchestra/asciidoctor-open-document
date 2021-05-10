require "minitest/autorun"
require_relative "../lib/a-od-producer/misc.rb"

class TestMiscMethods < Minitest::Test
  describe "Method measurement_to_mm " do
    it "should correctly calculate measurement in mm" do
      assert_equal MiscMethods.measurement_to_mm(2, "mm").round(3), 1.000
      assert_equal MiscMethods.measurement_to_mm(1, "cm").round(3), 10.000
      assert_equal MiscMethods.measurement_to_mm(1, "pt").round(3), 0.353
      assert_equal MiscMethods.measurement_to_mm(1, "pc").round(3), 4.233
      assert_equal MiscMethods.measurement_to_mm(1, "in").round(3), 25.400
      assert_raises RuntimeError do
        MiscMethods.measurement_to_mm(1, "inches")
      end
    end
  end
  describe "Method get_normalized_rectfit_attribute" do
    it "should return normalized rectfit, for now, only mm are accepted" do
      assert_equal MiscMethods.get_normalized_rectfit_attribute("20x10mm"), "20x10mm"
    end
    it "should raise error on anything not mm like" do
      assert_raises RuntimeError do
        MiscMethods.get_normalized_rectfit_attribute("20x10")
      end
      assert_raises RuntimeError do
        MiscMethods.get_normalized_rectfit_attribute("20x10in")
      end
    end
  end
  describe "Method get_optimal_dimensions" do
    it "should return optimal dimensions" do
      assert_equal MiscMethods.get_optimal_dimensions(20,10, 40, 20),  {img_cw: 20,  img_ch: 10}
      assert_equal MiscMethods.get_optimal_dimensions(20, 10, 30, 5),  {img_cw: 10,  img_ch: 5}
      assert_equal MiscMethods.get_optimal_dimensions(20, 10, 5, 15),  {img_cw: 5,   img_ch: 2.5}
      assert_equal MiscMethods.get_optimal_dimensions(20, 10, 10, 10), {img_cw: 10,  img_ch: 5}
      assert_equal MiscMethods.get_optimal_dimensions(2, 1, 0.5, 10),  {img_cw: 0.5, img_ch: 0.25}
    end
  end
  describe "Method normilize_style_name" do
    it "should substitute incorrect chars" do
      assert_equal MiscMethods.normilize_style_name("adoc_p smth"), "adoc_p_20_smth"
    end
  end
end

require 'nokogiri'

class TestNokogiriCornerCase
  describe "Nokogiri" do
    before do
      @xml_text_src = <<-TESTXML
        <p1:a xmlns:p1="ns1" xmlns:p2="ns2">
          <p1:b p2:c="d">
        </p1:a>
        TESTXML
      @xml_text_dest = <<-TESTXML
        <p1:a xmlns:p1="ns1" xmlns:p2="ns2">
        </p1:a>
        TESTXML
      @xml_doc_src = Nokogiri::XML @xml_text_src
      @xml_doc_dest = Nokogiri::XML @xml_text_dest
    end
    it "should not (probably) but loses attribute namespace" do
      ns = {'p1': "ns1", 'p2': "ns2"}
      node_dest = @xml_doc_dest.xpath("//p1:a", ns)[0]
      node_to_insert = @xml_doc_src.xpath("//p1:b", ns)[0]
      node_dest.add_child node_to_insert
      assert_nil @xml_doc_dest.xpath("/p1:a/p1:b", 
                                       ns)[0].attribute_with_ns('c', 'ns2'),
        "check attribute with ns"
      node_dest.xpath("//*/@c").each do |node|
        node.parent["p2:c"] = node.to_s
        node.remove
      end
      assert_equal @xml_doc_dest.xpath("/p1:a/p1:b", 
                                       ns)[0].attribute_with_ns('c', 'ns2').to_s, 
        "d", "check namespace restored"
    end
  end
end

#class TestAttributeNsCopied
#  describe "Nokogiri" do
#    before do
#      @xml_text_src = <<-TESTXML
#        <p1:a xmlns:p1="ns1" xmlns:p2="ns2">
#          <p1:b p2:c="d">
#        </p1:a>
#        TESTXML
#      @xml_text_dest = <<-TESTXML
#        <p1:a xmlns:p1="ns1" xmlns:p2="ns2">
#        </p1:a>
#        TESTXML
#      @xml_doc_src = Nokogiri::XML @xml_text_src
#      @xml_doc_dest = Nokogiri::XML @xml_text_dest
#    end
#    it "should not lose attribute namespace" do
#      ns = {'p1': "ns1", 'p2': "ns2"}
#      node_dest = @xml_doc_dest.xpath("//p1:a", ns)[0]
#      node_to_insert = @xml_doc_src.xpath("//p1:b", ns)[0]
#      node_dest.add_child node_to_insert
#      assert_equal @xml_doc_dest.xpath("/p1:a/p1:b", 
#                                       ns)[0].attribute_with_ns('c', 'ns2').to_s, 
#        "d", "check namespace remained"
#    end
#  end
#end

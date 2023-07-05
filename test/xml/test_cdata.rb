# frozen_string_literal: true

require "helper"

describe Nokogiri::XML::CDATA do
  describe ".new" do
    it "acts like a constructor" do
      doc = Nokogiri::XML::Document.new
      node = Nokogiri::XML::CDATA.new(doc, "foo")

      assert_instance_of(Nokogiri::XML::CDATA, node)
      assert_equal("foo", node.content)
      assert_same(doc, node.document)
      assert_predicate(node, :cdata?)
      assert_equal("#cdata-section", node.name)
    end

    it "accepts a node as the first parameter but warns about it" do
      doc = Nokogiri::XML::Document.new
      related_node = Nokogiri::XML::Element.new("foo", doc)
      node = nil

      assert_output(nil, /Passing a Node as the first parameter to CDATA\.new is deprecated/) do
        node = Nokogiri::XML::CDATA.new(related_node, "foo")
      end
      assert_instance_of(Nokogiri::XML::CDATA, node)
      assert_equal("foo", node.content)
      assert_same(doc, node.document)
    end

    it "has nil content when passed nil" do
      node = Nokogiri::XML::CDATA.new(Nokogiri::XML::Document.new, nil)

      assert_instance_of(Nokogiri::XML::CDATA, node)
      assert_nil(node.content)
    end

    it "does not accept anything but a string" do
      doc = Nokogiri::XML::Document.new
      assert_raises(TypeError) { Nokogiri::XML::CDATA.new(doc, 1.234) }
      assert_raises(TypeError) { Nokogiri::XML::CDATA.new(doc, {}) }
    end
  end

  it "supports #content and #content=" do
    doc = Nokogiri::XML::Document.new
    node = Nokogiri::XML::CDATA.new(doc, "foo")

    assert_equal("foo", node.content)

    node.content = "& <foo> &amp;"

    assert_equal("& <foo> &amp;", node.content)
    assert_equal("<![CDATA[& <foo> &amp;]]>", node.to_xml)

    node.content = "foo ]]> bar"

    assert_equal("foo ]]> bar", node.content)
  end
end

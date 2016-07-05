require 'test_helper'

class SqlTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "resolver returns a template with the saved body" do
  	resolver = SqlTemplate::Resolver.new
  	details = { formats: [:html], locale: [:en], handlers: [:erb] }

  	# 1) Assert our resolver cant find any template as the db is empty
  	assert resolver.find_all("index", "posts", false, details).empty?

  	# 2) Create a template
  	SqlTemplate.create!(
  		body: "<%= 'Hi from SqlTemplate!' %>",
  		path: "posts/index",
  		format: "html",
  		locale: "en",
  		handler: "erb",
  		partial: false
  		)

  	template = resolver.find_all("index", "posts", false, details).first
  	assert_kind_of ActionView::Template, template

  	assert_equal "<%= 'Hi from SqlTemplate!' %>", template.source
  	assert_kind_of ActionView::Template::Hanlders::ERB, template.handler
  	assert_equal [:html], template.formats
  	assert_equal "posts/index", template.virtual_path
  	assert_match %r[SqlTemplate - \d+ - "posts/index"], template.identifier
  	
  end
end

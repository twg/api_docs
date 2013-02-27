require File.expand_path('test_helper', File.dirname(__FILE__))

class ApiDocs::DocsHelperTest < ActionView::TestCase
  
  def test_display_body_with_json
    action = {
      'params' => {
        'format' => 'json'
      },
      'body' => JSON.parse('{"foo":"bar"}')
    }

    assert_equal display_body(action), "{\n  \"foo\": \"bar\"\n}"
  end

  def test_display_body_without_json
    action = {
      'params' => {},
      'body' => JSON.parse('{"foo":"bar"}')
    }

    assert_equal display_body(action), "{\n  \"foo\": \"bar\"\n}"
  end

  def test_display_body_with_xml
    xml = '<?xml version="1.0" encoding="UTF-8"?><foo>bar</foo>'

    action = {
      'params' => {
        'format' => 'xml'
      },
      'body' => xml
    }

    assert_equal display_body(action), xml
  end
end
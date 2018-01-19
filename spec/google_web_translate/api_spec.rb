RSpec.describe GoogleWebTranslate::API do
  it 'generates the correct token' do
    api = described_class.new(debug: ENV['DEBUG'])
    stub_requests(api)

    string = 'hello'
    expected_token = '550246.919607'
    token = api.send(:tk, string)
    expect(token).to eq(expected_token)
  end

  it 'returns data from the api' do
    api = described_class.new(debug: ENV['DEBUG'])
    stub_requests(api)

    string = 'right'
    from = 'en'
    to = 'de'

    result = api.translate(string, from, to)
    expect(result.translation).to eq('Recht')
    expect(result.alternatives).to eq(%w[Recht richtig rechts])
  end

  def stub_requests(api)
    html_response = fixture_read('main.html')
    json_response = fixture_read('single.json')
    desktop_js_response = fixture_read('desktop_module_main.js')

    # first request: gets main html
    stub_url_request(described_class::URL_MAIN, html_response)
    # second request: gets main desktop js
    stub_url_request(/desktop_module_main.js/, desktop_js_response)
    # third request: to google api
    stub_url_request(/translate_a/, json_response)

    #allow(api).to receive(:fetch_url_response)
    #  .and_return(response1, response2, response3)
  end

  def stub_url_request(url, response_body)
    stub_request(:get, url).
          with(headers: test_http_headers).
          to_return(status: 200, body: response_body, headers: {})

    #response = double(:response)
    #allow(response).to receive(:body).and_return(response_body)
    #response
  end
end

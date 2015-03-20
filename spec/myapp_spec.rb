require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Кредитные сведения')
  end

  it 'should redirect to / with no params' do
  	post '/result', params = { percent: "", credit: "", term: "" }
  	expect(last_response).to be_redirect
  	follow_redirect!
  	expect(last_response.body).to include('Кредитные сведения')
  	expect(last_request.url).to eql "http://example.org/"
  end

  it 'should redirect to result with correct params' do
  	post '/result', params = { percent: '12', credit: '20', term: '12'}
  	expect(last_response).to be_redirect
  	follow_redirect!
  	expect(last_request.url).to eql 'http://example.org/result'
  end
end
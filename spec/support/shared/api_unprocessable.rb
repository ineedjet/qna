shared_examples_for 'API unprocessable' do
  it 'returns status 422' do
    do_request(access_token: access_token.token)
    expect(response.status).to eq 422
  end
end
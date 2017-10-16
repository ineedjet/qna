shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'return 401 status if no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'return 401 status if access_token wrong' do
      do_request(access_token: '123456')
      expect(response.status).to eq 401
    end
  end
end
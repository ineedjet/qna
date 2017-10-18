shared_examples_for 'API successfuble' do
  it 'should return status 200' do
    expect(response).to be_success
  end
end
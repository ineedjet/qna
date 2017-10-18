shared_examples_for 'render-templatable' do
  it 'render template' do
    expect(response).to render_template action
  end
end
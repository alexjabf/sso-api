# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'model crud operations' do |symbol|
  let!(:object_one) { create(symbol) }
  let!(:object_two) { create(symbol) }
  let(:excluded_attributes) { %w[id created_at updated_at encrypted_password] }

  it 'creates a new object' do
    expect do
      create(symbol)
    end.to change(model, :count).by(1)
  end

  it 'reads all objects' do
    expect(model.all).to contain_exactly(object_one, object_two)
  end

  it 'reads a single object' do
    expect(model.find(object_one.id)).to eq(object_one)
  end

  it 'updates an object' do
    new_attributes = build(symbol).attributes.except!(*excluded_attributes)
    object_one.update(new_attributes)
    expect(model.find(object_one.id).attributes.except!(*excluded_attributes)).to eq(new_attributes)
  end

  it 'deletes an object' do
    expect do
      object_one.destroy
    end.to change(model, :count).by(-1)
  end
end

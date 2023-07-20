# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scopes do
  let(:company_class) { Role }

  before do
    allow(company_class).to receive(:public_send).with('company_records', { current_ability: nil })
                                                 .and_return(company_class)
  end

  describe '.records' do
    context 'when parameters are given' do
      let(:params) { { sort_by: 'name', order: 'asc', page: 2, per_page: 10 } }

      before do
        allow(company_class).to receive(:order).with('name asc').and_return(company_class)
        allow(company_class).to receive(:paginate).with(page: 2, per_page: 10).and_return(company_class)
        company_class.records(params:)
      end

      it 'paginates the records' do
        expect(company_class).to have_received(:paginate).with(page: 2, per_page: 10)
      end

      it 'orders the records' do
        expect(company_class).to have_received(:order).with('name asc')
      end
    end

    context 'when some parameters are invalid' do
      let(:params) { { id: 'one', sort_by: 'non_existing_colum', order: 'down', page: 1, per_page: 10 } }

      before do
        allow(company_class).to receive(:order).with('id desc').and_return(company_class)
        allow(company_class).to receive(:paginate).with(page: 1, per_page: 10).and_return(company_class)
        company_class.records(params:)
      end

      it 'paginates the records' do
        expect(company_class).to have_received(:paginate).with(page: 1, per_page: 10)
      end

      it 'orders the records' do
        expect(company_class).to have_received(:order).with('id desc')
      end
    end

    context 'when no parameters are given' do
      before do
        allow(company_class).to receive(:order).with('id desc').and_return(company_class)
        allow(company_class).to receive(:paginate).with(page: 1, per_page: 20).and_return(company_class)
        company_class.records
      end

      it 'paginates the records by default' do
        expect(company_class).to have_received(:paginate).with(page: 1, per_page: 20)
      end

      it 'orders the records by default' do
        expect(company_class).to have_received(:order).with('id desc')
      end
    end
  end
end

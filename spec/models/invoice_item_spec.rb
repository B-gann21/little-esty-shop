require 'rails_helper'

RSpec.describe InvoiceItem do
  before :each do
    @merchant = Merchant.create!(name: "Frank's Pudding",
                           created_at: Time.parse('2012-03-27 14:53:59 UTC'),
                           updated_at: Time.parse('2012-03-27 14:53:59 UTC'))

    @customer = Customer.create!(first_name: "Billy", last_name: "Jonson",
                                 created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                 updated_at: Time.parse('2012-03-27 14:54:09 UTC'))

    @invoice = @customer.invoices.create!(status: 'in progress',
                                      created_at: Time.parse("2012-03-17 17:54:13 UTC"),
                                      updated_at: Time.parse("2012-03-17 17:54:13 UTC"))

    @item = @merchant.items.create!(name: 'Chocolate Delight', unit_price: 500,
                             description: 'tastiest chocolate pudding on the east coast',
                              created_at: Time.parse('2012-03-27 14:53:59 UTC'),
                              updated_at: Time.parse('2012-03-27 14:53:59 UTC'))

    @item_2 = @merchant.items.create!(name: 'Chocolate Delight', unit_price: 500,
                             description: 'tastiest chocolate pudding on the east coast',
                              created_at: Time.parse('2012-03-27 14:53:59 UTC'),
                              updated_at: Time.parse('2012-03-27 14:53:59 UTC'))

    @invoice_item = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item.id,
                                            status: 'packaged', quantity: 9, unit_price: 13232,
                                        created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                        updated_at: Time.parse('2012-03-27 14:54:09 UTC'))

    @invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item_2.id,
                                            status: 'shipped', quantity: 9, unit_price: 0,
                                        created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                        updated_at: Time.parse('2012-03-27 14:54:09 UTC'))
  end

  context 'readable attributes' do
    it 'has a status' do
      expect(@invoice_item.status).to eq('packaged')
    end
  end

 context 'validations' do
   it { should validate_presence_of :quantity }
   it { should validate_numericality_of :quantity }

   it { should validate_presence_of :unit_price }
   it { should validate_numericality_of :unit_price}

   it { should validate_presence_of :status }
   it { should define_enum_for(:status) }
 end

  context 'relationships' do
    it { should belong_to :item}
    it { should belong_to :invoice}
  end

  describe 'class methods' do
    it 'can calculate the items total revenue' do
      expect(InvoiceItem.items_total_revenue).to eq(119088)
    end

    it 'can return invoices with items that have not shipped' do
      expect(InvoiceItem.incomplete_invoices.count).to eq(1)
    end
  end
end

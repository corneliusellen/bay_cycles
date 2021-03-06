require "rails_helper"

describe "As a registered User" do
  before :each do
    @admin = create(:admin)
    @order = create(:order, user: @admin)
    @order_2 = create(:order, user: @admin)
    @order_3 = create(:order, user: @admin, status: "Paid")
    @order_4 = create(:order, user: @admin, status: "Cancelled")
  end
  describe "when I visit the root path" do
    it "I can click on Login and login to my account" do
      visit root_path

      click_on "Login"

      fill_in "email", with: @admin.email
      fill_in "password", with: @admin.password

      click_on "Submit"

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("Welcome, oh Mighty #{@admin.name}. Your realm awaits.")
      expect(page).to have_content("Logged in as #{@admin.name}")
      expect(page).to have_content("Current Email: #{@admin.email}")
      expect(page).to have_content("Logout")
      expect(page).to_not have_content("Login")
    end

    it "I can expect true to return true" do
      expect(true).to eq(true)
    end

    it "I can see a list of all orders" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      expect(page).to have_content("Order ##{@order.id}")
      expect(page).to have_content("Order ##{@order_2.id}")
    end

    it "I can see a total number of orders for each status" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      expect(page).to have_content("Ordered: 2")
      expect(page).to have_content("Paid: 1")
      expect(page).to have_content("Cancelled: 1")
      expect(page).to have_content("Completed: 0")
    end

    it "I can filter orders by display by each status type" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      click_on "Ordered"

      expect(page).to have_content("Orders with the status of Ordered")
      expect(page).to have_content("Ordered Order: ##{@order.id}")
      expect(page).to have_content("Ordered Order: ##{@order_2.id}")
      expect(page).to_not have_content("Paid Order: ##{@order_3.id}")
      expect(page).to_not have_content("Cancelled Order: ##{@order_4.id}")
    end

    it "I can click cancel on orders that are paid or ordered" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      click_on "Paid"

      expect(page).to_not have_content("Mark as Paid")

      click_on "Cancel Order"

      expect(page).to have_content("#{@order_3.id} has been Cancelled")
      expect(page).to_not have_content("Paid Order: ##{@order_3.id}")
      expect(Order.cancelled.count).to eq(2)
    end
  end
end

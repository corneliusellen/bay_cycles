require "rails_helper"

describe "As a visitor" do
  before :each do
    @station = create(:station)
  end
  describe "when I try to visit stations/:id/edit" do
    it "I am redirected to a 404 page" do
      visit edit_admin_station_path(@station)

      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end

  describe "when I try to visit stations/new" do
    it "I am redirected to a 404 page" do
      visit new_admin_station_path

      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end
end

require "rails_helper"

RSpec.describe Site, type: :model do

  let(:site) { Site.new }

  describe "Validation" do
    it "name" do
      site.valid?
      expect(site.errors[:name]).to eq(["can't be blank"])
    end

    describe "slug" do
      it "success" do
        site.slug = "lowercase-with-dashes"
        site.valid?
        expect(site.errors[:slug]).to eq([])
      end

      it "failure uppercase" do
        site.slug = "UPPERCASE"
        site.valid?
        expect(site.errors[:slug]).to eq(["is invalid"])
      end

      it "failure spaces" do
        site.slug = "lower case"
        site.valid?
        expect(site.errors[:slug]).to eq(["is invalid"])
      end
    end
  end
end
require "rails_helper"

RSpec.describe ReservationsController, type: :controller do

  let(:reservation) { reservations(:default) }
  let(:t) { 2.days.from_now }

  it "GET index" do
    get :index, { from: "#{2.days.ago}", to: "#{3.days.from_now}" }
    expect(response).to render_template(:index)
    expect(assigns(:current_reservations)).to eq([reservation.reserved_at.xmlschema])
  end

  it "GET new" do
    get :new
    expect(response).to render_template(:new)
    expect(assigns(:reservation_form).present?).to eq(true)
  end

  describe "POST create" do
    it "success" do
      reservation_timestamp = Time.new(t.year, t.month, t.day, 12, 20, 0, "-04:00").xmlschema
      post :create, { reservation_form: { name: "Tiger Woods", email: "tiger.woods@test.test", reserved_at: reservation_timestamp } }
      expect(response).to redirect_to(reservations_path)
    end

    it "success - at different site" do
      site = Site.create!({ slug: "location-too", name: "Another Golf Course" })
      request.host = "#{site.slug}.test.host"

      post :create, { reservation_form: { name: "Tiger Woods", email: "tiger.woods@test.test", reserved_at: reservation.reserved_at } }
      expect(response).to redirect_to(reservations_path)
    end

    it "failure" do
      post :create
      expect(response).to render_template(:new)
      expect(assigns(:reservation_form).errors.full_messages).to eq([
        "Name can't be blank", "Email can't be blank", "Reserved at can't be blank"
      ])
    end

    it "failure - already reserved" do
      post :create, { reservation_form: { name: "Tiger Woods", email: "tiger.woods@test.test", reserved_at: reservation.reserved_at } }
      expect(assigns(:reservation_form).errors.full_messages).to eq(["Reserved at is already taken"])
      expect(response).to render_template(:new)
    end

    it "failure - cannot reserve past times." do
      t = 2.days.ago
      reservation_timestamp = Time.new(t.year, t.month, t.day, 12, 20, 0, "-04:00").xmlschema
      post :create, { reservation_form: { name: "Tiger Woods", email: "tiger.woods@test.test", reserved_at: reservation_timestamp } }
      expect(assigns(:reservation_form).errors.full_messages).to eq(["Reserved at cannot be in the past"])
      expect(response).to render_template(:new)
    end

    it "failure - cannot reserve arbitrary times" do
      reservation_timestamp = Time.new(t.year, t.month, t.day, 12, 20, 05, "-04:00").xmlschema
      post :create, { reservation_form: { name: "Tiger Woods", email: "tiger.woods@test.test", reserved_at: reservation_timestamp } }
      expect(assigns(:reservation_form).errors.full_messages).to eq(["Reserved at must be on the 20 minute mark"])
      expect(response).to render_template(:new)
    end

    it "failure - cannot reserve more than twice at the same golf course" do
      Reservation.create!({ user_id: reservation.user_id, site_id: reservation.site_id, reserved_at: Time.new(t.year, t.month, t.day, 2, 00, 0, "-04:00").xmlschema })

      post :create, { reservation_form: { name: reservation.user.name, email: reservation.user.email, reserved_at: Time.new(t.year, t.month, t.day, 2, 20, 0, "-04:00").xmlschema } }
      expect(assigns(:reservation_form).errors.full_messages).to eq(["Email can't have more than 2 reservations"])
      expect(response).to render_template(:new)
    end

  end
end
require "rails_helper"

RSpec.describe ReservationsController, type: :controller do

  let(:reservation) { reservations(:default) }

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
      t = 2.days.from_now
      reservation_timestamp = Time.new(t.year, t.month, t.day, 12, 20, 0, "-04:00").xmlschema
      post :create, { reservation_form: { name: "Tiger Woods", email: "tiger.woods@test.test", reserved_at: reservation_timestamp } }
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
      t = 2.days.from_now
      reservation_timestamp = Time.new(t.year, t.month, t.day, 12, 20, 05, "-04:00").xmlschema
      post :create, { reservation_form: { name: "Tiger Woods", email: "tiger.woods@test.test", reserved_at: reservation_timestamp } }
      expect(assigns(:reservation_form).errors.full_messages).to eq(["Reserved at must be on the 20 minute mark"])
      expect(response).to render_template(:new)
    end

  end
end
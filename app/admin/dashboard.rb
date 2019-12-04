ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Resv" do
          ul do
            TouristBike.last(5).reverse.map do |res|
              li link_to(res.start_datetime.to_s + res.bike.name, admin_tourist_bike_path(res))
            end
          end
        end
      end

      column do
        panel "Info" do
          h3 "how to manage db"
          para "データーベースの操作（Edit）にはできるだけ注意してほしい。少しでもわからないことがあれば聞いてください。"
          # h3 "TouristBike"
          # para ""
          # h3 "Bike"
          # para "Welcome to ActiveAdmin."
        end
      end
    end
  end # content
end

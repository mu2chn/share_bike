ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    address: 'kyotosharebb.sakura.ne.jp',
    domain: 'mail.kyotosharebike.com',
    port: 587,
    user_name: 'info@mail.kyotosharebike.com',
    password: 'MAface44',
    authentication: 'plain',
    enable_starttls_auto: true
}
Redmine::Plugin.register :redmine_tbstaxi do
  name 'Redmine Tbstaxi plugin'
  author 'lek'
  description 'Patches for tbstaxi redmine'
  version '0.0.1'
  url 'https://tbstaxi.ru'
  author_url 'https://tbstaxi.ru'

  requires_redmine version_or_higher: '3.0.0'

  Rails.configuration.to_prepare do
    require 'mail_handler_patch'
    MailHandler.send :include, MailHandlerPatch

    #Remove statuses #1057
    require 'mailer_patch'
    Mailer.send :include, MailerPatch
  end
end

Redmine::Plugin.register :redmine_tbstaxi do
  name 'Redmine Tbstaxi plugin'
  author 'lek'
  description 'Patches for tbstaxi redmine'
  version '0.0.2'
  url 'https://tbstaxi.ru'
  author_url 'https://tbstaxi.ru'

  requires_redmine version_or_higher: '3.0.0'

  settings :default => {
    'tbs_settings_parent_and_child_issues' => false,
    'tbs_settings_actionmailer_log' => false,
    'tbs_settings_mailer_log' => false,
    'tbs_settings_l4_log' => false,
    'tbs_settings_issue_open_by_email' => false,
    'tbs_settings_add_resent_from' => false,
    'tbs_settings_add_anonymous_from' => false,
    'tbs_settings_message_id_re' => false,
    'tbs_settings_changeauthor' => false,
    'tbs_settings_verify_ssl_disable' => false
    }, :partial => 'settings/ts_settings'


  Rails.configuration.to_prepare do
    if Setting['plugin_redmine_tbstaxi']['tbs_settings_parent_and_child_issues']
      require 'issue_patch'

    end

    require 'mail_handler_patch'
    MailHandler.send :include, MailHandlerPatch

    #Remove statuses #1057
    require 'mailer_patch'
    Mailer.send :include, MailerPatch
  end
end

require_dependency 'mail_handler'

module MailHandlerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :add_attachments, :tbsaddattachments
    end 
  end 

  module InstanceMethods
    UnauthorizedAction = MailHandler.const_get(:UnauthorizedAction)
    MissingInformation = MailHandler.const_get(:MissingInformation)

    private
      MESSAGE_ID_RE = MailHandler.const_get(:MESSAGE_ID_RE)
      ISSUE_REPLY_SUBJECT_RE = MailHandler.const_get(:ISSUE_REPLY_SUBJECT_RE)
      MESSAGE_REPLY_SUBJECT_RE = MailHandler.const_get(:MESSAGE_REPLY_SUBJECT_RE)

      def add_attachments_with_tbsaddattachments(obj)
        if email.attachments && email.attachments.any?
          email.attachments.each do |attachment|
          next unless accept_attachment?(attachment)
          obj.attachments << Attachment.create(:container => obj,
                          :file => attachment.decoded,
                          :filename => attachment.filename,
                          :author => user,
                          :content_type => attachment.mime_type)
          end
        end
        if email.html_part
          obj.attachments << Attachment.create(:container => obj,
                          :file => email.html_part.body.decoded,
                          :filename => "EMAIL-BODY-#{Date.today.strftime('%Y-%m-%d')}.html",
                          :author => user,
                          :content_type => 'text/html')
        end
      end
  end
end

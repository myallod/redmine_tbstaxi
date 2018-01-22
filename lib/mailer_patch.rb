module MailerPatch
  
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      alias_method_chain :issue_add, :tbsissueadd
      alias_method_chain :issue_edit, :tbsissueedit
      #alias_method_chain :mylogger, :tsmylogger
    end
  end

  module InstanceMethods
    # Builds a mail for notifying to_users and cc_users about a new issue
    def issue_add_with_tbsissueadd(issue, to_users, cc_users)
      redmine_headers 'Project' => issue.project.identifier,
                      'Issue-Id' => issue.id,
                      'Issue-Author' => issue.author.login
      redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to
      message_id issue
      references issue
      @author = issue.author
      @issue = issue
      @users = to_users + cc_users
      @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue)
      mail :to => to_users,
        :cc => cc_users,
        :subject => "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.subject}"
    end

      # Builds a mail for notifying to_users and cc_users about an issue update
    def issue_edit_with_tbsissueedit(journal, to_users, cc_users)
      issue = journal.journalized
      redmine_headers 'Project' => issue.project.identifier,
                      'Issue-Id' => issue.id,
                      'Issue-Author' => issue.author.login
                      redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to
      message_id journal
      references issue
      @author = journal.user
      s = "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] #{issue.subject}"
      #s << issue.subject
      @issue = issue
      @users = to_users + cc_users
      @journal = journal
      @journal_details = journal.visible_details(@users.first)
      @issue_url = url_for(:controller => 'issues', :action => 'show', :id => issue, :anchor => "change-#{journal.id}")
      mail :to => to_users,
        :cc => cc_users,
        :subject => s
      end
  end
end

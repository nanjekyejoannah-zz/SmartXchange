class AddPeerReviewAndNotifyReviewToEmailSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :email_subscriptions, :peer_review, :boolean, null: false, default: true
    add_column :email_subscriptions, :notify_review, :boolean, null: false, default: true
  end
end

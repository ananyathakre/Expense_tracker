class Current < ActiveSupport::CurrentAttributes
    attribute :user
    def self.current_user=(user)
        Thread.current[:user] = user
    end
end
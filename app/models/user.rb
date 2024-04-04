class User < ApplicationRecord
    def self.current_user
        Thread.current[:user]
    end
end
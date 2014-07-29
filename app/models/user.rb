# encoding: utf-8

class User < ActiveRecord::Base

  after_destroy :ensure_an_admin_remains

  attr_accessible :name, :password, :password_confirmation

  validates :name, presence: true, uniqueness: true
  has_secure_password


  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise "最後のユーザーは削除できません"
      end
    end

end


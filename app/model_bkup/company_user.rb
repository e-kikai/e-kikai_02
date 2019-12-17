class CompanyUser < ActiveRecord::Base
  belongs_to :company

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [ :account ],
         :case_insensitive_keys => [:account],
         :strip_whitespace_keys => [:account]

  validates :account, uniqueness: true
  validates :account, presence: true

  #登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end
end

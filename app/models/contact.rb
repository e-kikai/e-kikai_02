class Contact < MachinelifeDb
  ### 2 newsystems DB ###
  alias_attribute :name, :user_company
  alias_attribute :officer, :user_name
  alias_attribute :content, :message

  belongs_to :machine
  belongs_to :company

  validates :name, presence: true
  validates :mail, presence: true
  validates :content, presence: true
end

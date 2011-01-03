class Judge < ActiveRecord::Base
  belongs_to :judge, :class_name => 'Member'
  belongs_to :assist, :class_name => 'Member'

  def display
    "Judge #{judge.display} " +
    (assist ? "assisted by #{assist.display}" : 'without an assistant.')
  end
end

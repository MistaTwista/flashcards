class AddAttachmentPictureToCards < ActiveRecord::Migration
  def self.up
    change_table :cards do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :cards, :picture
  end
end

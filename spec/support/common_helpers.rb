module CommonHelpers
  def get_attachment(filename, content_type)
    {
      io: File.open(attachments_directory.join(filename)),
      filename: filename,
      content_type: content_type
    }
  end

  def get_attachment_path(filename)
    attachments_directory.join(filename)
  end

  private

  def attachments_directory
    Rails.root.join('spec', 'factories', 'files')
  end
end

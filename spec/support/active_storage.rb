RSpec.configure do |config|
  config.after(:all) do
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage')) if Rails.env.test?
  end
end

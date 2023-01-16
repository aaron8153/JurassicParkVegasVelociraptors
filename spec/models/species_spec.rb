require 'rails_helper'

RSpec.describe Species, type: :model do

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:carnivorous) }
  end

end

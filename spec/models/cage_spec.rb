require 'rails_helper'

RSpec.describe Cage, type: :model do

  describe "validations" do
    it { should belong_to(:species).optional }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:max_capacity) }
  end

end

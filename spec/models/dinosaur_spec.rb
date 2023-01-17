require 'rails_helper'

RSpec.describe Dinosaur, type: :model do

  describe "validations" do
    it { should belong_to(:species) }
    it { should belong_to(:cage).optional }
    it { should validate_presence_of(:name) }
  end


end

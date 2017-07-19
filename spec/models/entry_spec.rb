require 'rails_helper'

RSpec.describe Entry, type: :model do
  subject { Entry.new }

  it { is_expected.to belong_to :user }

  it { is_expected.to respond_to :text }
  it { is_expected.to respond_to :uuid }
  it { is_expected.to respond_to :user_id }
  it { is_expected.to respond_to :date }
  it { is_expected.to respond_to :latitude }
  it { is_expected.to respond_to :longitude }
  it { is_expected.to respond_to :address }

  it { is_expected.to validate_presence_of :text }
  it { is_expected.to validate_presence_of :uuid }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :latitude }
  it { is_expected.to validate_presence_of :longitude }
  it { is_expected.to validate_presence_of :address }

  it { is_expected.to validate_uniqueness_of :uuid }
end

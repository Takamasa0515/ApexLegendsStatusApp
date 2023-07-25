# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrackerApiServiceDecorator do
  let(:tracker_api_service) { TrackerApiService.new.extend TrackerApiServiceDecorator }
  subject { tracker_api_service }
  it { should be_a TrackerApiService }
end

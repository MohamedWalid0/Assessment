# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileTypeChecker do
  context "when user have one profile" do
    profile_types = [:corporate, :freelancer, :project_manager]

    profile_types.each do |profile|
      it "returns true for #{profile} profile" do
        user = create(profile)
        method_name = "have_#{profile}_profile?".to_sym

        expect(user.send(method_name)).to be_truthy
      end
    end
  end

  context "when user has 2 profiles" do
    profile_types = [:corporate, :freelancer, :project_manager]
    combinations = profile_types.combination(2).to_a

    combinations.each do |combo|
      it "returns true for #{combo.join(' and ')} profiles" do
        user = create(combo.first.to_s)
        create("#{combo.last}_profile", user: user)
        method_name = "have_#{combo.join('_and_')}_profile?".to_sym

        expect(user.send(method_name)).to be_truthy
      end
    end
  end

  context "when user has 3 profiles" do
    let(:user) { create(:corporate) }

    before do
      create(:freelancer_profile, user: user)
      create(:project_manager_profile, user: user)
    end

    it "returns true" do
      expect(user.have_corporate_and_freelancer_and_project_manager_profile?).to be_truthy
    end
  end

  context "user_profile_types method" do
    let(:user) { create(:project_manager) }

    before do
      create(:corporate_profile, user: user)
      create(:freelancer_profile, user: user)
    end

    it "returns an array of profile types for the user" do
      expected_profile_types = ["Corporate", "Freelancer", "ProjectManager"]

      expect(user.user_profile_types).to match_array(expected_profile_types)
    end
  end
end

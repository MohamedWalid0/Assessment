# frozen_string_literal: true

require 'rails_helper'


RSpec.describe Mutations::CreateCorporateProfile do
  let(:mutation_name) { "createCorporateProfile" }
  let(:mutation_string) do
    <<-GQL
    mutation($input: CreateCorporateProfileInput!) {
      #{mutation_name}(input: $input){
        user {
          dbId
          activeProfile
          businessProfileNumber
        }
        errors {
          attribute
          messageEn
          messageAr
        }
      }
    }
    GQL
  end


  context "When guest user" do
    it "does not create the corporate profile" do
    end
  end

  context "When signed in" do
    context "When logo is sent as an array of files" do
      it "returns error" do
      end
    end

    context "When authorized" do
      it "creates the corporate profile" do
        mutation mutation_string, variables: { input: input }, context: context

        expect(freelancer.profile_types).to eq("both")
        # expect(freelancer.have_corporate_and_freelancer_profile?).to be_truthy
        
        expect(freelancer.corporate_profile?).to be true
      end
    end
  end
end
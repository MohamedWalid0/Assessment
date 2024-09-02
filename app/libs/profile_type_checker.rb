# frozen_string_literal: true

# This module is responsible for checking for profile types
# its provides a dynamic function naming to allow:
  # user.have_freelancer_profile?
  # user.have_freelancer_and_corporate_profile?
  # user.have_freelancer_and_corporate_and_project_manager_profile?
# also when adding a new profile type named "X"
  # user.have_freelancer_and_X_profile?

# :reek:DuplicateMethodCall
# :reek:BooleanParameter
# :reek:FeatureEnvy
module ProfileTypeChecker
  PREFIX = "have_"
  SUFFIX = "_profile?"
  LOGICAL_SEPARATOR = "_and_"
  PROFILE = "Profile"

  def method_missing(method_name, *arguments, &block)
    if method_name.to_s.start_with?(PREFIX) && method_name.to_s.end_with?(SUFFIX)
      check_profile_types(method_name)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private=false)
    method_name.to_s.start_with?(PREFIX) && method_name.to_s.end_with?(SUFFIX) || super
  end

  private

  def check_profile_types(method_name)
    desired_profiles = method_name.to_s.delete_prefix(PREFIX).delete_suffix(SUFFIX).
      split(LOGICAL_SEPARATOR).map { |type| type.camelize + PROFILE }

    user_profiles = self.profiles.pluck(:type)

    user_profiles.sort == desired_profiles.sort
  end
end
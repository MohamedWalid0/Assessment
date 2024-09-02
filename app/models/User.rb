class User
  include ProfileTypeChecker

  # TODO: should be add project_manager: 'project_manager' and replace 'both'
  enum profile_types: { both: 'both', freelancer: 'freelancer', corporate: 'corporate' }

  has_one :freelancer_profile, dependent: :destroy
  has_one :corporate_profile, dependent: :destroy
  # has_one :project_manager_profile, dependent: :destroy


  def x 
    return 1 if profile_types == "both"
    return 2 if profile_types == "freelancer"
    return 3 if profile_types == "corporate"
    # return 4 if profile_types == "project_manager"

  end


  def has_active_project_manager_profile?
    self.project_manager? && !(self.suspended? || self.blocked?)
  end

  def project_manager?
    self.project_manager_profile.present?
  end
  
end
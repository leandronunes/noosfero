class CmsController < ComatoseAdminController
  extend PermissionCheck

  ApplicationController.needs_profile
  
  define_option :page_class, Article
  
  # not yet
  # protect [:edit, :new, :reorder, :delete], :post_content, :profile
end

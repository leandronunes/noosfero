class EnvironmentRoleManagerController < ApplicationController
  protect [:index, :change_roles, :update_roles, :change_role, :add_role, :remove_role, :unassociate, :make_admin], 'manage_environment_roles', environment
  
  def index
    @admins = Person.find(:all, :conditions => ['role_assignments.resource_type = ?', 'Environment'], :include => :role_assignments )
  end

  def change_roles
    @admin = Person.find(params[:id])
    @roles = Role.find(:all).select{ |r| r.has_kind?(:environment) }
  end  

  def update_roles
    @roles = params[:roles] ? Role.find(params[:roles]) : []
    @person = Person.find(params[:person])
    if @person.define_roles(@roles, environment)
      flash[:notice] = _('Roles successfuly updated')
    else
      flash[:notice] = _('Couldn\'t change the roles')
    end
    redirect_to :action => :index
  end
  
  def change_role
    @roles = Role.find(:all).select{ |r| r.has_kind?(:environment) }
    @admin = Person.find(params[:id])
    @associations = RoleAssignment.find(:all, :conditions => {:accessor_id => @admin,
                                        :accessor_type => @admin.class.base_class.name, 
                                        :resource_id => environment, 
                                        :resource_type => environment.class.base_class.name})
  end

  def add_role
    @person = Person.find(params[:person])
    @role = Role.find(params[:role])
    if environment.affiliate(@person, @role)
      redirect_to :action => 'index'
    else
      @admin = Person.find(params[:person])
      @roles = Role.find(:all).select{ |r| r.has_kind?(:environment) }
      render :action => 'affiliate'
    end
  end

  def remove_role
    @association = RoleAssignment.find(params[:id])
    if @association.destroy
      flash[:notice] = _('Member succefully unassociated')
    else
      flash[:notice] = _('Failed to unassociate member')
    end
    redirect_to :aciton => 'index'
  end

  def unassociate
    @association = RoleAssignment.find(params[:id])
    if @association.destroy
      flash[:notice] = _('Member succefully unassociated')
    else
      flash[:notice] = _('Failed to unassociate member')
    end
    redirect_to :aciton => 'index'
  end

  def make_admin
    @people = Person.find(:all)
    @roles = Role.find(:all).select{|r|r.has_kind?(:environment)}
  end
end

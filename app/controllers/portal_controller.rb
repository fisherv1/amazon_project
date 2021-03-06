class PortalController < ApplicationController

  include SimpleCaptcha::ControllerHelpers
  layout nil
  protect_from_forgery :only => [:create, :update, :destroy]
  before_filter :check_authentication, :except => [:sign_up_form, :sign_up, :active]

  def sign_up_form
    @potential_member = PotentialMember.new
    respond_to do |format|
      format.html
    end
  end

  def sign_up
    @potential_member = PotentialMember.new(params[:potential_member])
    if simple_captcha_valid?
      if @potential_member.save
        @potential_member.update_attribute(:validation_key, PotentialMember.generate_key)
        email = EmailDispatcher.create_email_with_template(@potential_member.email, 'validation letter', 'email_dispatcher/send_validation_key_to_potential_member', @potential_member)
        EmailDispatcher.deliver(email)
        render 'sign_up'
      else
        flash[:error] = ""
        flash[:error] += "First Name can't be blank <br/>" if (!@potential_member.errors.on(:first_name).nil? && @potential_member.errors.on(:first_name).include?("can't be blank"))
        flash[:error] += "Family Name can't be blank <br/>" if (!@potential_member.errors.on(:family_name).nil? && @potential_member.errors.on(:family_name).include?("can't be blank"))
        flash[:error] += "Email can't be blank <br/>" if (!@potential_member.errors.on(:email).nil? && @potential_member.errors.on(:email).include?("can't be blank"))
        flash[:error] += "Email is already existing <br/>" if (!@potential_member.errors.on(:email).nil? && @potential_member.errors.on(:email).include?("has already been taken"))
        flash[:error] += "Email is invalid <br/>" if (!@potential_member.errors.on(:email).nil? && @potential_member.errors.on(:email).include?("is invalid"))
        render 'sign_up_form'
      end
    else
      flash[:error] = "Validation Code is invalid, please try again."
      render 'sign_up_form'
    end
  end

  def active
    @potential_member = PotentialMember.find(params[:id].to_i) rescue @potential_member = PotentialMember.new
    if !@potential_member.new_record? && @potential_member.validation_key == params[:key]

      #create a person record
      @person = Person.new(:first_name => @potential_member.first_name, :family_name => @potential_member.family_name)
      @person.save

      #create an email record
      @email_type = ContactMetaMetaType.email.first
      @email = @person.emails.build(:value => @potential_member.email, :contact_meta_type_id => @email_type.contact_meta_types.first.id)
      @email.save

      #create a note record
      @note_type = NoteType.membership.first
      @note = @person.notes.build(:label => "new_member", :short_description => "new member", :body_text => "new member", :active => true, :note_type_id => @note_type.id)
      @note.save

      #destroy temp potential member record
      @potential_member.destroy
      flash[:result] = "Your record is actived."
    else
      flash[:result] = "Your record is already actived."
    end
  end

end

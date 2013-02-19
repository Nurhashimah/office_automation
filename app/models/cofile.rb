class Cofile < ActiveRecord::Base
  
  validates_presence_of :name, :location, :owner_id, :cofileno, :company #15Feb2013-company added
  
  belongs_to :owner,    :class_name => 'Staff', :foreign_key => 'owner_id' 
  belongs_to :borrower, :class_name => 'Staff', :foreign_key => 'staffloan_id' 
  
  has_many :documents, :foreign_key => 'file_id'
  has_many :sdiciplines, :foreign_key => 'file_id'
  has_many :student_discipline_cases, :foreign_key => 'file_id'
  
  #Link to Model Sdicipline
  #has_many :file,       :class_name => 'Sdicipline', :foreign_key => 'cofile_id'
  has_many :counsellings
  
  def file_no_and_name
    "#{cofileno}  #{name}"
  end
  
  
  def owner_details
    suid = owner_id.to_a
    exists = Staff.find(:all, :select => "id").map(&:id)
    checker = suid & exists
    
    if owner_id == nil
      ""
    elsif checker == []
      "Staff No Longer Exists"
    else
      #owner.mykad_with_staff_name
      owner.name  #15Feb2013-display name only
    end
  end
  
  def borrower_details
    suid = staffloan_id.to_a
    exists = Staff.find(:all, :select => "id").map(&:id)
    checker = suid & exists
    
    if staffloan_id == nil
      ""
    elsif checker == []
      "Staff No Longer Exists"
    else
      #borrower.mykad_with_staff_name
      borrower.name   #19Feb2013-display staff name only
    end
  end
   
  def self.find_main
   Staff.find(:all, :condition => ['staff_id IS NULL'])
  end
   
  def self.search(search)
    if search     #sort record display by cofileno
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"], :order => :cofileno)  #find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all, :order => :cofileno) #find(:all)
    end
  end
  
  #-19Feb2013 set row color according to file owner/department --> DIVISION
  def set_row_color
  	if division == 1                    # Support service & Admin
		  'yellow2'   
		elsif division == 3                 # Tender
		  'yellow2'
  	elsif division == 4                 # IT project
  		'pink'    
    elsif division == 2                 # Marketing
   		'orange'
	  elsif division == 5                 # Engineering project
	    'green2'
	  elsif division == 6                 # Project Manager
	    'white'
    end  
  end
  
  
  #coded list for locations - 15Feb2013
  LOCATION = [
		#Displayed	Stored in db
		["First Floor Admin Cabinet", 1],                 #Support Service & Admin / Division Tender - yellow, marketing-orange
		["First Floor Close Admin Cabinet", 2],           #Support Service & Admin / Division Tender - yellow
		["First Floor MD Cabinet 1", 3],                  #IT Project - pink
		["First Floor MD Cabinet 2", 4],	                #IT Project - pink
		["First Floor Filling Room-Sect TPL-A/1", 5],     #Engineering Project - green
		["First Floor Filling Room-Sect TPL-A/2", 6],     #Engineering Project - green
		["First Floor Filling Room-Sect TPL-A/3", 7],     #Engineering Project - green
		["First Floor Filling Room-Sect TPL-A/4", 8],     #Engineering Project - green
		["Ground Floor IT Cabinet", 9],                   #IT Project - pink
		["Ground Floor PM Cabinet", 10]                   #Engineering Project - white (project manager)
  ]
    
  #coded list for divisions - 19Feb2013
  DIVISION = [
		#Displayed	Stored in db
		["Support Service & Admin", 1],        #yellow
		["Marketing", 2],                      #orange
		["Tender", 3],                        #yellow
		["IT Project", 4],                    #pink
		["Engineering Project", 5],	          #green
		["Project Manager", 6]                #white
  ]
    
    

 
 
end

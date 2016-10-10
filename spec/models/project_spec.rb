require 'rails_helper'
  RSpec.describe Project, type: :model do
   context " Title validation check Project Model" do
	    it "is invalid without a title" do
	      FactoryGirl.build(:project, title: nil).should_not be_valid
	    end
	    it "is valid with a title" do
	      FactoryGirl.build(:project, title: "something").should be_valid
	    end
	end
	context "Date validation checks Project Model" do
	   it "is not valid with date" do
		   	FactoryGirl.build(:project, started_at: "2016-10-15 10:01:38")
        FactoryGirl.build(:project, deadline: "2016-09-12 10:01:38").should_not be_valid
	   end
	   it "is valid with date" do
		   	FactoryGirl.build(:project)
		   	FactoryGirl.build(:project).should be_valid
	   end
	   it "is not valid format of date" do
	   		FactoryGirl.build(:project, started_at: "asdasdasd")
	   		FactoryGirl.build(:project, deadline: "hubhnjn nnnjnj").should_not be_valid
 	   end
  	   it "is not valid format of date" do
  	   		FactoryGirl.build(:project, started_at: "12345")
	   		FactoryGirl.build(:project, deadline: "564787").should_not be_valid  	
  		end
    end
    context "Progress validation checks Project model" do
    	it "is valid with progress" do
   			FactoryGirl.build(:project, progress: 25 ).should be_valid  
 		end
  		it "is not valid with progress" do
   			FactoryGirl.build(:project, progress: 19867 ).should_not be_valid  
 		end
 		it "is valid with progress" do 
 			FactoryGirl.build(:project, progress: "bhbhbh" ).should_not be_valid
 		end
 	end
 	context "Associations " do
	    it "has many tasks" do
	      FactoryGirl.create(:project).tasks.length # 0
        FactoryGirl.create(:project_with_tasks).tasks.length # 5
        FactoryGirl.create(:project_with_tasks, tasks_count: 15).tasks.length 
	    end
	    it "has many members " do
	      assc = described_class.reflect_on_association(:project_users)
	      expect(assc.macro).to eq :has_many
	    end
	    it "belongs to user" do
  	    project = FactoryGirl.create(:project)
  			project.new_record?       
  			project.creator.new_record? 
	    end
	    it "has many posts " do
	      FactoryGirl.create(:project).posts.length # 0
        FactoryGirl.create(:project_with_posts).posts.length # 5
        FactoryGirl.create(:project_with_posts, posts_count: 15).posts.length 
	    end	    
  	end

  	context "Test instance methods project model" do
  		it "check creator to member of project " do
  			project = FactoryGirl.create(:project)
  			expect(project.members.include? (project.creator))
  		end
  		it "returns task progress" do
		      project = FactoryGirl.build(:project)
		      project.save!
		      expect(project.progress) 
    	end 
  	end
  end

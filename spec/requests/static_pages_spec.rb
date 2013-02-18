require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  
  subject{ page }
  
  describe "Home page" do
    
    before { visit root_path }

    it {page.should have_selector('h1', :text => 'Sample App')}

    it {page.should have_selector('title', text: full_title(''))}
      
    it {page.should_not have_selector('title', :text => '| Home')}
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      
      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
      
      describe "pagination" do

        before(:all) { 30.times { FactoryGirl.create(:micropost, user: user) } }
        after(:all) { Micropost.delete_all }

        it { page.should have_selector('div.pagination') }

        it "should list each micropost" do
          Micropost.paginate(page: 1).each do |micropost|
            page.should have_selector("li", text: micropost.content)
          end
        end
      end
      
    end
    
    describe "sidebar micropost count" do
      
      let(:user) { FactoryGirl.create(:user) }
      
      describe "should contain a single micropost with correct pluralization" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          sign_in user
          visit root_path
        end
        
        it { should_not have_selector("span.microposts", text: "microposts") }
        it { should have_selector("span.microposts", text: "micropost") }
      end        

      describe "should contain 2 microposts with correct pluralization" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          sign_in user
          visit root_path
        end
        
        it { should have_selector("span.microposts", text: "microposts") }
      end
    end
    
  end

  describe "Help page" do
    
    before { visit help_path }

    it {page.should have_selector('h1', :text => 'Help')}
      
    it {page.should have_selector('title', text: full_title('Help'))}
    
  end

  describe "About page" do
    
    before { visit about_path }

    it {page.should have_selector('h1', :text => 'About Us')}
      
    it {page.should have_selector('title', text: full_title('About Us'))}
      
  end
  
  describe "Contact page" do
    
    before { visit contact_path }

    it {page.should have_selector('h1', :text => 'Contact')}
      
    it {page.should have_selector('title', text: full_title('Contact'))}
      
  end
end
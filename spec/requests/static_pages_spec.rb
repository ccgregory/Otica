require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Leslie' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
    
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
      end  # should render the user's feed
      
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end  # follower/following counts

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end   
      
    end   # for signed-in users 
  
  end  # Home page

  describe "Help page" do
    before { visit help_path }
    
    let(:heading)    { 'Ajuda' }
    let(:page_title) { 'Ajuda' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)    { 'A empresa' }
    let(:page_title) { 'A empresa' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading)    { 'Contato' }
    let(:page_title) { 'Contato' }
    it_should_behave_like "all static pages"
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "A empresa"
    page.should have_selector 'title', text: full_title('A empresa')
    click_link "Ajuda"
    page.should have_selector 'title', text: full_title('Ajuda')
    click_link "Contato"
    page.should have_selector 'title', text: full_title('Contato')
    click_link "Home"
    click_link "Cadastre-se!"
    page.should have_selector 'title', text: full_title('Cadastre-se')
    click_link "LeslieOtica"
    page.should have_selector 'title', text: full_title('')
    click_link "Novidades"
    page.should have_selector 'title', text: full_title('Novidades')
  end

end
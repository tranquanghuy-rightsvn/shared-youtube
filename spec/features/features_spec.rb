require "rails_helper"

describe "the authenticate process", type: :system do
  let!(:user){ create :user, email: "email-example@gmail.com", password: "123123" }

  it "register success" do
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-one@gmail.com"
      fill_in "user_signin_password", with: "password"
    end
    click_button "Login/Register"
    expect(page).to have_content "Welcome"
  end

  it "register failed because password too short" do
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-one@gmail.com"
      fill_in "user_signin_password", with: "123"
    end
    click_button "Login/Register"
    expect(page).to have_content "Password is too short (minimum is 6 characters)"
  end

  it "register failed because password blank" do
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-one@gmail.com"
      fill_in "user_signin_password", with: ""
    end
    click_button "Login/Register"
    expect(page).to have_content "Password can't be blank"
  end

  it "signin success" do
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"
    expect(page).to have_content "Welcome"
  end

  it "signin failed beacause wrong password" do
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "111111"
    end
    click_button "Login/Register"
    expect(page).to have_content "Wrong password!"
  end

  it "signout success" do
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"
    click_on "Logout"
    expect(page).to have_selector(:button, "Login/Register")
  end
end

describe "the list videos", type: :system do
  let!(:video_1){ create :video }
  let!(:video_2){ create :video }
  let!(:video_3){ create :video }

  let!(:emotion_1){ create :emotion, video: video_1, emotion_type: 0 }
  let!(:emotion_2){ create :emotion, video: video_1, emotion_type: 0 }
  let!(:emotion_3){ create :emotion, video: video_1, emotion_type: 1 }

  let!(:emotion_4){ create :emotion, video: video_2, emotion_type: 0 }
  let!(:emotion_5){ create :emotion, video: video_2, emotion_type: 1 }

  it "view success" do 
    visit "/"
    expect(page).to have_content(video_1.title)
    expect(page).to have_content(video_1.description)
    expect(page).to have_content(video_2.title)
    expect(page).to have_content(video_2.description)
    expect(page).to have_content(video_3.title)
    expect(page).to have_content(video_3.description)
  end

  it "click share video" do
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"
    click_on "Share A Movie"
    expect(current_path).to eq("/videos/new")
  end

  it "click like video failed because not signin" do
    visit "/"
    within(".like-#{video_1.id}") do
      find("span", class: "fa-thumbs-up" ).click
    end
    expect(current_path).to eq("/")
    expect(page).to have_css(".count-like-#{video_1.id}", text: "2")
  end

  it "click dislike video failed because not signin" do
    visit "/"
    within(".dislike-#{video_1.id}") do
      find("span", class: "fa-thumbs-down" ).click
    end
    expect(current_path).to eq("/")
    expect(page).to have_css(".count-dislike-#{video_1.id}", text: "1")
  end

  it "click like video success" do
    visit "/"

    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"

    within(".like-#{video_1.id}") do
      find('span', class: "fa-thumbs-up" ).click
    end

    expect(current_path).to eq("/")
    expect(page).to have_css(".count-like-#{video_1.id}", text: "3")
  end

  it "click dislike video success" do
    visit "/"

    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"

    within(".dislike-#{video_1.id}") do
      find('span', class: "fa-thumbs-down" ).click
    end

    expect(current_path).to eq("/")
    expect(page).to have_css(".count-dislike-#{video_1.id}", text: "2")
  end
end

describe "the shared video", type: :system do
  it "shared success" do 
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"
    click_on "Share A Movie"
    fill_in "form_share_video_url", with: "https://www.youtube.com/watch?v=XvOGdEXXLLg"
    click_button "Share"
    expect(current_path).to eq("/")
    expect(page).to have_content("Amazing Loading Animation Using Only HTML & CSS")
  end

  it "shared failed because URL invalid" do 
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"
    click_on "Share A Movie"
    fill_in "form_share_video_url", with: "wrong-url"
    click_button "Share"
    expect(current_path).to eq("/videos")
    expect(page).to have_content("Url is invalid")
  end

  it "shared failed because link URL of other website" do 
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"
    click_on "Share A Movie"
    fill_in "form_share_video_url", with: "https://www.dailymotion.com/video/x8anwq9?playlist=x6hzkz"
    click_button "Share"
    expect(current_path).to eq("/videos")
    expect(page).to have_content("Url is invalid")
  end

  it "shared failed because link URL is empty" do 
    visit "/"
    within(".right-nav") do
      fill_in "user_signin_email", with: "email-example@gmail.com"
      fill_in "user_signin_password", with: "123123"
    end
    click_button "Login/Register"
    click_on "Share A Movie"
    fill_in "form_share_video_url", with: ""
    click_button "Share"
    expect(current_path).to eq("/videos")
    expect(page).to have_content("Url can't be blank")
    expect(page).to have_content("Url is invalid")
  end
end

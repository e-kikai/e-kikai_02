require 'test_helper'

class LargeGenresControllerTest < ActionController::TestCase
  setup do
    @large_genre = large_genres(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:large_genres)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create large_genre" do
    assert_difference('LargeGenre.count') do
      post :create, large_genre: {  }
    end

    assert_redirected_to large_genre_path(assigns(:large_genre))
  end

  test "should show large_genre" do
    get :show, id: @large_genre
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @large_genre
    assert_response :success
  end

  test "should update large_genre" do
    patch :update, id: @large_genre, large_genre: {  }
    assert_redirected_to large_genre_path(assigns(:large_genre))
  end

  test "should destroy large_genre" do
    assert_difference('LargeGenre.count', -1) do
      delete :destroy, id: @large_genre
    end

    assert_redirected_to large_genres_path
  end
end

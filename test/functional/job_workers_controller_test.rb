require 'test_helper'

class JobWorkersControllerTest < ActionController::TestCase
  setup do
    @job_worker = job_workers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:job_workers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job_worker" do
    assert_difference('JobWorker.count') do
      post :create, job_worker: { is_creator: @job_worker.is_creator, job_id: @job_worker.job_id, worker_id: @job_worker.worker_id }
    end

    assert_redirected_to job_worker_path(assigns(:job_worker))
  end

  test "should show job_worker" do
    get :show, id: @job_worker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job_worker
    assert_response :success
  end

  test "should update job_worker" do
    put :update, id: @job_worker, job_worker: { is_creator: @job_worker.is_creator, job_id: @job_worker.job_id, worker_id: @job_worker.worker_id }
    assert_redirected_to job_worker_path(assigns(:job_worker))
  end

  test "should destroy job_worker" do
    assert_difference('JobWorker.count', -1) do
      delete :destroy, id: @job_worker
    end

    assert_redirected_to job_workers_path
  end
end

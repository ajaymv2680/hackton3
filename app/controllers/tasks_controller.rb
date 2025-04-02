class TasksController < ApplicationController
  include ActionView::RecordIdentifier
  
  before_action :set_task, only: [:edit, :update, :destroy, :change_status]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("modal", "")
          ]
        end
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
      end
    else
      render partial: "tasks/form", locals: { task: @task }, status: :unprocessable_entity
    end
  end

  def edit; end
  
  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(dom_id(@task), partial: "tasks/task", locals: { task: @task }),
            turbo_stream.update("modal", "")
          ]
        end
        format.html { redirect_to tasks_path, notice: "Task was successfully updated." }
      end
    else
      render partial: "tasks/form", locals: { task: @task }, status: :unprocessable_entity
    end
  end

  def change_status
    if @task.update(status: params[:status])
      @tasks = Task.all
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "Task status updated successfully." }
      end
    else
      @tasks = Task.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
  
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("task_#{@task.id}") }
      format.html { redirect_to tasks_path, notice: "Task was successfully deleted." }
    end
  end
  

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end

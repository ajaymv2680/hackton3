class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::RecordIdentifier

  field :title, type: String
  field :description, type: String
  field :status, type: String, default: "To do"

  after_create :broadcast_create
  after_update :broadcast_update
  after_destroy :broadcast_destroy

  private

  def broadcast_create
    Turbo::StreamsChannel.broadcast_append_to(
      "tasks_#{status.parameterize(separator: '_')}",
      target: "tasks_#{status.parameterize(separator: '_')}",
      partial: "tasks/task",
      locals: { task: self }
    )
    broadcast_notification("Task '#{title}' created!")
  end

  def broadcast_update
    Turbo::StreamsChannel.broadcast_remove_to(
      "tasks_#{status_was.parameterize(separator: '_')}",
      target: dom_id(self)
    )
    Turbo::StreamsChannel.broadcast_append_to(
      "tasks_#{status.parameterize(separator: '_')}",
      target: "tasks_#{status.parameterize(separator: '_')}",
      partial: "tasks/task",
      locals: { task: self }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      "progress-bar",
      target: "progress-bar",
      partial: "tasks/progress_bar",
      locals: { tasks: Task.all }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      "tasks_to_do",
      target: "tasks_to_do",
      partial: "tasks/to_do_list",
      locals: { tasks: Task.all }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      "tasks_in_progress",
      target: "tasks_in_progress",
      partial: "tasks/in_progress_list",
      locals: { tasks: Task.all }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      "tasks_completed",
      target: "tasks_completed",
      partial: "tasks/completed_list",
      locals: { tasks: Task.all }
    )
    broadcast_notification("Task '#{title}' marked as #{status}!")
  end

  def broadcast_destroy
    Turbo::StreamsChannel.broadcast_remove_to(
      "tasks_#{status.parameterize(separator: '_')}",
      target: dom_id(self)
    )
    broadcast_notification("Task '#{title}' deleted!")
  end

  def broadcast_notification(message)
    Turbo::StreamsChannel.broadcast_append_to(
      "notifications",
      target: "notifications",
      partial: "tasks/notification",
      locals: { message: message }
    )
    ActionCable.server.broadcast("tasks", { event: "task_updated" })
  end
end
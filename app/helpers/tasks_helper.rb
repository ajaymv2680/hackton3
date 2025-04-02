module TasksHelper
  def next_status(current_status)
    case current_status
    when "To do"
      "In Progress"
    when "In Progress"
      "Completed"
    else
      "To do"
    end
  end
  def status_badge_class(status)
    case status
    when "To do"
      "bg-secondary"
    when "In Progress"
      "bg-info"
    when "Completed"
      "bg-success"
    else
      "bg-dark"
    end
  end

  def completed_tasks_count(tasks = @tasks)
    tasks&.select { |task| task.status == "Completed" }&.count || 0
  end

  def total_tasks_count(tasks = @tasks)
    tasks&.count || 0
  end

  def completed_percentage(tasks = @tasks)
    total_tasks_count(tasks).zero? ? 0 : (completed_tasks_count(tasks).to_f / total_tasks_count(tasks) * 100).round
  end
  
  def tasks_count(status)
    @tasks&.select { |task| task.status == status }&.count || 0
  end
end
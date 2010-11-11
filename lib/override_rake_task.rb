# OverrideRakeTask
Rake::TaskManager.class_eval do
  def alias_task(old_name, new_name)
    @tasks[new_name] = @tasks.delete(old_name)
  end 
end

def alias_task(old_name, new_name)
  Rake.application.alias_task(old_name, new_name)
end

def override_task(*args, &block)
  name, params, deps = Rake.application.resolve_args(args.dup)
  name_with_scope = "#{Rake.application.current_scope.join(":")}:#{name}"
  alias_task name_with_scope, "#{name_with_scope}:original"
  Rake::Task.define_task(*args, &block)
end

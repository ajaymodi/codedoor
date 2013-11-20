class AddInheritanceToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :type, :string
    Job.update_all(type: 'JobFromDirectContact')
  end
end

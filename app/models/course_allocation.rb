# == Schema Information
#
# Table name: course_allocations
#
#  id              :integer          not null, primary key
#  course_id       :integer
#  teacher_id      :integer
#  batch_id        :integer
#  timings         :string
#  class_timing_id :integer
#  week_day_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class CourseAllocation < ActiveRecord::Base
	belongs_to :course
	belongs_to :teacher
	belongs_to :bactch
	belongs_to :class_timing, class_name: "Timing", foreign_key: :class_timing_id
	belongs_to :week_day
end
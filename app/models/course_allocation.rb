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
#  section_id      :integer
#

class CourseAllocation < ActiveRecord::Base
	belongs_to :course
	belongs_to :teacher
	belongs_to :batch
	belongs_to :section
	belongs_to :class_timing, class_name: "Timing", foreign_key: :class_timing_id
	belongs_to :week_day

	attr_accessor :skip_lab_and_theory_validation

	validates :course_id, :teacher_id, :section_id, :batch_id, presence: true, on: :create
	validate :restrictions

	include ActionView::Helpers::TagHelper

	SectionsValidity = "Please select Sections"
	def self.build_transaction(&block)
		CourseAllocation.transaction do 
			yield
		end
	end

	def restrictions
		if self.teacher_id and self.batch_id and self.course_id
			@teacher = Teacher.find(self.teacher_id)
			batch_id = self.batch_id
			course_id = self.course_id

			allocations = CourseAllocation.where("batch_id = ? and course_id = ?", batch_id, course_id)
			
			# This Code is now handled by Javascript
			assigned_allocations_count = self.batch.sections.count - allocations.count
			if assigned_allocations_count == 0
				errors.add(:base, "This Course is allocated for all the sections.".html_safe)
				return
			end

			teacher_allocations = @teacher.course_allocations.where("batch_id = ? and course_id = ?", batch_id, course_id)

			if teacher_allocations.count == 3
				errors.add(:base, "'#{content_tag(:strong, @teacher.full_name)}' cannot be assigned to more than 3 sections for #{content_tag(:strong, self.batch.batch_name)}".html_safe)
			end

			unless teacher_allocations.present?
				course_allocations = @teacher.course_allocations.where("course_allocations.batch_id = ?", batch_id).joins(:course).where("courses.lab = false or courses.lab = true").select("course_allocations.course_id").group("course_allocations.course_id")

				if course_allocations.length >= 2

					errors.add(:base, "'#{content_tag(:strong, @teacher.full_name)}' can only be assign to 1 Lab and 1 Theory of any course in this Batch.".html_safe)
				end
			end
		end
	end
end

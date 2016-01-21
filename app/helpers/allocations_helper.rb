module AllocationsHelper
	def has_courses(course)
		return "checked='checked'" if course[:has_course] == true
	end

	def remove_all_allocations(batch_id, batch_name)
		link_to "Remove All", "javascript:void(0);", onclick: "removeAllocations(this);", 
																								 data:  { batch_id: "#{batch_id}", 
																							 					  url: remove_allocations_institutes_course_allocations_path(batch_id, format: :json),
																							 					  batch_name: "#{batch_name}"
																						 					  },
																		 					   class: "btn btn-danger btn-sm pull-right"
	end

	def assigned_allocation(allocation)
		CourseAllocation.find_by_batch_id_and_course_id_and_section_id_and_teacher_id(allocation.batch_id, allocation.course_id, section.id, allocation.teacher_id)
	end

	def notification_link(teacher, batch, course)
		content_tag(:a, "Send For Approval", :href => "javascript:void(0)", 
								onclick: "sendApprovalInstructions(this, #{teacher}, #{batch}, #{course})", 
								"data-url" => notify_teacher_institutes_course_allocations_path(format: :json), 
								class: "btn btn-info btn-sm")
	end

	def teacher_allocation_options(options = {})
		html = ""
		html << "<!-- Split button -->
						<div class='btn-group'>
						  <button type='button' class='btn btn-danger'><i class='glyphicon glyphicon-trash'></i> #{options[:teacher_name]}'s Allocations</button>
						  <button type='button' class='btn btn-danger dropdown-toggle' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>
						    <span class='caret'></span>
						    <span class='sr-only'>Toggle Dropdown</span>
						  </button>
						  <ul class='dropdown-menu dropdown-animated'>
						    <li><a href='javascript:void(0)' onclick='removeTeacherAllocations(#{options[:course_id]}, \"not_all\")'>Remove All from this course</a></li>
						    <li><a href='javascript:void(0)' onclick='removeTeacherAllocations(#{options[:course_id]}, \"all\")'>Remove All from #{options[:semester]}</a></li>
						  </ul>
						</div>"

		html.html_safe
	end

	def editable_status(alloc)
		case alloc.status.humanize
		when "Archived"
			content_tag(:span, alloc.status.humanize, class: "label label-danger")
		when "Under approval"
			content_tag(:span, alloc.status.humanize, class: "label label-warning")
		else
			content_tag(:span, alloc.status.humanize, class: "label label-success")
		end
	end

	def pluralize_sections(sections)
		sections.count > 2 ? sections.join(", ") : sections.join(" & ")
	end
end
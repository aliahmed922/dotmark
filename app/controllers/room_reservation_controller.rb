class RoomReservationController < ApplicationController
	# This Controller is used as an api to share data to javascript
	# To asynchronously load data on Teacher's Dashboard
	
	include TimeTableSlots, AllocationsHelper
	prepend_before_action :slots_data, only: [:teacher_allocations]
  respond_to :json

  def index
  end

  def search_allocations
  	allocations = $redis.get("teacher_allocations_#{current_resource}")

  	if allocations.blank?
  		@teacher_allocations = current_resource.under_approval_allocations #Only Under Approval

  		allocations = []
			@teacher_allocations.each do |allocation|

				sections = allocation.sections(allocation).order("name").collect {|m| m.try(:name) }

				allocations << {
					course: allocation.course.name,
					course_type: allocation.course.type_name,
					section: pluralize_sections(sections),
					batch: allocation.batch.name,
					semester: allocation.semester.try(:name),
					sent_date: "---"
				}
        
			end

			allocations = allocations.to_json
			$redis.set("teacher_allocations_#{current_resource}", allocations)
			$redis.expire("teacher_allocations_#{current_resource}", 2.minutes.to_i)
		end

		@allocs = JSON.load allocations
    
		respond_to do |format|
  		format.json { render json: { data: @allocs } }
		end
  end

  def teacher_allocations
    @batch_id = params[:batch_id]

		@allocations = current_resource.course_allocations.under_approval.where(batch_id: @batch_id)

		pending_allocations = @allocations.pending_allocations

		@count_allocations = @allocations.length - pending_allocations.length

    @count_teacher_allocations = @count_allocations

  	@teacher_allocations = current_resource.under_approval_allocations(@batch_id)
  	respond_to do |format|
  		format.js {}
		end
  end

  def schedule_time_cell
  	@batch = Batch.find(params[:batch_id])

  	@timeslot = TimeSlot.find_by_week_day_and_start_time(params[:week_day], params[:time])
  	

		@count_teacher_allocations = count_teacher_reservations(@batch.id)

    @teacher_allocations = current_resource.under_approval_allocations(@batch.id)

    @available_classrooms = @timeslot.available_classrooms

  	respond_to do |format|
  		format.js {}
		end
  end

  def book_room
    logger.debug "Params are :-> #{params}"

    @course_allocations = CourseAllocation.where(teacher_id: params[:teacher_id]).where(batch_id: params[:batch_id])

    result, time_table = TimeTable.build_by_allocations @course_allocations, params

		logger.debug "Transaction: -> #{result}"

		@time_table = time_table

		respond_to do |format|
			format.js {}
		end
	end

	# Remove Reserved room
	def dissmiss_reserved_room
		logger.debug "Params are: -> #{ActiveSupport::JSON.decode(params.to_json)}"
		allocations = TimeTable.dismiss_reservations(params, current_resource)
		allocations.update_all("status = 0") if allocations.count > 1

		@reserved_allocation = allocations.where("time_tables.time_slot_id = ?", params[:slot_id])
		@reserved_allocation.destroy_all

		$redis.del("count_teacher_allocations_#{params[:batch_id]}")

		render :json => { status: :ok, current_domain: request.subdomain }
	end

	private

	def count_teacher_reservations(batch_id)
		@count_allocations = $redis.get("count_teacher_allocations_#{batch_id}")

  	if @count_allocations.blank?
  		@allocations = current_resource.course_allocations.under_approval.where(batch_id: batch_id)

			pending_allocations = @allocations.pending_allocations
			logger.debug "Counting Pending Allocations: -> #{pending_allocations.length}"

			@count_allocations = @allocations.length - pending_allocations.length

  		$redis.set("count_teacher_allocations_#{batch_id}", @count_allocations.to_json)
      $redis.expire("count_teacher_allocations_#{batch_id}", 30.seconds.to_i)
  	end

  	return @count_allocations
	end
end

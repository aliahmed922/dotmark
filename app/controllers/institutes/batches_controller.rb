module Institutes
	class BatchesController < BaseController
		add_breadcrumb "Batches"

		def index
			@batches = Batch.all
		end

		def create
			batch = Batch.new(:name => params[:name], start_date: params[:start_date], end_date: params[:start_date])
	  	@batches = Batch.all
	  	if batch.save
	  		respond_to do |format|
	  			format.js
				end
			else
				render json: { status: :error, errors: "#{batch.errors.full_messages.map { |msg| content_tag(:li, msg) }.join}" }, status: :created
			end
		end

		def update
			@batch = Batch.find(params[:id])
			respond_to do |format|
				if @batch.update(batch_params)
	        format.json { respond_with_bip(@batch) }
	      else
	        format.json { respond_with_bip(@batch) }
	      end
	    end
		end

		def add_sections
			@batch = Batch.find(params[:batch_id])
			no_of_sections = params[:no_of_sections]
			
			@batch.sections.destroy_all if @batch.sections.count > 0

			("A".."F").take(no_of_sections.to_i).each do |section_name|
				@section = @batch.sections.build
				@section.name = section_name
				@section.save!

				puts "---#{@sections.inspect}---"
			end
			
			render json: { status: :ok, sections: @batch.sections.count }, status: :created
		end

		private

		def batch_params
			params.require(:batch).permit(:name, :start_date, :end_date)
		end
	end
end
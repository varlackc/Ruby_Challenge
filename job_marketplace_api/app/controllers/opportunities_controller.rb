class OpportunitiesController < ApplicationController
    before_action :set_opportunity, only: [:show, :apply]

    # Get /opportunities
    def index
        opportunities = Opportunity.includes(:client).where("title ILIKE ?", "%#{params[:search]}%")
        .paginate(page: params[:page], per_page: 10)
        render json: opportunities, include: :client
    end

    # Post /opportinities
    def create
        opportunity = Opportunity.new(opportunity_params)
        opportunity.client = current_client

        if opportunity.save
            render json: opportunity, status: :created
        else
            render json: opportunity.errors, status: :unprocessable_entity
        end
    end

    # POST /opportunities/:id/apply
    def apply
        application = @opportunity.job_applications.new(job_application_params)
        if application.save
            JobApplicationMailer.apply_notification(application).deliver_later
            render json: applicaiton, status: :created
        else
            render json: application.errors, status: :unprocessable_entity
        end
    end

    private

    def set_opportunity
        @opportunity = Opportunity.find(params[:id])
    end

    def opportunity_params
        params.require(:opportunity).permit(:title, :description, :salary)
    end

    def job_application_params
        params.require(:job_application).permit(:job_seeker_name)
    end

end
module Types
  class QueryType < Types::BaseObject
    field :courses, [Types::CourseType], null: false
    field :reviewed_submissions, Types::ReviewedSubmissionType.connection_type, null: false do
      argument :course_id, ID, required: true
      argument :level_id, ID, required: false
    end
    field :review_submission_details, [Types::ReviewSubmissionDetailsType], null: false do
      argument :submission_id, ID, required: true
    end

    def courses
      CoursesResolver.new(context).collection
    end

    def reviewed_submissions(args)
      ReviewedSubmissionsResolver.new(context).collection(args[:course_id], args[:level_id])
    end

    def review_submission_details(args)
      ReviewSubmissionDetailsResolver.new(context).collection(args[:submission_id])
    end
  end
end

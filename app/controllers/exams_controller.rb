class ExamsController < ApplicationController


  #GET /stats

  def stats
    exam_quantity = Exam.count
    render json: { quantity: exam_quantity }, status: :ok
  end

  # GET /exams

  def index
    if params[:level] == 'all'
      @exams = Exam.all
    else
    @exams = Exam.get_quizzes(params[:level])
    
    end 
    render json: @exams, status: :ok
    
  end

  # GET /exams/:id

  def show
    @exam = Exam.find(params[:id])
    render json: @exam, status: :ok
  end

  # POST /exams

  def create

    
    answers = []

    answers << exam_params[:first_answer] if exam_params[:first_answer].present?
    answers << exam_params[:second_answer] if exam_params[:second_answer].present?
    answers << exam_params[:third_answer] if exam_params[:third_answer].present?
    answers << exam_params[:fourth_answer] if exam_params[:fourth_answer].present?
    answers << exam_params[:answers] if exam_params[:answers].present?
    
    @exam = Exam.new(exam_params.except(:first_answer, :second_answer, :third_answer, :fourth_answer))
    # convert form data to json
    @exam.answers = answers

    if @exam.save
      render json: @exam, status: :created
    else
      render json: { errors: @exam.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /exams/:id

  def update
    @exam = Exam.find(params[:id])

    if @exam.update(exam_params)
      render json: @exam, status: :ok
    else
      render json: { message: "Exam cannot be updated" }, status: :unprocessable_entity
    end
  end

  # DELETE /exams/:id

  def destroy
    @exam = Exam.find(params[:id])
    if @exam.destroy
      render json: { message: "Exam has been destroyed", exam: @exam }, status: :ok
    else
      render json: { message: "Exam cannot be destroy" },
             status: :unprocessable_entity
    end
  end

  private

  def exam_params
    params.require(:exam).permit(:question, :answers ,:options, :level, :picture, :correct_answer, :picture, :first_answer, :second_answer, :third_answer, :fourth_answer)
  end
end

# # Path: app/views/exams/index.html.erb
# <h1>Exams</h1>

# <table>
#   <thead>
#     <tr>
#       <th>Question</th>
#       <th>Options</th>
#       <th>Answer</th>
#       <th>Level</th>
#       <th colspan="3"></th>
#     </tr>
#   </thead>

#   <tbody>
#     <% @exams.each do |exam| %>
#       <tr>
#         <td><%= exam.question %></td>
#         <td><%= exam.options %></td>
#         <td><%= exam.answer %></td>
#         <td><%= exam.level %></td>
#         <td><%= link_to 'Show', exam %></td>
#         <td><%= link_to 'Edit', edit_exam_path(exam) %></td>
#         <td><%= link_to 'Destroy', exam, method: :delete, data: { confirm: 'Are you sure?' } %></td>
#       </tr>
#     <% end %>
#   </tbody>
# </table>

# <br>

# <%= link_to 'New Exam', new_exam_path %>

# # Path: app/views/exams/show.html.erb
# <p id="notice"><%= notice %></p>

# <p>
#   <strong>Question:</strong>
#   <%= @exam.question %>
# </p>

# <p>
#   <strong

# require 'json'

# def generate_exam
#     level = params[:level]
#     questions = Exam.where(level: level).sample(40)
  
#     if questions.empty?
#       render json: { error: 'No questions found for this level' }, status: :not_found
#       return
#     end
  
#     exam_data = questions.map do |question|
#       {
#         id: question.id,
#         question: question.question,
#         options: question.options,
#         answer: question.answer
#       }
#     end
  
#     begin
#       File.open('exam.json', 'w') do |file|
#         file.write(JSON.pretty_generate(exam_data))
#       end
#       render json: { message: 'Exam generated successfully' }, status: :ok
#     rescue => e
#       render json: { error: 'Error generating exam: ' + e.message }, status: :internal_server_error
#     end
#   end

# Usage example: generate_exam('intermediate')

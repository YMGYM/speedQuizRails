require 'csv'
namespace :import_all_question do
  task :create_questions => :environment do
    CSV.foreach("Questions/AllQuestionList.csv", :headers => true) do |row|
      row.first[0] = row.first[0][1..2]
      Question.create!(row.to_hash)
    end
  end
end
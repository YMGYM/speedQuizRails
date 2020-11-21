require 'csv'
namespace :import_all_question do
  task :create_questions => :environment do
    CSV.foreach("Questions/AllQuestionList.csv", :headers => true) do |row|
      row.first[0] = row.first[0][1..]
      puts row.to_hash
      Question.create!(row.to_hash)
    end
  end

  task :create_questions_production => :production do
    CSV.foreach("Questions/AllQuestionList.csv", :headers => true) do |row|
      row.first[0] = row.first[0][1..]
      puts row.to_hash
      Question.create!(row.to_hash)
    end
  end
end

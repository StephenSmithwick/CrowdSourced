require 'ankusa'
require 'ankusa/mongo_db_storage'

class TextualAnalyzer
  def initialize(db="ankusa", host="localhost", port="27017")
    storage = Ankusa::MongoDbStorage.new :host => host, :port => port, :db => db
    @c = Ankusa::NaiveBayesClassifier.new storage
  end

  def train_each_line tag, file
    file.each do |line|
      begin
        train tag, line
        print "."
      rescue
        print "!"
      end
      STDOUT.flush
    end
  end

  def train_all_file tag, file
    begin
      text = file.read
      train tag, text
      print "."
    rescue
      print "!"
    end
    STDOUT.flush
  end

  def train tag, line
    @c.train tag, line
  end


  def classify line
    @c.classify line
  end

  def classifications line
    @c.classifications line
  end

end

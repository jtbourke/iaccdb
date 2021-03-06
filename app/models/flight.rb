class Flight < ActiveRecord::Base
  attr_accessible :name, :sequence, :category_id, :chief_id, :assist_id

  belongs_to :contest
  belongs_to :category
  belongs_to :chief, :foreign_key => "chief_id", :class_name => 'Member'
  belongs_to :assist, :foreign_key => "assist_id", :class_name => 'Member'
  has_many :pilot_flights, :dependent => :destroy
  has_many :pilots, :through => :pilot_flights, :class_name => 'Member'
  has_many :f_results, :dependent => :destroy
  
  def to_s
    "Flight #{id} #{contest.name} #{displayName}"
  end

  def displayName
    "#{displayCategory} #{name if category.category != 'four minute'}"
  end

  def displayCategory
    category.name
  end

  def display_chief
    s = chief ? chief.name : ''
    s += (assist ? " assisted by #{assist.name}" : '')
  end

  def count_judges
    Judge.find_by_sql("select distinct s.judge_id 
      from scores s, pilot_flights p 
      where p.flight_id = #{id} and s.pilot_flight_id = p.id").count
  end

  def count_pilots
    pilot_flights.length
  end

  def count_figures_graded
    total_count = 0
    #pilot_flights.inject do |total_count, pilot_flight|
    #  total_count + pilot_flight.sequence.figure_count
    #  total_count
    pilot_flights.each do |pilot_flight|
      total_count += pilot_flight.sequence.figure_count
    end
    total_count
  end

  # get or create f_results, does not compute
  def results
    if f_results.empty?
      f_results.build
      save
    end
    f_results
  end

  # ensure rollups for this flight have been calculated
  # there's really only one f_result for now
  def compute_flight_results(has_soft_zero = false)
    if f_results.empty?
      f_results.build
      save
    end
    f_results.each do |f_result| 
      f_result.results(has_soft_zero)
    end
    f_results
  end
end

class Category < ActiveRecord::Base
  has_many :jy_results
  has_many :flights
  has_many :c_results
  has_many :region_pilots

  attr_accessible :sequence, :category, :aircat, :name

  def self.find_for_cat_aircat(cat, aircat)
    aircat = aircat && aircat =~ /g/i ? 'G' : 'P'
    mycat = Category.find_by_category_and_aircat(cat.downcase, aircat)
    if !mycat
      if /Pri|Bas/i =~ cat
        mycat = Category.find_by_category_and_aircat('primary', aircat)
      elsif /Spn|Sport|Standard/i =~ cat
        mycat = Category.find_by_category_and_aircat('sportsman', aircat)
      elsif /Adv/i =~ cat
        mycat = Category.find_by_category_and_aircat('advanced', aircat)
      elsif /Imdt|Intmdt/i =~ cat
        mycat = Category.find_by_category_and_aircat('intermediate', aircat)
      elsif /Unl/i =~ cat
        mycat = Category.find_by_category_and_aircat('unlimited', aircat)
      elsif /Minute|Four/i =~ cat
        mycat = Category.find_by_category_and_aircat('four minute', 'P')
      end
    end
    mycat
  end

  def is_primary
    /primary|basic/i =~ self.category
  end

  def to_s
    name
  end

end

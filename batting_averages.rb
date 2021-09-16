require 'csv'
class BattingPerformance
  @@records = []
  @@teams = CSV.parse(File.read("Teams.csv"), headers: true)

  def read_data(yearID=nil, teamID=nil)
    CSV.foreach("Batting.csv", headers: true ) do |row|
      if yearID && teamID
        @@records.push(row) if row['yearID'].to_i == yearID.to_i && row['teamID'].to_i == teamID.to_i
      else
        if yearID
          @@records.push(row) if row['yearID'].to_i == yearID.to_i
        elsif teamID
          @@records.push(row) if row['teamID'].to_i == teamID.to_i
        else
          @@records.push(row)
        end
      end
    end
    print_results
  end

  private
  def print_results
    puts "(PlayerID), (YearID), (Team Name), (Batting Average)";
    @@records.each do |r|
      team_id = r['teamID'].to_i
      puts "#{r['playerID']}, " + "#{r['yearID']}, " + "#{@@teams[team_id-1][1]}, " +
             "#{calculate_batting_average(r['H'], r['AB'])}"
    end
  end

  def calculate_batting_average(hits, at_bats)
    at_bats.to_i > 0 ? hits.to_i / at_bats.to_i : 0
  end
end

puts "Enter YearID filter (press Enter key otherwise):"
year = gets
puts "Enter TeamID filter (press Enter key otherwise):"
team = gets

BattingPerformance.new.read_data(year.length > 1 ? year:nil , team.length > 1 ? team:nil)

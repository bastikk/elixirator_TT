class SpaceMissionFuelCalculator
  def initialize(mass, flight_route)
    @mass = mass
    @flight_route = flight_route
  end

  def calculate_total_fuel
    @flight_route.reverse.reduce(0) do |fuel, (action, gravity)|
      step_fuel = calculate_step_fuel(@mass + fuel, action, gravity)
      additional_fuel = calculate_additional_fuel(step_fuel, action, gravity)
      fuel + step_fuel + additional_fuel
    end
  end

  private

  def calculate_step_fuel(mass, action, gravity)
    case action
    when :launch
      (mass * gravity * 0.042 - 33).floor
    when :land
      (mass * gravity * 0.033 - 42).floor
    else
      raise "Unknown action: #{action}"
    end
  end

  def calculate_additional_fuel(fuel, action, gravity)
    additional_fuel = 0
    while fuel.positive?
      fuel = calculate_step_fuel(fuel, action, gravity)
      additional_fuel += fuel if fuel.positive?
    end
    additional_fuel
  end
end

# Example usage for Apollo 11 mission
apollo_11_route = [[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 9.807]]
calculator = SpaceMissionFuelCalculator.new(28_801, apollo_11_route)
puts "Total fuel required for Apollo 11 mission: #{calculator.calculate_total_fuel} kg"


mars_route = [[:launch, 9.807], [:land, 3.711], [:launch, 3.711], [:land, 9.807]]
calculator = SpaceMissionFuelCalculator.new(14_606, mars_route)
puts "Total fuel required for mission on Mars: #{calculator.calculate_total_fuel} kg"

mars_route = [[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 3.711], [:launch, 3.711], [:land, 9.807]]
calculator = SpaceMissionFuelCalculator.new(75_432, mars_route)
puts "Total fuel required for passenger ship mission: #{calculator.calculate_total_fuel} kg"

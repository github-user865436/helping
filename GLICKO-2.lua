--The Glicko 2 rating system is not meant to calculate live ratings. You can instead use this system mostly for placement games. Typically with length in 10 - 15.
return function(Data)
	local function Conversion(Converting, Inverse)
		local ConversionConstant = 173.7178
		local DummyTable = table.clone(Converting)
		if not Inverse then
			DummyTable.Rating = (DummyTable.Rating - 1500) / ConversionConstant
			DummyTable.RatingDeviation = DummyTable.RatingDeviation / ConversionConstant
		else
			DummyTable.Rating = DummyTable.Rating * ConversionConstant + 1500
			DummyTable.RatingDeviation = DummyTable.RatingDeviation * ConversionConstant
		end
		return DummyTable
	end
	
	Data.Base = Conversion(Data.Base)
	for i, opponent in Data.Games do
		Data.Games[i] = Conversion(Data.Games[i])
	end

	--Establish very necessary variables
	local a = 2 * math.log(Data.Base.Volatility, math.exp(1))
	local function g(RatingDeviation)
		return 1 / math.sqrt(1 + ((3 * RatingDeviation^2) / (math.pi^2)))
	end

	local function E(Rating, OppoonentRating, OpponentRatingDeviation)
		return 1 / (1 + math.exp(-g(OpponentRatingDeviation) * (Rating - OppoonentRating)))
	end

	local cv = 0
	local cdelta = 0
	
	for k = 1, #Data.Games do
		local Rating = Data.Base.Rating
		local OpponentRating = Data.Games[k].Rating
		local OpponentRatingDeviation = Data.Games[k].RatingDeviation
		
		local GameScore = Data.Games[k].Score

		local gValue = g(OpponentRating)
		local eValue = E(Rating, OpponentRating, OpponentRatingDeviation)
		
		cv += (gValue^2) * eValue * (1 - eValue)
		cdelta += gValue * (GameScore - eValue)
		
		--print(OpponentRating, OpponentRatingDeviation, gValue, eValue, GameScore, gValue * (GameScore - eValue))
	end
	
	local v = 1 / cv
	local delta = v * cdelta

	local side1 = delta^2
	local side2 = Data.Base.RatingDeviation + v

	--false position procedure varient
	local function IllinoisAlgorithm(x)
		local value1numerator = math.exp(x) * (side1 - side2 - math.exp(x))
		local value1denominator = 2 * (side2 + math.exp(x))^2
		local value2numerator = x - a
		local value2denominator = Data.Constant^2
		return value1numerator/value1denominator - value2numerator/value2denominator
	end

	--define and converge A and B
	local A = a
	local B
	if side1 > side2 then
		B = math.log(side1 - side2, math.exp(1))
	else --get a K value in calculation B
		local k = 1
		local function Iterate()
			if IllinoisAlgorithm(a - k * Data.Constant) < 0 then
				k = k + 1
				Iterate()
			end
		end
		B = a - k * Data.Constant
	end
	
	local scientific = 10
	local ConvergenceTolerance = scientific^-6
	
	local f_A = IllinoisAlgorithm(A)
	local f_B = IllinoisAlgorithm(B)
	while math.abs(B - A) > ConvergenceTolerance do
		wait()
		local C = A + (A - B) * (f_A / (f_B - f_A))
		local f_C = IllinoisAlgorithm(C) --It never defines f_C, we have to assume.
		if f_C * f_B <= 0 then
			A = B
			f_A = f_B
		else
			f_A = f_A / 2
		end

		B = C
		f_B = f_C
	end
	
	--The code onward is meant to take the numbers given and translate them into new ratings.
	local function Round(number, power, decimal)
		if not power then power = 10 end
		local multiple = power^decimal
		return math.round(multiple * number) / multiple
	end
	
	Data.Base.Volatility = math.sqrt(math.exp(A))
	Data.Base.RatingDeviation = math.sqrt(Data.Base.RatingDeviation^2 + Data.Base.Volatility^2) --Continue to do even if the player did not compete in the rating period
	Data.Base.RatingDeviation = 1 / math.sqrt(1 / Data.Base.RatingDeviation^2 + 1 / v)
	
	--print(Data.Base.Rating, Data.Base.RatingDeviation, Data.Base.Volatility, v, delta, A, B, f_A, f_B)
	
	local n = Data.Base.RatingDeviation^2 + Data.Base.Volatility^2
	Data.Base.Rating += delta * (n / (n + v))
	
	Data.Base = Conversion(Data.Base, true)
	
	return {
		Rating = Round(Data.Base.Rating, 1),
		RatingDeviation = Round(Data.Base.RatingDeviation, 1),
		Volatility = Round(Data.Base.Volatility, -math.log(ConvergenceTolerance, scientific))
	}
end

class Acronym
	def self.abbreviate
		string.scan(/\b[a-zA-Z]/).join.upcase
	end
end

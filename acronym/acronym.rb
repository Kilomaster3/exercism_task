class Acronym
	ABBREVIATURE = /\b[a-zA-Z]/

	def self.abbreviate
		string.scan(ABBREVIATURE).join.upcase
	end
end

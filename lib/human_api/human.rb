
# THE MODULE
module HumanApi
	# THE CLASS
	class Human < Nestful::Resource

		attr_reader :token

		# The host of the api
		endpoint 'https://api.humanapi.co'

		# The path of the api
		path '/v1/human'

		# The available methods for this api
		AVAILABLE_METHODS = [
							:profile,
							:activities,
							:blood_glucose,
							:blood_oxygen,
							:blood_pressure,
							:body_fat,
							:genetic_traits,
							:heart_rate,
							:height,
							:locations,
							:sleeps,
							:weight,
							:bmi,
              :sources,
              :human
							]

		def initialize(options)
			@token = options[:access_token]
			super
		end

		# Profile =====================================

		def summary
			get('', :access_token => token)
		end

		def profile
			query('profile')
		end

		# =============================================

		def query(method, options = {})

			# Is this method in the list?
			if AVAILABLE_METHODS.include? method.to_sym
				# From sym to string
				method = method.to_s

				# The base of the url
				url = "#{method}"

				# If it is a singular word prepare for readings
				if method.is_singular?
					if options[:readings] == true
						url += "/readings"
					end
				else
					if options[:summary] == true
						url += "/summary"
					elsif options[:summaries] == true
						url +/ "/summaries"
					end
				end

				# You passed a date
				if options[:date].present?
					# Make a request for a specific date
					url += "/daily/#{options[:date]}"
				# If you passed an id
				elsif options[:id].present?
					# Make a request for a single
					url += "/#{options[:id]}"
				end

				if options[:updated_since].present?
					updated_since = options[:updated_since]

					if updated_since.class == 'Date'
						updated_since = updated_since.strftime("%Y%m%dT%H%M%S%z")
					end

					url += "?updated_since=" + updated_since
				end

				# Make the request finally
				result = get(url, :access_token => token)

				# Converting to json the body string
				JSON.parse(result.body)
			else
				# Tell the developer the method is not there
				"The method '#{method}' does not exist!"
			end

		end

	end
end

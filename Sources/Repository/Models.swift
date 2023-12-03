//
//  ShiftsResponseDTO.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import CoreLocation
import Core
extension ShiftDTO {
	var mapToAppModel: Shift {
		.init(id: self.id,
			  image: self.job.imageURL,
			  location: .init(location: self.job.address.coordinate.coordinate),
			  title: self.job.clientName,
			  startAt: self.startsAt.dateDisplay,
			  endAt: self.endsAt.dateDisplay,
			  earningsPerHour: self.earningsPerHour, category: self.job.category)
	}
}

extension GetShitsFilter {
	func toQueryParam() -> (key: String,value: String) {
		let filterFormat = "filter[%@]"
		switch self {
		case .date(let date):
			let dateFormatter = ISO8601DateFormatter()
			dateFormatter.formatOptions = .withFullDate
			return (String(format: filterFormat, "date"), value: dateFormatter.string(from: date))
		}
	}
}
struct ShiftsResponseDTO: Decodable {
	let data: [ShiftDTO]
	let count: Int

	enum CodingKeys: String, CodingKey {
		case data
		case count = "aggregations"
	}

	enum AggregationsKeys: String, CodingKey {
		case count
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let aggregationsValues = try values.nestedContainer(keyedBy: AggregationsKeys.self, forKey: .count)

		data = try values.decode([ShiftDTO].self, forKey: .data)
		count = try aggregationsValues.decode(Int.self, forKey: .count)
	}
}

struct ShiftDTO: Decodable {
	let id: String
	let startsAt: Date
	let endsAt: Date
	let earningsPerHour: String
	let job: JobDTO

	static let isoDateFormatter: ISO8601DateFormatter = {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
		return formatter
	}()

	enum CodingKeys: String, CodingKey {
		case id
		case startsAt = "starts_at"
		case endsAt = "ends_at"
		case earningsPerHour = "earnings_per_hour"
		case job
	}

	enum EarningsPerHourKeys: String, CodingKey {
		case currency
		case amount
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		// id
		id = try values.decode(String.self, forKey: .id)

		// startsAt
		guard let startsAtValue = ShiftDTO.isoDateFormatter.date(from: try values.decode(String.self, forKey: .startsAt)) else {
			throw DecodingError.dataCorruptedError(forKey: .startsAt, in: values, debugDescription: "Expecting a valid date format")
		}

		startsAt = startsAtValue

		// endsAt
		guard let endsAtValue = ShiftDTO.isoDateFormatter.date(from: try values.decode(String.self, forKey: .endsAt)) else {
			throw DecodingError.dataCorruptedError(forKey: .startsAt, in: values, debugDescription: "Expecting a valid date format")
		}

		endsAt = endsAtValue

		// earningsPerHour
		let earningsPerHourValues = try values.nestedContainer(keyedBy: EarningsPerHourKeys.self, forKey: .earningsPerHour)

		let earningsPerHourCurrencyValue = try earningsPerHourValues.decode(String.self, forKey: .currency)
		let earningsPerHourAmountValue = try earningsPerHourValues.decode(Double.self, forKey: .amount)

		earningsPerHour = "\(Currency(shorthand: earningsPerHourCurrencyValue).sign) \(earningsPerHourAmountValue)"

		// job
		job = try values.decode(JobDTO.self, forKey: .job)
	}

	struct JobDTO: Decodable {
		let clientName: String
		let imageURL: URL
		let category: String
		let address: AddressDTO

		enum CodingKeys: String, CodingKey {
			case title
			case project
			case category
			case address = "report_at_address"
		}

		enum ProjectKeys: String, CodingKey {
			case client
		}

		enum ClientKeys: String, CodingKey {
			case name
			case links
		}

		enum LinksKeys: String, CodingKey {
			case heroImage = "hero_image"
		}

		enum CategoryKeys: String, CodingKey {
			case nameTranslation = "name_translation"
		}

		enum NameTranslationKeys: String, CodingKey {
			case english = "en_GB"
			case englishNL = "en_NL"
		}

		init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			let projectValues = try values.nestedContainer(keyedBy: ProjectKeys.self, forKey: .project)

			let clientValues = try projectValues.nestedContainer(keyedBy: ClientKeys.self, forKey: .client)
			let linksValues = try clientValues.nestedContainer(keyedBy: LinksKeys.self, forKey: .links)

			let categoryValues = try values.nestedContainer(keyedBy: CategoryKeys.self, forKey: .category)
			let nameTranslationValues = try categoryValues.nestedContainer(keyedBy: NameTranslationKeys.self, forKey: .nameTranslation)

			address = try values.decode(AddressDTO.self, forKey: .address)
			clientName = try clientValues.decode(String.self, forKey: .name)
			category = (try? nameTranslationValues.decode(String.self, forKey: .english)) ?? (try? nameTranslationValues.decode(String.self, forKey: .englishNL)) ?? "Untitled"
			imageURL = try linksValues.decode(URL.self, forKey: .heroImage)
		}
	}

	struct AddressDTO: Decodable {
		let coordinate: CLLocation

		enum CodingKeys: String, CodingKey {
			case coordinates = "geo"
		}

		enum CoordinateKeys: String, CodingKey {
			case latitude = "lat"
			case longitude = "lon"
		}

		init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			let coordinateValues = try values.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .coordinates)

			let latitude = try coordinateValues.decode(CLLocationDegrees.self, forKey: .latitude)
			let longitude = try coordinateValues.decode(CLLocationDegrees.self, forKey: .longitude)

			coordinate = CLLocation(latitude: latitude, longitude: longitude)
		}
	}
}

enum Currency {
	case euro
	case unitedStatesDollar
	case unknown

	init(shorthand: String) {
		switch shorthand {
		case "EUR":
			self = .euro
		case "USD":
			self = .unitedStatesDollar
		default:
			self = .unknown
		}
	}

	var sign: String {
		switch self {
		case .euro:
			return "€"
		case .unitedStatesDollar:
			return "$"
		case .unknown:
			return "?"
		}
	}
}

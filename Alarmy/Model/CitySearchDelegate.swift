import Foundation

protocol CitySearchDelegate: AnyObject {
    func didSelectCity(city data: (cityName: String, countryName: String, timeZoneID: String))
}

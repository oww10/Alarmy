import Foundation

class WorldClockModel {
    static let shared = WorldClockModel()
    private init() {}
    
    func worldClockData() -> [(cityName: String, countryName: String, timeZoneID: String)] {
        var worldClockArray: [(cityName: String, countryName: String, timeZoneID: String)] = []
        
        let koreanLocale = Locale(identifier: "ko_KR")
        var uniqueCheck: Set<String> = []       // 중복 확인용
        
        for tzID in TimeZone.knownTimeZoneIdentifiers {
            guard let timeZone = TimeZone(identifier: tzID) else { continue }
            
            let parts = tzID.split(separator: "/")
            
            // 나라 이름 추출
            var regionCode: String? = nil
            
            // parts[1]에 나라 코드가 있는 경우 (Continent/Country/City) 사용
            // parts[0]에 대륙 이름이 있는 경우 (Continent/City) 사용
            if parts.count >= 3 {
                regionCode = String(parts[1])
            } else if parts.count == 2 {
                regionCode = String(parts[0])
            } else { continue }

            guard let finalRegionCode = regionCode else { continue }
 
            let localizedName = koreanLocale.localizedString(forRegionCode: finalRegionCode)
            let countryName = localizedName ?? finalRegionCode
            
            // 도시 이름 추출
            // "_" 공백으로 변경
            let rawCityName = parts.last?.replacingOccurrences(of: "_", with: " ") ?? ""
            // .shortGeneric 사용해서 가장 짧은 지역 이름 번역
            let localizedCityName = timeZone.localizedName(for: .shortGeneric, locale: koreanLocale)
            
            // 번역 후 불필요한 단어 제거
            let cityName: String
            if let localizedName = localizedCityName {
                let cleanedName = localizedName
                    .replacingOccurrences(of: "시간", with: "")
                    .replacingOccurrences(of: "표준시", with: "")
                    .replacingOccurrences(of: "일광 절약 시간", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                if cleanedName.isEmpty || cleanedName.contains("GMT") {
                    cityName = rawCityName
                } else {
                    cityName = cleanedName
                }
            } else {
                 cityName = rawCityName
            }
            
            // 배열에 추가 (도시 이름과 지역 이름이 모두 있어야 함)
            if cityName.isEmpty || countryName.isEmpty { continue }
            
            // 중복 목록 제거하기
            let compoundKey = "\(cityName), \(countryName)"
            if uniqueCheck.contains(compoundKey) { continue }
            uniqueCheck.insert(compoundKey)
            worldClockArray.append((cityName: cityName, countryName: countryName, timeZoneID: tzID))
        }
        // 목록 정렬
        worldClockArray.sort { lhs, rhs in lhs.cityName < rhs.cityName }
        return worldClockArray
    }
}

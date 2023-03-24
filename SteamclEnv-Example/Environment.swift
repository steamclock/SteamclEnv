// @generated
//  This file was automatically generated and should not be edited.
enum Environment {
    private static let salt: [UInt8] = [86, 49, 191, 181, 18, 159, 126, 44]

    private static func decode(_ encoded: [UInt8]) -> String {
      String(decoding: encoded.enumerated().map { (offset, element) in
              element ^ salt[offset % salt.count]
          }, as: UTF8.self
      )
    }
    static var API_URL: String {
        let encoded: [UInt8] = [62, 69, 203, 197, 97, 165, 81, 3, 49, 94, 208, 210, 126, 250, 80, 79, 57, 92]
        return decode(encoded)
    }
}
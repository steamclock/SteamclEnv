// @generated
//  This file was automatically generated and should not be edited.
enum Environment {
    private static let salt: [UInt8] = [250, 60, 40, 252, 42, 69, 54, 247]

    private static func decode(_ encoded: [UInt8]) -> String {
      String(decoding: encoded.enumerated().map { (offset, element) in
              element ^ salt[offset % salt.count]
          }, as: UTF8.self
      )
    }
    static var API_URL: String {
        let encoded: [UInt8] = [146, 72, 92, 140, 89, 127, 25, 216, 157, 83, 71, 155, 70, 32, 24, 148, 149, 81]
        return decode(encoded)
    }
    static var SECRET_KEY: String {
        let encoded: [UInt8] = [203, 93, 26, 157, 25, 36, 2, 150]
        return decode(encoded)
    }
}
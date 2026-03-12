// @generated
// This file was automatically generated and should not be edited.
// swiftlint:disable all

enum Environment {
    private static let salt: [UInt8] = [92, 10, 254, 26, 195, 39, 96, 245]

    private static func decode(_ encoded: [UInt8]) -> String {
      String(
          decoding: encoded.enumerated().map { offset, element in element ^ salt[offset % salt.count] },
          as: UTF8.self
      )
    }

    static var API_URL: String {
        let encoded: [UInt8] = [52, 126, 138, 106, 176, 29, 79, 218, 59, 101, 145, 125, 175, 66, 78, 150, 51, 103]
        return decode(encoded)
    }
    static var SECRET_KEY: String {
        let encoded: [UInt8] = [109, 107, 204, 123, 240, 70, 84, 148]
        return decode(encoded)
    }
// swiftlint:enable all    
}
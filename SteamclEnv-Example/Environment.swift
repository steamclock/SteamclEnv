// @generated
// This file was automatically generated and should not be edited.
// swiftlint:disable all

enum Environment {
    private static let salt: [UInt8] = [255, 20, 224, 63, 151, 215, 22, 48]

    private static func decode(_ encoded: [UInt8]) -> String {
      String(
          decoding: encoded.enumerated().map { offset, element in element ^ salt[offset % salt.count] },
          as: UTF8.self
      )
    }

    static var SECRET_KEY: String {
        let encoded: [UInt8] = [206, 117, 210, 94, 164, 182, 34, 81]
        return decode(encoded)
    }
    static var API_URL: String {
        let encoded: [UInt8] = [151, 96, 148, 79, 228, 237, 57, 31, 152, 123, 143, 88, 251, 178, 56, 83, 144, 121]
        return decode(encoded)
    }
// swiftlint:enable all    
}
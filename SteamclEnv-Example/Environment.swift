// @generated
// This file was automatically generated and should not be edited.
// swiftlint:disable all

enum Environment {
    private static let salt: [UInt8] = [105, 212, 184, 91, 62, 146, 74, 5]

    private static func decode(_ encoded: [UInt8]) -> String {
      String(
          decoding: encoded.enumerated().map { offset, element in element ^ salt[offset % salt.count] },
          as: UTF8.self
      )
    }

    static var API_URL: String {
        let encoded: [UInt8] = [1, 160, 204, 43, 77, 168, 101, 42, 14, 187, 215, 60, 82, 247, 100, 102, 6, 185]
        return decode(encoded)
    }
    static var SECRET_KEY: String {
        let encoded: [UInt8] = [88, 181, 138, 58, 13, 243, 126, 100]
        return decode(encoded)
    }
// swiftlint:enable all    
}
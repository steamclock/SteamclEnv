// @generated
//  This file was automatically generated and should not be edited.
enum Environment {
    private static let salt: [UInt8] = [98, 55, 232, 225, 187, 92, 98, 195]

    private static func decode(_ encoded: [UInt8]) -> String {
      String(decoding: encoded.enumerated().map { (offset, element) in
              element ^ salt[offset % salt.count]
          }, as: UTF8.self
      )
    }
    static var API_URL: String {
        let encoded: [UInt8] = [10, 67, 156, 145, 200, 102, 77, 236, 5, 88, 135, 134, 215, 57, 76, 160, 13, 90]
        return decode(encoded)
    }
}
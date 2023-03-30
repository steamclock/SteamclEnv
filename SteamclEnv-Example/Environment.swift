// @generated
//  This file was automatically generated and should not be edited.
enum Environment {
    private static let salt: [UInt8] = [41, 149, 26, 106, 250, 201, 9, 57]

    private static func decode(_ encoded: [UInt8]) -> String {
      String(decoding: encoded.enumerated().map { (offset, element) in
              element ^ salt[offset % salt.count]
          }, as: UTF8.self
      )
    }
    static var API_URL: String {
        let encoded: [UInt8] = [65, 225, 110, 26, 137, 243, 38, 22, 78, 250, 117, 13, 150, 172, 39, 90, 70, 248]
        return decode(encoded)
    }
}
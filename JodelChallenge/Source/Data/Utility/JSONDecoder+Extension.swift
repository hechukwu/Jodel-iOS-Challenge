import Foundation

typealias StringAnyDictionary = [String:Any?]

extension JSONDecoder {

    /**
     To remove the step of first converting to Data before calling JSONDecoder.decode() everywhere
     */
    func decode<T: Decodable>(_ type: T.Type, from source: String) -> T? {
        do {
            if let data = source.data(using: .utf8) {
                return try decode(type, from: data)
            }
            return nil
        }
        catch {
            print(error)
            return nil
        }
    }

    /**
     To remove the step of first converting to Data before calling JSONDecoder.decode() everywhere
     */
    func decode<T: Decodable>(_ type: T.Type, from dictionary: Dictionary<String, Any?>) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            return try decode(type, from: data)
        }
        catch {
            print(error)
            return nil
        }
    }

    /**
     To remove the step of first converting to Data before calling JSONDecoder.decode() everywhere
     */
    func decode<T>(_ type: T.Type, from source: [StringAnyDictionary]) -> T? where T : Decodable {
        do {
            let data = try JSONSerialization.data(withJSONObject: source, options: JSONSerialization.WritingOptions.prettyPrinted)
            return try decode(type, from: data)
        }
        catch {
            print(error)
            return nil
        }
    }
}

import Foundation

class BruteForce {
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }
    
    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var result: String = string
        if result.count <= 0 {
            result.append(characterAt(index: 0, array))
        }
        else {
            result.replace(at: result.count - 1,
                           with: characterAt(index: (indexOf(character: result.last ?? Character(""), array) + 1) % array.count, array))
            if indexOf(character: result.last ?? Character(""), array) == 0 {
                result = String(generateBruteForce(String(result.dropLast()), fromArray: array)) + String(result.last ?? Character(""))
            }
        }
        return result
    }
}

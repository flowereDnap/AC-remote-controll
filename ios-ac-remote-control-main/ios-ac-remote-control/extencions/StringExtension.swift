import Foundation

extension String {
    func isValidPassword() -> Bool {
        // Password should contain at least one letter, one number, and one special character, and no spaces
        let letterRegex = ".*[a-zA-Z]+.*"
        let numberRegex = ".*[0-9]+.*"
        let specialCharacterRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
        let spaceRegex = ".*\\s+.*"

        let containsLetter = NSPredicate(format: "SELF MATCHES %@", letterRegex)
        let containsNumber = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        let containsSpecialCharacter = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        let containsSpace = NSPredicate(format: "SELF MATCHES %@", spaceRegex)

        return containsLetter.evaluate(with: self) &&
            containsNumber.evaluate(with: self) &&
            containsSpecialCharacter.evaluate(with: self) &&
            !containsSpace.evaluate(with: self)
    }
    
    func isValidText() -> Bool {
        return self.isEmpty
    }
}

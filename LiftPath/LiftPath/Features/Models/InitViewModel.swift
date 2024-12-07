//
//  InitViewModel.swift
//  LiftPath
//
//  Created by Evan Huang on 12/7/24.
//

import Foundation

final class InitialSetupViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var age: String = ""
    @Published var isFormValid: Bool = false
    @Published var showError: Bool = false

    private let userData = UserData.shared

    func validateForm() {
        let isUsernameValid = username.count >= 2 && username.count <= 15
        let isAgeValid = Int(age) ?? 0 > 0 && Int(age) ?? 0 < 120

        isFormValid = isUsernameValid && isAgeValid
        showError = !isFormValid && (!username.isEmpty || !age.isEmpty)
    }

    func saveProfileData() {
        guard isFormValid else { return }

        userData.username = username
        userData.age = Int(age) ?? 0
    }
}

//
//  SignUpViewModel.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import Foundation
import CryptoKit

@MainActor
final class AuthViewModel: ObservableObject {

    @Published private(set) var currentUser: AppUser?
    @Published var isLoading = false
    @Published var errorMessage: String?

    var isLoggedIn: Bool { currentUser != nil }

    private let usersKey = "AuthUsers"
    private let sessionKey = "AuthSessionEmail"

    init() { restoreSession() }

    // MARK: - Sign up

    func signUp(name: String, email: String, password: String, confirm: String) async {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = normalized(email)

        if let problem = validateSignUp(name: name, email: email, password: password, confirm: confirm) {
            errorMessage = problem
            return
        }

        isLoading = true
        try? await Task.sleep(nanoseconds: 800_000_000)   // simulates a network call
        defer { isLoading = false }

        var users = loadUsers()
        guard users[email] == nil else {
            errorMessage = "An account with this email already exists."
            return
        }

        let salt = UUID().uuidString
        let user = AppUser(
            id: UUID(),
            name: name,
            email: email,
            salt: salt,
            passwordHash: hash(password, salt: salt)
        )

        users[email] = user
        saveUsers(users)
        startSession(for: user)
    }

    // MARK: - Log in

    func login(email: String, password: String) async {
        let email = normalized(email)

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter your email and password."
            return
        }

        isLoading = true
        try? await Task.sleep(nanoseconds: 800_000_000)
        defer { isLoading = false }

        // Same message for "no account" and "wrong password" so it doesn't leak which emails exist
        guard let user = loadUsers()[email],
              user.passwordHash == hash(password, salt: user.salt)
        else {
            errorMessage = "Invalid email or password."
            return
        }

        startSession(for: user)
    }

    // MARK: - Log out

    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: sessionKey)
    }

    // MARK: - Session

    private func startSession(for user: AppUser) {
        currentUser = user
        UserDefaults.standard.set(user.email, forKey: sessionKey)
    }

    private func restoreSession() {
        guard let email = UserDefaults.standard.string(forKey: sessionKey) else { return }
        currentUser = loadUsers()[email]
    }

    // MARK: - Validation

    private func validateSignUp(name: String, email: String, password: String, confirm: String) -> String? {
        if name.isEmpty { return "Enter your name." }
        if !isValidEmail(email) { return "Enter a valid email address." }
        if password.count < 6 { return "Password must be at least 6 characters." }
        if password != confirm { return "Passwords don't match." }
        return nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func normalized(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Storage

    private func hash(_ password: String, salt: String) -> String {
        let digest = SHA256.hash(data: Data((salt + password).utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func loadUsers() -> [String: AppUser] {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([String: AppUser].self, from: data)
        else { return [:] }
        return users
    }

    private func saveUsers(_ users: [String: AppUser]) {
        guard let data = try? JSONEncoder().encode(users) else { return }
        UserDefaults.standard.set(data, forKey: usersKey)
    }
}

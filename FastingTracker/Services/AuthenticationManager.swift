import Foundation
import LocalAuthentication

@Observable
final class AuthenticationManager {
    var isAuthenticated = false
    var isAuthenticationAvailable = false
    var authError: String?

    private let context = LAContext()

    init() {
        checkAvailability()
    }

    func checkAvailability() {
        var error: NSError?
        isAuthenticationAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    func authenticate() async -> Bool {
        let context = LAContext()
        context.localizedReason = "Authenticate to access your fasting profile"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Fall back to device passcode
            return await authenticateWithPasscode()
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock your fasting profile"
            )
            await MainActor.run {
                isAuthenticated = success
                authError = nil
            }
            return success
        } catch {
            await MainActor.run {
                authError = error.localizedDescription
                isAuthenticated = false
            }
            return false
        }
    }

    private func authenticateWithPasscode() async -> Bool {
        let context = LAContext()
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Unlock your fasting profile"
            )
            await MainActor.run {
                isAuthenticated = success
            }
            return success
        } catch {
            await MainActor.run {
                authError = error.localizedDescription
                isAuthenticated = false
            }
            return false
        }
    }

    func lock() {
        isAuthenticated = false
    }

    var biometricType: String {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .opticID: return "Optic ID"
        @unknown default: return "Biometrics"
        }
    }
}

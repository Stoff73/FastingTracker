import Foundation
import LocalAuthentication
import Observation

@Observable
final class AuthenticationManager {
    var isAuthenticated = false
    var isAuthenticationAvailable = false
    var authError: String?

    init() {
        checkAvailability()
    }

    func checkAvailability() {
        var error: NSError?
        isAuthenticationAvailable = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
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
                localizedReason: "Access your fasting profile"
            )
            
            await MainActor.run {
                if success {
                    isAuthenticated = true
                    authError = nil
                } else {
                    authError = "Authentication failed"
                }
            }
            
            return success
        } catch let error as LAError {
            await MainActor.run {
                switch error.code {
                case .userCancel:
                    authError = "Authentication cancelled"
                case .userFallback:
                    authError = "Passcode requested"
                case .biometryNotAvailable:
                    authError = "Biometry not available"
                case .biometryNotEnrolled:
                    authError = "Biometry not set up"
                case .biometryLockout:
                    authError = "Too many failed attempts"
                default:
                    authError = "Authentication error: \(error.localizedDescription)"
                }
            }
            return false
        } catch {
            await MainActor.run {
                authError = error.localizedDescription
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
        case .none: return "Passcode"
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .opticID: return "Optic ID"
        @unknown default: return "Biometrics"
        }
    }
}

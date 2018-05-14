import Foundation

public enum Constants {
  public static func bundle() -> String {
    return "solutions.canarin.iCab"
  }

  public enum General: Int {
    case name, age, avatar, registration

    public func key() -> String {
      switch self {
      case .name:
        return "NAME"
      case .age:
        return "AGE"
      case .avatar:
        return "AVATAR"
      case .registration:
        return "REGISTRATION"
      }
    }
  }
}

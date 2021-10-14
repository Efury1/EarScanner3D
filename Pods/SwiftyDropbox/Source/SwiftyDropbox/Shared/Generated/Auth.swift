///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

import Foundation

/// Datatypes and serializers for the auth namespace
open class Auth {
    /// Error occurred because the account doesn't have permission to access the resource.
    public enum AccessError: CustomStringConvertible {
        /// Current account type cannot access the resource.
        case invalidAccountType(Auth.InvalidAccountTypeError)
        /// Current account cannot access Paper.
        case paperAccessDenied(Auth.PaperAccessError)
        /// An unspecified error.
        case other

        public var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(AccessErrorSerializer().serialize(self)))"
        }
    }
    open class AccessErrorSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: AccessError) -> JSON {
            switch value {
                case .invalidAccountType(let arg):
                    var d = ["invalid_account_type": Auth.InvalidAccountTypeErrorSerializer().serialize(arg)]
                    d[".tag"] = .str("invalid_account_type")
                    return .dictionary(d)
                case .paperAccessDenied(let arg):
                    var d = ["paper_access_denied": Auth.PaperAccessErrorSerializer().serialize(arg)]
                    d[".tag"] = .str("paper_access_denied")
                    return .dictionary(d)
                case .other:
                    var d = [String: JSON]()
                    d[".tag"] = .str("other")
                    return .dictionary(d)
            }
        }
        open func deserialize(_ json: JSON) -> AccessError {
            switch json {
                case .dictionary(let d):
                    let tag = Serialization.getTag(d)
                    switch tag {
                        case "invalid_account_type":
                            let v = Auth.InvalidAccountTypeErrorSerializer().deserialize(d["invalid_account_type"] ?? .null)
                            return AccessError.invalidAccountType(v)
                        case "paper_access_denied":
                            let v = Auth.PaperAccessErrorSerializer().deserialize(d["paper_access_denied"] ?? .null)
                            return AccessError.paperAccessDenied(v)
                        case "other":
                            return AccessError.other
                        default:
                            return AccessError.other
                    }
                default:
                    fatalError("Failed to deserialize")
            }
        }
    }

    /// Errors occurred during authentication.
    public enum AuthError: CustomStringConvertible {
        /// The access token is invalid.
        case invalidAccessToken
        /// The user specified in 'Dropbox-API-Select-User' is no longer on the team.
        case invalidSelectUser
        /// The user specified in 'Dropbox-API-Select-Admin' is not a Dropbox Business team admin.
        case invalidSelectAdmin
        /// The user has been suspended.
        case userSuspended
        /// The access token has expired.
        case expiredAccessToken
        /// The access token does not have the required scope to access the route.
        case missingScope(Auth.TokenScopeError)
        /// The route is not available to public.
        case routeAccessDenied
        /// An unspecified error.
        case other

        public var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(AuthErrorSerializer().serialize(self)))"
        }
    }
    open class AuthErrorSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: AuthError) -> JSON {
            switch value {
                case .invalidAccessToken:
                    var d = [String: JSON]()
                    d[".tag"] = .str("invalid_access_token")
                    return .dictionary(d)
                case .invalidSelectUser:
                    var d = [String: JSON]()
                    d[".tag"] = .str("invalid_select_user")
                    return .dictionary(d)
                case .invalidSelectAdmin:
                    var d = [String: JSON]()
                    d[".tag"] = .str("invalid_select_admin")
                    return .dictionary(d)
                case .userSuspended:
                    var d = [String: JSON]()
                    d[".tag"] = .str("user_suspended")
                    return .dictionary(d)
                case .expiredAccessToken:
                    var d = [String: JSON]()
                    d[".tag"] = .str("expired_access_token")
                    return .dictionary(d)
                case .missingScope(let arg):
                    var d = Serialization.getFields(Auth.TokenScopeErrorSerializer().serialize(arg))
                    d[".tag"] = .str("missing_scope")
                    return .dictionary(d)
                case .routeAccessDenied:
                    var d = [String: JSON]()
                    d[".tag"] = .str("route_access_denied")
                    return .dictionary(d)
                case .other:
                    var d = [String: JSON]()
                    d[".tag"] = .str("other")
                    return .dictionary(d)
            }
        }
        open func deserialize(_ json: JSON) -> AuthError {
            switch json {
                case .dictionary(let d):
                    let tag = Serialization.getTag(d)
                    switch tag {
                        case "invalid_access_token":
                            return AuthError.invalidAccessToken
                        case "invalid_select_user":
                            return AuthError.invalidSelectUser
                        case "invalid_select_admin":
                            return AuthError.invalidSelectAdmin
                        case "user_suspended":
                            return AuthError.userSuspended
                        case "expired_access_token":
                            return AuthError.expiredAccessToken
                        case "missing_scope":
                            let v = Auth.TokenScopeErrorSerializer().deserialize(json)
                            return AuthError.missingScope(v)
                        case "route_access_denied":
                            return AuthError.routeAccessDenied
                        case "other":
                            return AuthError.other
                        default:
                            return AuthError.other
                    }
                default:
                    fatalError("Failed to deserialize")
            }
        }
    }

    /// The InvalidAccountTypeError union
    public enum InvalidAccountTypeError: CustomStringConvertible {
        /// Current account type doesn't have permission to access this route endpoint.
        case endpoint
        /// Current account type doesn't have permission to access this feature.
        case feature
        /// An unspecified error.
        case other

        public var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(InvalidAccountTypeErrorSerializer().serialize(self)))"
        }
    }
    open class InvalidAccountTypeErrorSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: InvalidAccountTypeError) -> JSON {
            switch value {
                case .endpoint:
                    var d = [String: JSON]()
                    d[".tag"] = .str("endpoint")
                    return .dictionary(d)
                case .feature:
                    var d = [String: JSON]()
                    d[".tag"] = .str("feature")
                    return .dictionary(d)
                case .other:
                    var d = [String: JSON]()
                    d[".tag"] = .str("other")
                    return .dictionary(d)
            }
        }
        open func deserialize(_ json: JSON) -> InvalidAccountTypeError {
            switch json {
                case .dictionary(let d):
                    let tag = Serialization.getTag(d)
                    switch tag {
                        case "endpoint":
                            return InvalidAccountTypeError.endpoint
                        case "feature":
                            return InvalidAccountTypeError.feature
                        case "other":
                            return InvalidAccountTypeError.other
                        default:
                            return InvalidAccountTypeError.other
                    }
                default:
                    fatalError("Failed to deserialize")
            }
        }
    }

    /// The PaperAccessError union
    public enum PaperAccessError: CustomStringConvertible {
        /// Paper is disabled.
        case paperDisabled
        /// The provided user has not used Paper yet.
        case notPaperUser
        /// An unspecified error.
        case other

        public var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(PaperAccessErrorSerializer().serialize(self)))"
        }
    }
    open class PaperAccessErrorSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: PaperAccessError) -> JSON {
            switch value {
                case .paperDisabled:
                    var d = [String: JSON]()
                    d[".tag"] = .str("paper_disabled")
                    return .dictionary(d)
                case .notPaperUser:
                    var d = [String: JSON]()
                    d[".tag"] = .str("not_paper_user")
                    return .dictionary(d)
                case .other:
                    var d = [String: JSON]()
                    d[".tag"] = .str("other")
                    return .dictionary(d)
            }
        }
        open func deserialize(_ json: JSON) -> PaperAccessError {
            switch json {
                case .dictionary(let d):
                    let tag = Serialization.getTag(d)
                    switch tag {
                        case "paper_disabled":
                            return PaperAccessError.paperDisabled
                        case "not_paper_user":
                            return PaperAccessError.notPaperUser
                        case "other":
                            return PaperAccessError.other
                        default:
                            return PaperAccessError.other
                    }
                default:
                    fatalError("Failed to deserialize")
            }
        }
    }

    /// Error occurred because the app is being rate limited.
    open class RateLimitError: CustomStringConvertible {
        /// The reason why the app is being rate limited.
        public let reason: Auth.RateLimitReason
        /// The number of seconds that the app should wait before making another request.
        public let retryAfter: UInt64
        public init(reason: Auth.RateLimitReason, retryAfter: UInt64 = 1) {
            self.reason = reason
            comparableValidator()(retryAfter)
            self.retryAfter = retryAfter
        }
        open var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(RateLimitErrorSerializer().serialize(self)))"
        }
    }
    open class RateLimitErrorSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: RateLimitError) -> JSON {
            let output = [ 
            "reason": Auth.RateLimitReasonSerializer().serialize(value.reason),
            "retry_after": Serialization._UInt64Serializer.serialize(value.retryAfter),
            ]
            return .dictionary(output)
        }
        open func deserialize(_ json: JSON) -> RateLimitError {
            switch json {
                case .dictionary(let dict):
                    let reason = Auth.RateLimitReasonSerializer().deserialize(dict["reason"] ?? .null)
                    let retryAfter = Serialization._UInt64Serializer.deserialize(dict["retry_after"] ?? .number(1))
                    return RateLimitError(reason: reason, retryAfter: retryAfter)
                default:
                    fatalError("Type error deserializing")
            }
        }
    }

    /// The RateLimitReason union
    public enum RateLimitReason: CustomStringConvertible {
        /// You are making too many requests in the past few minutes.
        case tooManyRequests
        /// There are currently too many write operations happening in the user's Dropbox.
        case tooManyWriteOperations
        /// An unspecified error.
        case other

        public var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(RateLimitReasonSerializer().serialize(self)))"
        }
    }
    open class RateLimitReasonSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: RateLimitReason) -> JSON {
            switch value {
                case .tooManyRequests:
                    var d = [String: JSON]()
                    d[".tag"] = .str("too_many_requests")
                    return .dictionary(d)
                case .tooManyWriteOperations:
                    var d = [String: JSON]()
                    d[".tag"] = .str("too_many_write_operations")
                    return .dictionary(d)
                case .other:
                    var d = [String: JSON]()
                    d[".tag"] = .str("other")
                    return .dictionary(d)
            }
        }
        open func deserialize(_ json: JSON) -> RateLimitReason {
            switch json {
                case .dictionary(let d):
                    let tag = Serialization.getTag(d)
                    switch tag {
                        case "too_many_requests":
                            return RateLimitReason.tooManyRequests
                        case "too_many_write_operations":
                            return RateLimitReason.tooManyWriteOperations
                        case "other":
                            return RateLimitReason.other
                        default:
                            return RateLimitReason.other
                    }
                default:
                    fatalError("Failed to deserialize")
            }
        }
    }

    /// The TokenFromOAuth1Arg struct
    open class TokenFromOAuth1Arg: CustomStringConvertible {
        /// The supplied OAuth 1.0 access token.
        public let oauth1Token: String
        /// The token secret associated with the supplied access token.
        public let oauth1TokenSecret: String
        public init(oauth1Token: String, oauth1TokenSecret: String) {
            stringValidator(minLength: 1)(oauth1Token)
            self.oauth1Token = oauth1Token
            stringValidator(minLength: 1)(oauth1TokenSecret)
            self.oauth1TokenSecret = oauth1TokenSecret
        }
        open var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(TokenFromOAuth1ArgSerializer().serialize(self)))"
        }
    }
    open class TokenFromOAuth1ArgSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: TokenFromOAuth1Arg) -> JSON {
            let output = [ 
            "oauth1_token": Serialization._StringSerializer.serialize(value.oauth1Token),
            "oauth1_token_secret": Serialization._StringSerializer.serialize(value.oauth1TokenSecret),
            ]
            return .dictionary(output)
        }
        open func deserialize(_ json: JSON) -> TokenFromOAuth1Arg {
            switch json {
                case .dictionary(let dict):
                    let oauth1Token = Serialization._StringSerializer.deserialize(dict["oauth1_token"] ?? .null)
                    let oauth1TokenSecret = Serialization._StringSerializer.deserialize(dict["oauth1_token_secret"] ?? .null)
                    return TokenFromOAuth1Arg(oauth1Token: oauth1Token, oauth1TokenSecret: oauth1TokenSecret)
                default:
                    fatalError("Type error deserializing")
            }
        }
    }

    /// The TokenFromOAuth1Error union
    public enum TokenFromOAuth1Error: CustomStringConvertible {
        /// Part or all of the OAuth 1.0 access token info is invalid.
        case invalidOauth1TokenInfo
        /// The authorized app does not match the app associated with the supplied access token.
        case appIdMismatch
        /// An unspecified error.
        case other

        public var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(TokenFromOAuth1ErrorSerializer().serialize(self)))"
        }
    }
    open class TokenFromOAuth1ErrorSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: TokenFromOAuth1Error) -> JSON {
            switch value {
                case .invalidOauth1TokenInfo:
                    var d = [String: JSON]()
                    d[".tag"] = .str("invalid_oauth1_token_info")
                    return .dictionary(d)
                case .appIdMismatch:
                    var d = [String: JSON]()
                    d[".tag"] = .str("app_id_mismatch")
                    return .dictionary(d)
                case .other:
                    var d = [String: JSON]()
                    d[".tag"] = .str("other")
                    return .dictionary(d)
            }
        }
        open func deserialize(_ json: JSON) -> TokenFromOAuth1Error {
            switch json {
                case .dictionary(let d):
                    let tag = Serialization.getTag(d)
                    switch tag {
                        case "invalid_oauth1_token_info":
                            return TokenFromOAuth1Error.invalidOauth1TokenInfo
                        case "app_id_mismatch":
                            return TokenFromOAuth1Error.appIdMismatch
                        case "other":
                            return TokenFromOAuth1Error.other
                        default:
                            return TokenFromOAuth1Error.other
                    }
                default:
                    fatalError("Failed to deserialize")
            }
        }
    }

    /// The TokenFromOAuth1Result struct
    open class TokenFromOAuth1Result: CustomStringConvertible {
        /// The OAuth 2.0 token generated from the supplied OAuth 1.0 token.
        public let oauth2Token: String
        public init(oauth2Token: String) {
            stringValidator(minLength: 1)(oauth2Token)
            self.oauth2Token = oauth2Token
        }
        open var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(TokenFromOAuth1ResultSerializer().serialize(self)))"
        }
    }
    open class TokenFromOAuth1ResultSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: TokenFromOAuth1Result) -> JSON {
            let output = [ 
            "oauth2_token": Serialization._StringSerializer.serialize(value.oauth2Token),
            ]
            return .dictionary(output)
        }
        open func deserialize(_ json: JSON) -> TokenFromOAuth1Result {
            switch json {
                case .dictionary(let dict):
                    let oauth2Token = Serialization._StringSerializer.deserialize(dict["oauth2_token"] ?? .null)
                    return TokenFromOAuth1Result(oauth2Token: oauth2Token)
                default:
                    fatalError("Type error deserializing")
            }
        }
    }

    /// The TokenScopeError struct
    open class TokenScopeError: CustomStringConvertible {
        /// The required scope to access the route.
        public let requiredScope: String
        public init(requiredScope: String) {
            stringValidator()(requiredScope)
            self.requiredScope = requiredScope
        }
        open var description: String {
            return "\(SerializeUtil.prepareJSONForSerialization(TokenScopeErrorSerializer().serialize(self)))"
        }
    }
    open class TokenScopeErrorSerializer: JSONSerializer {
        public init() { }
        open func serialize(_ value: TokenScopeError) -> JSON {
            let output = [ 
            "required_scope": Serialization._StringSerializer.serialize(value.requiredScope),
            ]
            return .dictionary(output)
        }
        open func deserialize(_ json: JSON) -> TokenScopeError {
            switch json {
                case .dictionary(let dict):
                    let requiredScope = Serialization._StringSerializer.deserialize(dict["required_scope"] ?? .null)
                    return TokenScopeError(requiredScope: requiredScope)
                default:
                    fatalError("Type error deserializing")
            }
        }
    }


    /// Stone Route Objects

    static let tokenFromOauth1 = Route(
        name: "token/from_oauth1",
        version: 1,
        namespace: "auth",
        deprecated: false,
        argSerializer: Auth.TokenFromOAuth1ArgSerializer(),
        responseSerializer: Auth.TokenFromOAuth1ResultSerializer(),
        errorSerializer: Auth.TokenFromOAuth1ErrorSerializer(),
        attrs: ["auth": "app",
                "host": "api",
                "style": "rpc"]
    )
    static let tokenRevoke = Route(
        name: "token/revoke",
        version: 1,
        namespace: "auth",
        deprecated: false,
        argSerializer: Serialization._VoidSerializer,
        responseSerializer: Serialization._VoidSerializer,
        errorSerializer: Serialization._VoidSerializer,
        attrs: ["auth": "user",
                "host": "api",
                "style": "rpc"]
    )
}

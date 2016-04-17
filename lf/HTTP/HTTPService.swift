import Foundation

// MARK: - HTTPVersion
enum HTTPVersion: String {
    case Unkown    = "UNKOWN"
    case Version10 = "HTTP/1.0"
    case Version11 = "HTTP/1.1"
}

// MARK: CustomStringConvertible
extension HTTPVersion: CustomStringConvertible {
    var description:String {
        return rawValue
    }
}

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case UNKOWN  = "UNKOWN"
    case GET     = "GET"
    case POST    = "POST"
    case PUT     = "PUT"
    case DELETE  = "DELETE"
    case HEAD    = "HEAD"
    case OPTIONS = "OPTIONS"
    case TRACE   = "TRACE"
    case CONNECT = "CONNECT"
}

// MARK: - HTTPStatusCode
enum HTTPStatusCode: Int {
    case Continue                     = 100
    case SwitchingProtocols           = 101
    case OK                           = 200
    case Created                      = 201
    case Accepted                     = 202
    case NonAuthoritative             = 203
    case NoContent                    = 204
    case ResetContent                 = 205
    case PartialContent               = 206
    case MultipleChoices              = 300
    case MovedParmanently             = 301
    case Found                        = 302
    case SeeOther                     = 303
    case NotModified                  = 304
    case UseProxy                     = 305
    case TemporaryRedirect	          = 307
    case BadRequest                   = 400
    case Unauthorixed                 = 401
    case PaymentRequired              = 402
    case Forbidden                    = 403
    case NotFound                     = 404
    case MethodNotAllowed             = 405
    case NotAcceptable                = 406
    case ProxyAuthenticationRequired  = 407
    case RequestTimeOut               = 408
    case Conflict                     = 409
    case Gone                         = 410
    case LengthRequired               = 411
    case PreconditionFailed	          = 412
    case RequestEntityTooLarge        = 413
    case RequestURITooLarge           = 414
    case UnsupportedMediaType         = 415
    case RequestedRangeNotSatisfiable = 416
    case ExpectationFailed            = 417
    case InternalServerError          = 500
    case NotImplemented               = 501
    case BadGateway                   = 502
    case ServiceUnavailable           = 503
    case GatewayTimeOut               = 504
    case HTTPVersionNotSupported      = 505

    var message:String {
        switch self {
        case Continue:
            return "Continue"
        case SwitchingProtocols:
            return "Switching Protocols"
        case OK:
            return "OK"
        case Created:
            return "Created"
        case Accepted:
            return "Accepted"
        case NonAuthoritative:
            return "Non-Authoritative Information"
        case NoContent:
            return "No Content"
        case ResetContent:
            return "Reset Content"
        case PartialContent:
            return "Partial Content"
        case MultipleChoices:
            return "Multiple Choices"
        case MovedParmanently:
            return "Moved Permanently"
        case Found:
            return "Found"
        case SeeOther:
            return "See Other"
        case NotModified:
            return "Not Modified"
        case UseProxy:
            return "Use Proxy"
        case TemporaryRedirect:
            return "Temporary Redirect"
        case BadRequest:
            return "Bad Request"
        case Unauthorixed:
            return "Unauthorixed"
        case PaymentRequired:
            return "Payment Required"
        case Forbidden:
            return "Forbidden"
        case NotFound:
            return "Not Found"
        case MethodNotAllowed:
            return "Method Not Allowed"
        case NotAcceptable:
            return "Not"
        case ProxyAuthenticationRequired:
            return "Proxy Authentication Required"
        case RequestTimeOut:
            return "Request Time-out"
        case Conflict:
            return "Conflict"
        case Gone:
            return "Gone"
        case LengthRequired:
            return "Length Required"
        case PreconditionFailed:
            return "Precondition Failed"
        case RequestEntityTooLarge:
            return "Request Entity Too Large"
        case RequestURITooLarge:
            return "Request-URI Too Large"
        case UnsupportedMediaType:
            return "Unsupported Media Type"
        case RequestedRangeNotSatisfiable:
            return "Requested range not satisfiable"
        case ExpectationFailed:
            return "Expectation Failed"
        case InternalServerError:
            return "Internal Server Error"
        case NotImplemented:
            return "Not Implemented"
        case BadGateway:
            return "Bad Gateway"
        case ServiceUnavailable:
            return "Service Unavailable"
        case GatewayTimeOut:
            return "Gateway Time-out"
        case HTTPVersionNotSupported:
            return "HTTP Version not supported"
        }
    }
}

// MARK: CustomStringConvertible
extension HTTPStatusCode: CustomStringConvertible {
    var description:String {
        return "\(rawValue) \(message)"
    }
}

// MARK: - HTTPService
class HTTPService: NetService {
    static let type:String = "_http._tcp"
    static let defaultPort:Int = 8080
    static let defaultDocument:String = "<!DOCTYPE html><html><head><meta charset=\"UTF-8\" /><title>lf</title></head><body></body></html>"
    private(set) var streams:[String: HTTPStream] = [:]

    func client(inputBuffer client:NetClient) {
        guard let request:HTTPRequest = HTTPRequest(bytes: client.inputBuffer) else {
            return
        }
        client.inputBuffer.removeAll()
        switch request.method {
        case .GET:
            get(request, client: client)
        default:
            break
        }
    }

    func get(request:HTTPRequest, client:NetClient) {
        switch request.uri {
        case "/":
            var response:HTTPResponse = HTTPResponse()
            response.headerFields["Content-Type"] = "text/html"
            response.headerFields["Connection"] = "close"
            response.body = [UInt8](HTTPService.defaultDocument.utf8)
            client.doWrite(response.bytes)
            client.disconnect()
        default:
            var response:HTTPResponse = HTTPResponse()
            response.statusCode = .NotFound
            response.headerFields["Connection"] = "close"
            client.doWrite(response.bytes)
            client.disconnect()
            break
        }
    }
}


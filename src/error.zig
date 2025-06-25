const std = @import("std");

/// HTTP Error types covering all standard HTTP status codes
pub const HttpError = error{
    // 1xx Informational (rarely treated as errors, but included for completeness)
    Continue,
    SwitchingProtocols,
    Processing,
    EarlyHints,

    // 3xx Redirection (sometimes treated as errors depending on context)
    MultipleChoices,
    MovedPermanently,
    Found,
    SeeOther,
    NotModified,
    UseProxy,
    TemporaryRedirect,
    PermanentRedirect,

    // 4xx Client Errors
    BadRequest,
    Unauthorized,
    PaymentRequired,
    Forbidden,
    NotFound,
    MethodNotAllowed,
    NotAcceptable,
    ProxyAuthenticationRequired,
    RequestTimeout,
    Conflict,
    Gone,
    LengthRequired,
    PreconditionFailed,
    PayloadTooLarge,
    UriTooLong,
    UnsupportedMediaType,
    RangeNotSatisfiable,
    ExpectationFailed,
    ImATeapot,
    MisdirectedRequest,
    UnprocessableEntity,
    Locked,
    FailedDependency,
    TooEarly,
    UpgradeRequired,
    PreconditionRequired,
    TooManyRequests,
    RequestHeaderFieldsTooLarge,
    UnavailableForLegalReasons,

    // 5xx Server Errors
    InternalServerError,
    NotImplemented,
    BadGateway,
    ServiceUnavailable,
    GatewayTimeout,
    HttpVersionNotSupported,
    VariantAlsoNegotiates,
    InsufficientStorage,
    LoopDetected,
    NotExtended,
    NetworkAuthenticationRequired,

    // Network/Connection Errors (not HTTP status codes but common HTTP client errors)
    NetworkError,
    ConnectionRefused,
    ConnectionTimeout,
    DnsResolutionFailed,
    SslError,
    InvalidUrl,
    RedirectLoop,
};

/// Convert HTTP status code to corresponding error
pub fn statusCodeToError(status_code: u16) HttpError {
    return switch (status_code) {
        // 1xx Informational
        100 => HttpError.Continue,
        101 => HttpError.SwitchingProtocols,
        102 => HttpError.Processing,
        103 => HttpError.EarlyHints,

        // 3xx Redirection
        300 => HttpError.MultipleChoices,
        301 => HttpError.MovedPermanently,
        302 => HttpError.Found,
        303 => HttpError.SeeOther,
        304 => HttpError.NotModified,
        305 => HttpError.UseProxy,
        307 => HttpError.TemporaryRedirect,
        308 => HttpError.PermanentRedirect,

        // 4xx Client Errors
        400 => HttpError.BadRequest,
        401 => HttpError.Unauthorized,
        402 => HttpError.PaymentRequired,
        403 => HttpError.Forbidden,
        404 => HttpError.NotFound,
        405 => HttpError.MethodNotAllowed,
        406 => HttpError.NotAcceptable,
        407 => HttpError.ProxyAuthenticationRequired,
        408 => HttpError.RequestTimeout,
        409 => HttpError.Conflict,
        410 => HttpError.Gone,
        411 => HttpError.LengthRequired,
        412 => HttpError.PreconditionFailed,
        413 => HttpError.PayloadTooLarge,
        414 => HttpError.UriTooLong,
        415 => HttpError.UnsupportedMediaType,
        416 => HttpError.RangeNotSatisfiable,
        417 => HttpError.ExpectationFailed,
        418 => HttpError.ImATeapot,
        421 => HttpError.MisdirectedRequest,
        422 => HttpError.UnprocessableEntity,
        423 => HttpError.Locked,
        424 => HttpError.FailedDependency,
        425 => HttpError.TooEarly,
        426 => HttpError.UpgradeRequired,
        428 => HttpError.PreconditionRequired,
        429 => HttpError.TooManyRequests,
        431 => HttpError.RequestHeaderFieldsTooLarge,
        451 => HttpError.UnavailableForLegalReasons,

        // 5xx Server Errors
        500 => HttpError.InternalServerError,
        501 => HttpError.NotImplemented,
        502 => HttpError.BadGateway,
        503 => HttpError.ServiceUnavailable,
        504 => HttpError.GatewayTimeout,
        505 => HttpError.HttpVersionNotSupported,
        506 => HttpError.VariantAlsoNegotiates,
        507 => HttpError.InsufficientStorage,
        508 => HttpError.LoopDetected,
        510 => HttpError.NotExtended,
        511 => HttpError.NetworkAuthenticationRequired,

        // Default for unknown status codes
        else => HttpError.InternalServerError,
    };
}

/// Convert error back to status code (useful for servers)
pub fn errorToStatusCode(err: HttpError) u16 {
    return switch (err) {
        // 1xx Informational
        HttpError.Continue => 100,
        HttpError.SwitchingProtocols => 101,
        HttpError.Processing => 102,
        HttpError.EarlyHints => 103,

        // 3xx Redirection
        HttpError.MultipleChoices => 300,
        HttpError.MovedPermanently => 301,
        HttpError.Found => 302,
        HttpError.SeeOther => 303,
        HttpError.NotModified => 304,
        HttpError.UseProxy => 305,
        HttpError.TemporaryRedirect => 307,
        HttpError.PermanentRedirect => 308,

        // 4xx Client Errors
        HttpError.BadRequest => 400,
        HttpError.Unauthorized => 401,
        HttpError.PaymentRequired => 402,
        HttpError.Forbidden => 403,
        HttpError.NotFound => 404,
        HttpError.MethodNotAllowed => 405,
        HttpError.NotAcceptable => 406,
        HttpError.ProxyAuthenticationRequired => 407,
        HttpError.RequestTimeout => 408,
        HttpError.Conflict => 409,
        HttpError.Gone => 410,
        HttpError.LengthRequired => 411,
        HttpError.PreconditionFailed => 412,
        HttpError.PayloadTooLarge => 413,
        HttpError.UriTooLong => 414,
        HttpError.UnsupportedMediaType => 415,
        HttpError.RangeNotSatisfiable => 416,
        HttpError.ExpectationFailed => 417,
        HttpError.ImATeapot => 418,
        HttpError.MisdirectedRequest => 421,
        HttpError.UnprocessableEntity => 422,
        HttpError.Locked => 423,
        HttpError.FailedDependency => 424,
        HttpError.TooEarly => 425,
        HttpError.UpgradeRequired => 426,
        HttpError.PreconditionRequired => 428,
        HttpError.TooManyRequests => 429,
        HttpError.RequestHeaderFieldsTooLarge => 431,
        HttpError.UnavailableForLegalReasons => 451,

        // 5xx Server Errors
        HttpError.InternalServerError => 500,
        HttpError.NotImplemented => 501,
        HttpError.BadGateway => 502,
        HttpError.ServiceUnavailable => 503,
        HttpError.GatewayTimeout => 504,
        HttpError.HttpVersionNotSupported => 505,
        HttpError.VariantAlsoNegotiates => 506,
        HttpError.InsufficientStorage => 507,
        HttpError.LoopDetected => 508,
        HttpError.NotExtended => 510,
        HttpError.NetworkAuthenticationRequired => 511,

        // Network errors don't have status codes
        HttpError.NetworkError => 0,
        HttpError.ConnectionRefused => 0,
        HttpError.ConnectionTimeout => 0,
        HttpError.DnsResolutionFailed => 0,
        HttpError.SslError => 0,
        HttpError.InvalidUrl => 0,
        HttpError.RedirectLoop => 0,
    };
}

/// Get human-readable description of HTTP error
pub fn errorDescription(err: HttpError) []const u8 {
    return switch (err) {
        // 1xx Informational
        HttpError.Continue => "Continue",
        HttpError.SwitchingProtocols => "Switching Protocols",
        HttpError.Processing => "Processing",
        HttpError.EarlyHints => "Early Hints",

        // 3xx Redirection
        HttpError.MultipleChoices => "Multiple Choices",
        HttpError.MovedPermanently => "Moved Permanently",
        HttpError.Found => "Found",
        HttpError.SeeOther => "See Other",
        HttpError.NotModified => "Not Modified",
        HttpError.UseProxy => "Use Proxy",
        HttpError.TemporaryRedirect => "Temporary Redirect",
        HttpError.PermanentRedirect => "Permanent Redirect",

        // 4xx Client Errors
        HttpError.BadRequest => "Bad Request",
        HttpError.Unauthorized => "Unauthorized",
        HttpError.PaymentRequired => "Payment Required",
        HttpError.Forbidden => "Forbidden",
        HttpError.NotFound => "Not Found",
        HttpError.MethodNotAllowed => "Method Not Allowed",
        HttpError.NotAcceptable => "Not Acceptable",
        HttpError.ProxyAuthenticationRequired => "Proxy Authentication Required",
        HttpError.RequestTimeout => "Request Timeout",
        HttpError.Conflict => "Conflict",
        HttpError.Gone => "Gone",
        HttpError.LengthRequired => "Length Required",
        HttpError.PreconditionFailed => "Precondition Failed",
        HttpError.PayloadTooLarge => "Payload Too Large",
        HttpError.UriTooLong => "URI Too Long",
        HttpError.UnsupportedMediaType => "Unsupported Media Type",
        HttpError.RangeNotSatisfiable => "Range Not Satisfiable",
        HttpError.ExpectationFailed => "Expectation Failed",
        HttpError.ImATeapot => "I'm a teapot",
        HttpError.MisdirectedRequest => "Misdirected Request",
        HttpError.UnprocessableEntity => "Unprocessable Entity",
        HttpError.Locked => "Locked",
        HttpError.FailedDependency => "Failed Dependency",
        HttpError.TooEarly => "Too Early",
        HttpError.UpgradeRequired => "Upgrade Required",
        HttpError.PreconditionRequired => "Precondition Required",
        HttpError.TooManyRequests => "Too Many Requests",
        HttpError.RequestHeaderFieldsTooLarge => "Request Header Fields Too Large",
        HttpError.UnavailableForLegalReasons => "Unavailable For Legal Reasons",

        // 5xx Server Errors
        HttpError.InternalServerError => "Internal Server Error",
        HttpError.NotImplemented => "Not Implemented",
        HttpError.BadGateway => "Bad Gateway",
        HttpError.ServiceUnavailable => "Service Unavailable",
        HttpError.GatewayTimeout => "Gateway Timeout",
        HttpError.HttpVersionNotSupported => "HTTP Version Not Supported",
        HttpError.VariantAlsoNegotiates => "Variant Also Negotiates",
        HttpError.InsufficientStorage => "Insufficient Storage",
        HttpError.LoopDetected => "Loop Detected",
        HttpError.NotExtended => "Not Extended",
        HttpError.NetworkAuthenticationRequired => "Network Authentication Required",

        // Network errors
        HttpError.NetworkError => "Network Error",
        HttpError.ConnectionRefused => "Connection Refused",
        HttpError.ConnectionTimeout => "Connection Timeout",
        HttpError.DnsResolutionFailed => "DNS Resolution Failed",
        HttpError.SslError => "SSL Error",
        HttpError.InvalidUrl => "Invalid URL",
        HttpError.RedirectLoop => "Redirect Loop",
    };
}

/// Check if error represents a client error (4xx)
pub fn isClientError(err: HttpError) bool {
    const status_code = errorToStatusCode(err);
    return status_code >= 400 and status_code < 500;
}

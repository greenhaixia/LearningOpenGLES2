import Foundation

/// A type-erased error which wraps an arbitrary error instance. This should be
/// useful for generic contexts.
public struct AnyError: Swift.Error {
	/// The underlying error.
	public let error: Swift.Error

	public init(_ error: Swift.Error) {
		if let anyError = error as? AnyError {
			self = anyError
		} else {
			self.error = error
		}
	}
}

extension AnyError: ErrorConvertible {
	public static func error(from error: Error) -> AnyError {
		return AnyError(error)
	}
}

extension AnyError: CustomStringConvertible {
	public var description: String {
		return String(describing: error)
	}
}

extension AnyError: LocalizedError {
	public var errorDescription: String? {
		#if !(swift(>=4.0) || os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
			// This workaround below is not needed for Swift 4.0 thanks to
			// https://github.com/apple/swift-corelibs-foundation/pull/967.
			if let nsError = error as? NSError {
				return nsError.localizedDescription
			}
		#endif
		return error.localizedDescription
	}

	public var failureReason: String? {
		return (error as? LocalizedError)?.failureReason
	}

	public var helpAnchor: String? {
		return (error as? LocalizedError)?.helpAnchor
	}

	public var recoverySuggestion: String? {
		return (error as? LocalizedError)?.recoverySuggestion
	}
}

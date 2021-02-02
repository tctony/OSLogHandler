//
//  OSLogHandler.swift
//  OSLogHandler
//
//  Created by Tony Tang on 2021/01/02.
//

import Foundation
import struct Logging.Logger
import protocol Logging.LogHandler
import LogFormatter
import os

public struct OSLogHandler: LogHandler {

    public var logLevel: Logger.Level = .info

    public var formatter: LogFormatter

    public let label: String

    private let oslogger: OSLog

    public init(label: String,
                category: String = "",
                formatter: LogFormatter = LogDefaultFormatter()) {
        self.label = label
        self.formatter = formatter
        
        self.oslogger = OSLog(subsystem: label, category: category)
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata extraMetadata: Logger.Metadata?,
                    file: String,
                    function: String,
                    line: UInt) {
        let mergedMetadata = extraMetadata == nil
            ? self.metadata
            : self.metadata.merging(extraMetadata!) { $1 }

        let formedMessage = self.formatter.format(level: level,
                                                  message: message,
                                                  metadata: mergedMetadata,
                                                  file: file,
                                                  function: function,
                                                  line: line)

        os_log("%{public}@", log: self.oslogger, type: OSLogType.from(loggerLevel: level), formedMessage)
    }

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }

    /// Add, remove, or change the logging metadata.
    /// - parameters:
    ///    - metadataKey: the key for the metadata item.
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        if metadata.isEmpty {
            return nil
        }
        return metadata.map {
            "\($0)=\($1)"
        }.joined(separator: " ")
    }
}

extension OSLogType {
    static func from(loggerLevel: Logger.Level) -> Self {
        switch loggerLevel {
        case .trace:
            /// `OSLog` doesn't have `trace`, so use `debug`
            return .debug
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            /// `OSLog` doesn't have `notice`, so use `info`
            return .info
        case .warning:
            /// `OSLog` doesn't have `warning`, so use `info`
            return .info
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
}

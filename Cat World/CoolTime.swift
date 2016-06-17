//
//  CoolTime.swift
//  Cat World
//
//  Created by Willis Allstead on 6/5/16.
//  Copyright © 2016 Willis Allstead. All rights reserved.
//

import Foundation

public protocol TimeIntervalLiterals
{
    /** Returns an `TimeInterval` representing the given number of
     seconds. */
    var seconds: TimeInterval { get }
    /** Returns an `TimeInterval` representing the given number of
     minutes. */
    var minutes: TimeInterval { get }
    /** Returns an `TimeInterval` representing the given number of
     hours. */
    var hours: TimeInterval { get }
    /** Returns an `TimeInterval` representing the given number of
     days. */
    var days: TimeInterval { get }
    /** Returns an `TimeInterval` representing the given number of
     weeks. */
    var weeks: TimeInterval { get }
}
extension TimeIntervalLiterals
{
    /** The default implementation of `minutes` returns `seconds * 60`. */
    public var minutes: TimeInterval {
        return seconds * 60
    }
    /** The default implementation of `hours` returns `minutes * 60`. */
    public var hours: TimeInterval {
        return minutes * 60
    }
    /** The default implementation of `days` returns `hours * 24`. */
    public var days: TimeInterval {
        return hours * 24
    }
    /** The default implementation of `weeks` returns `days * 7`. */
    public var weeks: TimeInterval {
        return days * 7
    }
}
extension TimeIntervalLiterals
{
    /** An alias for `seconds` designed for correct grammar where single
     units are used, eg. `1.second`. */
    public var second: TimeInterval {
        return seconds
    }
    /** An alias for `minutes` designed for correct grammar where single
     units are used, eg. `1.minute`. */
    public var minute: TimeInterval {
        return minutes
    }
    /** An alias for `hours` designed for correct grammar where single
     units are used, eg. `1.hour`. */
    public var hour: TimeInterval {
        return hours
    }
    /** An alias for `days` designed for correct grammar where single
     units are used, eg. `1.day`. */
    public var day: TimeInterval {
        return days
    }
    /** An alias for `weeks` designed for correct grammar where single
     units are used, eg. `1.week`. */
    public var week: TimeInterval {
        return weeks
    }
}
extension IntegerLiteralType: TimeIntervalLiterals
{
    /** Extends `IntegerLiteralType` to conform to the `TimeIntervalLiterals`
     protocol by implementing the `seconds` property. */
    public var seconds: TimeInterval {
        return TimeInterval(self)
    }
}
extension FloatLiteralType: TimeIntervalLiterals
{
    /** Extends `FloatLiteralType` to conform to the `TimeIntervalLiterals`
     protocol by implementing the `seconds` property. */
    public var seconds: TimeInterval {
        return TimeInterval(self)
    }
}

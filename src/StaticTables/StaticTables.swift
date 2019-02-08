//
// Copyright © 2019 Daniel Farrelly
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// *	Redistributions of source code must retain the above copyright notice, this list
//		of conditions and the following disclaimer.
// *	Redistributions in binary form must reproduce the above copyright notice, this
//		list of conditions and the following disclaimer in the documentation and/or
//		other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import Foundation

public let JSMStaticSelectOptionValue: JSMStaticSelectPreference.OptionKey = .value

public let JSMStaticSelectOptionLabel: JSMStaticSelectPreference.OptionKey = .label

public let JSMStaticSelectOptionImage: JSMStaticSelectPreference.OptionKey = .image

public extension JSMStaticSelectPreference {

	public enum OptionKey: String {
		case value = "JSMStaticSelectOptionValue"
		case label = "JSMStaticSelectOptionLabel"
		case image = "JSMStaticSelectOptionImage"
	}

	///	A collection of options for the preference.
	///
	///	Each option is defined as a `Dictionary` with up to three entries using the keys `.value`, `.label` and `.image`.
	/// The `.value` key is required, and represents the value of the option. The `.label` key is optional and must be an
	/// instance of `String`, which is used for the text label displayed to the user. The `.image` key is also optional,
	/// and should be either an `String` with the name of an image, or a `UIImage`, which is displayed as an icon on the
	///	left side of the option's cell.

	public var options: [[OptionKey: Any]] {
		get {
			return __options.map {
				var dictionary: [OptionKey: Any] = [:]

				for (key, value) in $0 {
					guard let optionKey = OptionKey(rawValue: key) else {
						continue
					}

					dictionary[optionKey] = value
				}

				return dictionary
			}
		}
		set {
			__options = newValue.map {
				var dictionary: [String: Any] = [:]

				for (key, value) in $0 {
					dictionary[key.rawValue] = value
				}

				return dictionary
			}
		}
	}

}

/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of CosmicMind nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Motion

public protocol Themeable {
  func apply(theme: Theme)
}

public struct Theme {
  /// The color displayed most frequently across the app.
  public var primary = Color.blue.base
  
  /// Accent color for some components such as FABMenu.
  public var secondary = Color.blue.base
  
  /// Background color for view controllers and some components.
  public var background = Color.white
  
  /// Background color for components such as cards, and dialogs.
  public var surface = Color.white
  
  /// Error color for components such as ErrorTextField.
  public var error = Color.red.base
  
  
  /// Text and iconography color to be used on primary color.
  public var onPrimary = Color.white
  
  /// Text and iconography color to be used on secondary color.
  public var onSecondary = Color.white
  
  /// Text and iconography color to be used on background color.
  public var onBackground = Color.black
  
  /// Text and iconography color to be used on surface color.
  public var onSurface = Color.black
  
  /// Text and iconography color to be used on error color.
  public var onError = Color.white
  
  /// An initializer.
  public init() { }
}

public extension Theme {
  /// Current theme for Material.
  static private(set) var current = Theme.light
  
  /// A light theme.
  static var light = Theme()
  
  /// A dark theme.
  static var dark: Theme = {
    var t = Theme()
    t.primary = UIColor(rgb: 0x202020)
    t.secondary = UIColor(rgb: 0x33776B)
    t.background = UIColor(rgb: 0x303030)
    t.onBackground = .white
    return t
  }()
}

public extension Theme {
  /**
   Applies theme to the entire app.
   - Parameter theme: A Theme.
   */
  static func apply(theme: Theme) {
    guard let v = Application.rootViewController else {
      return
    }
    
    current = theme
    apply(theme: theme, to: v)
  }
  
  /**
   Applies theme to the hierarchy of given view.
   - Parameter theme: A Theme.
   - Parameter to view: A UIView.
   */
  static func apply(theme: Theme, to view: UIView) {
    (view as? Themeable)?.apply(theme: theme)
    
    view.subviews.forEach {
      apply(theme: theme, to: $0)
    }
  }
  
  /**
   Applies theme to the hierarchy of given view controller.
   - Parameter theme: A Theme.
   - Parameter to viewController: A UIViewController.
   */
  static func apply(theme: Theme, to viewController: UIViewController) {
    apply(theme: theme, to: viewController.view)
    (viewController as? Themeable)?.apply(theme: theme)
    
    viewController.children.forEach {
      apply(theme: theme, to: $0)
    }
  }
  
  /**
   Applies provided theme for the components created within the given block
   without chaging app's theme.
   - Parameter theme: A Theme.
   - Parameter for block: A code block.
   */
  static func applying(theme: Theme, for execute: () -> Void) {
    let v = current
    current = theme
    execute()
    current = v
  }
}

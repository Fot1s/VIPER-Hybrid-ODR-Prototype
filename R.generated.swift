//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `react`.
    static let react = Rswift.FileResource(bundle: R.hostingBundle, name: "react", pathExtension: "")
    /// Resource file `slots`.
    static let slots = Rswift.FileResource(bundle: R.hostingBundle, name: "slots", pathExtension: "")
    
    /// `bundle.url(forResource: "react", withExtension: "")`
    static func react(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.react
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "slots", withExtension: "")`
    static func slots(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.slots
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 24 images.
  struct image {
    /// Image `card1`.
    static let card1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card1")
    /// Image `card2`.
    static let card2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card2")
    /// Image `card3`.
    static let card3 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card3")
    /// Image `card4`.
    static let card4 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card4")
    /// Image `card5`.
    static let card5 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card5")
    /// Image `card6`.
    static let card6 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card6")
    /// Image `card7`.
    static let card7 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card7")
    /// Image `card8`.
    static let card8 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card8")
    /// Image `card9`.
    static let card9 = Rswift.ImageResource(bundle: R.hostingBundle, name: "card9")
    /// Image `credits`.
    static let credits = Rswift.ImageResource(bundle: R.hostingBundle, name: "credits")
    /// Image `image-launch-screen`.
    static let imageLaunchScreen = Rswift.ImageResource(bundle: R.hostingBundle, name: "image-launch-screen")
    /// Image `image-placeholder`.
    static let imagePlaceholder = Rswift.ImageResource(bundle: R.hostingBundle, name: "image-placeholder")
    /// Image `intro-react-image`.
    static let introReactImage = Rswift.ImageResource(bundle: R.hostingBundle, name: "intro-react-image")
    /// Image `number0`.
    static let number0 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number0")
    /// Image `number1`.
    static let number1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number1")
    /// Image `number2`.
    static let number2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number2")
    /// Image `number3`.
    static let number3 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number3")
    /// Image `number4`.
    static let number4 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number4")
    /// Image `number5`.
    static let number5 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number5")
    /// Image `number6`.
    static let number6 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number6")
    /// Image `number7`.
    static let number7 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number7")
    /// Image `number8`.
    static let number8 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number8")
    /// Image `number9`.
    static let number9 = Rswift.ImageResource(bundle: R.hostingBundle, name: "number9")
    /// Image `spinButton`.
    static let spinButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "spinButton")
    
    /// `UIImage(named: "card1", bundle: ..., traitCollection: ...)`
    static func card1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card1, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card2", bundle: ..., traitCollection: ...)`
    static func card2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card2, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card3", bundle: ..., traitCollection: ...)`
    static func card3(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card3, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card4", bundle: ..., traitCollection: ...)`
    static func card4(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card4, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card5", bundle: ..., traitCollection: ...)`
    static func card5(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card5, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card6", bundle: ..., traitCollection: ...)`
    static func card6(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card6, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card7", bundle: ..., traitCollection: ...)`
    static func card7(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card7, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card8", bundle: ..., traitCollection: ...)`
    static func card8(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card8, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "card9", bundle: ..., traitCollection: ...)`
    static func card9(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.card9, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "credits", bundle: ..., traitCollection: ...)`
    static func credits(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.credits, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image-launch-screen", bundle: ..., traitCollection: ...)`
    static func imageLaunchScreen(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.imageLaunchScreen, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "image-placeholder", bundle: ..., traitCollection: ...)`
    static func imagePlaceholder(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.imagePlaceholder, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "intro-react-image", bundle: ..., traitCollection: ...)`
    static func introReactImage(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.introReactImage, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number0", bundle: ..., traitCollection: ...)`
    static func number0(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number0, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number1", bundle: ..., traitCollection: ...)`
    static func number1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number1, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number2", bundle: ..., traitCollection: ...)`
    static func number2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number2, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number3", bundle: ..., traitCollection: ...)`
    static func number3(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number3, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number4", bundle: ..., traitCollection: ...)`
    static func number4(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number4, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number5", bundle: ..., traitCollection: ...)`
    static func number5(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number5, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number6", bundle: ..., traitCollection: ...)`
    static func number6(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number6, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number7", bundle: ..., traitCollection: ...)`
    static func number7(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number7, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number8", bundle: ..., traitCollection: ...)`
    static func number8(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number8, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "number9", bundle: ..., traitCollection: ...)`
    static func number9(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.number9, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "spinButton", bundle: ..., traitCollection: ...)`
    static func spinButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.spinButton, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `ReactAppTableViewCell`.
    static let reactAppTableViewCell = _R.nib._ReactAppTableViewCell()
    /// Nib `SportsBookTableViewCell`.
    static let sportsBookTableViewCell = _R.nib._SportsBookTableViewCell()
    
    /// `UINib(name: "ReactAppTableViewCell", in: bundle)`
    static func reactAppTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.reactAppTableViewCell)
    }
    
    /// `UINib(name: "SportsBookTableViewCell", in: bundle)`
    static func sportsBookTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.sportsBookTableViewCell)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 0 reuse identifiers.
  struct reuseIdentifier {
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 6 storyboards.
  struct storyboard {
    /// Storyboard `HybridContentStoryboard`.
    static let hybridContentStoryboard = _R.storyboard.hybridContentStoryboard()
    /// Storyboard `IntroStoryboard`.
    static let introStoryboard = _R.storyboard.introStoryboard()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `ReactAppsStoryboard`.
    static let reactAppsStoryboard = _R.storyboard.reactAppsStoryboard()
    /// Storyboard `SlotsStoryboard`.
    static let slotsStoryboard = _R.storyboard.slotsStoryboard()
    /// Storyboard `SportsBookStoryboard`.
    static let sportsBookStoryboard = _R.storyboard.sportsBookStoryboard()
    
    /// `UIStoryboard(name: "HybridContentStoryboard", bundle: ...)`
    static func hybridContentStoryboard(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.hybridContentStoryboard)
    }
    
    /// `UIStoryboard(name: "IntroStoryboard", bundle: ...)`
    static func introStoryboard(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.introStoryboard)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "ReactAppsStoryboard", bundle: ...)`
    static func reactAppsStoryboard(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.reactAppsStoryboard)
    }
    
    /// `UIStoryboard(name: "SlotsStoryboard", bundle: ...)`
    static func slotsStoryboard(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.slotsStoryboard)
    }
    
    /// `UIStoryboard(name: "SportsBookStoryboard", bundle: ...)`
    static func sportsBookStoryboard(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.sportsBookStoryboard)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 2 localization tables.
  struct string {
    /// This `R.string.launchScreen` struct is generated, and contains static references to 1 localization keys.
    struct launchScreen {
      /// en translation: VIPER Hybrid Prototype
      /// 
      /// Locales: en, el, et
      static let jKgSEJltText = Rswift.StringResource(key: "JKg-SE-jlt.text", tableName: "LaunchScreen", bundle: R.hostingBundle, locales: ["en", "el", "et"], comment: nil)
      
      /// en translation: VIPER Hybrid Prototype
      /// 
      /// Locales: en, el, et
      static func jKgSEJltText(_: Void = ()) -> String {
        return NSLocalizedString("JKg-SE-jlt.text", tableName: "LaunchScreen", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    /// This `R.string.localizable` struct is generated, and contains static references to 4 localization keys.
    struct localizable {
      /// Base translation: Hybrid Content
      /// 
      /// Locales: en, Base, el
      static let hYBRID_CONTENT_NAVIGATION_BAR_TITLE = Rswift.StringResource(key: "HYBRID_CONTENT_NAVIGATION_BAR_TITLE", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "Base", "el"], comment: nil)
      /// Base translation: Intro
      /// 
      /// Locales: en, Base, el
      static let iNTRO_NAVIGATION_BAR_TITLE = Rswift.StringResource(key: "INTRO_NAVIGATION_BAR_TITLE", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "Base", "el"], comment: nil)
      /// Base translation: React Applications
      /// 
      /// Locales: en, Base, el
      static let rEACT_APPS_NAVIGATION_BAR_TITLE = Rswift.StringResource(key: "REACT_APPS_NAVIGATION_BAR_TITLE", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "Base", "el"], comment: nil)
      /// Base translation: Sportsbook
      /// 
      /// Locales: en, Base, el
      static let pLAYBOOK_NAVIGATION_BAR_TITLE = Rswift.StringResource(key: "PLAYBOOK_NAVIGATION_BAR_TITLE", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "Base", "el"], comment: nil)
      
      /// Base translation: Hybrid Content
      /// 
      /// Locales: en, Base, el
      static func hYBRID_CONTENT_NAVIGATION_BAR_TITLE(_: Void = ()) -> String {
        return NSLocalizedString("HYBRID_CONTENT_NAVIGATION_BAR_TITLE", bundle: R.hostingBundle, value: "Hybrid Content", comment: "")
      }
      
      /// Base translation: Intro
      /// 
      /// Locales: en, Base, el
      static func iNTRO_NAVIGATION_BAR_TITLE(_: Void = ()) -> String {
        return NSLocalizedString("INTRO_NAVIGATION_BAR_TITLE", bundle: R.hostingBundle, value: "Intro", comment: "")
      }
      
      /// Base translation: React Applications
      /// 
      /// Locales: en, Base, el
      static func rEACT_APPS_NAVIGATION_BAR_TITLE(_: Void = ()) -> String {
        return NSLocalizedString("REACT_APPS_NAVIGATION_BAR_TITLE", bundle: R.hostingBundle, value: "React Applications", comment: "")
      }
      
      /// Base translation: Sportsbook
      /// 
      /// Locales: en, Base, el
      static func pLAYBOOK_NAVIGATION_BAR_TITLE(_: Void = ()) -> String {
        return NSLocalizedString("PLAYBOOK_NAVIGATION_BAR_TITLE", bundle: R.hostingBundle, value: "Sportsbook", comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    struct _ReactAppTableViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "ReactAppTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> ReactAppTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ReactAppTableViewCell
      }
      
      fileprivate init() {}
    }
    
    struct _SportsBookTableViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "SportsBookTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> SportsBookTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? SportsBookTableViewCell
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
      try slotsStoryboard.validate()
      try introStoryboard.validate()
      try sportsBookStoryboard.validate()
      try hybridContentStoryboard.validate()
      try reactAppsStoryboard.validate()
    }
    
    struct hybridContentStoryboard: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let hybridContentViewController = StoryboardViewControllerResource<HybridContentViewController>(identifier: "HybridContentViewController")
      let name = "HybridContentStoryboard"
      
      func hybridContentViewController(_: Void = ()) -> HybridContentViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: hybridContentViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.hybridContentStoryboard().hybridContentViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'hybridContentViewController' could not be loaded from storyboard 'HybridContentStoryboard' as 'HybridContentViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct introStoryboard: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let introViewController = StoryboardViewControllerResource<IntroViewController>(identifier: "IntroViewController")
      let name = "IntroStoryboard"
      
      func introViewController(_: Void = ()) -> IntroViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: introViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "intro-react-image") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'intro-react-image' is used in storyboard 'IntroStoryboard', but couldn't be loaded.") }
        if _R.storyboard.introStoryboard().introViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'introViewController' could not be loaded from storyboard 'IntroStoryboard' as 'IntroViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if UIKit.UIImage(named: "image-launch-screen") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'image-launch-screen' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    struct reactAppsStoryboard: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "ReactAppsStoryboard"
      let reactAppsViewController = StoryboardViewControllerResource<ReactAppsViewController>(identifier: "ReactAppsViewController")
      
      func reactAppsViewController(_: Void = ()) -> ReactAppsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: reactAppsViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.reactAppsStoryboard().reactAppsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'reactAppsViewController' could not be loaded from storyboard 'ReactAppsStoryboard' as 'ReactAppsViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct slotsStoryboard: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "SlotsStoryboard"
      let slotsViewController = StoryboardViewControllerResource<SlotsViewController>(identifier: "SlotsViewController")
      
      func slotsViewController(_: Void = ()) -> SlotsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: slotsViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.slotsStoryboard().slotsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'slotsViewController' could not be loaded from storyboard 'SlotsStoryboard' as 'SlotsViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct sportsBookStoryboard: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "SportsBookStoryboard"
      let sportsBookViewController = StoryboardViewControllerResource<SportsBookViewController>(identifier: "SportsBookViewController")
      
      func sportsBookViewController(_: Void = ()) -> SportsBookViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: sportsBookViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.sportsBookStoryboard().sportsBookViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'sportsBookViewController' could not be loaded from storyboard 'SportsBookStoryboard' as 'SportsBookViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}

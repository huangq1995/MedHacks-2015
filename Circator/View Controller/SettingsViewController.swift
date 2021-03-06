//
//  SettingsViewController.swift
//  Pods
//
//  Created by Yanif Ahmad on 9/27/15.
//
//

import UIKit
import HealthKit
import Realm
import RealmSwift
import SwiftyJSON
import Alamofire

class SettingsViewController: UIViewController {

  let healthManager = HealthManager()
  let kUnknownString = "Unknown"
  var height : HKQuantitySample?

  @IBOutlet var heightLabel:UILabel!

  override func viewDidLoad() {
      super.viewDidLoad()
      authorizeHealthKit()

      heightLabel = UILabel()
      heightLabel.text = kUnknownString
      heightLabel.textColor = UIColor.blackColor()
      heightLabel.textAlignment = .Center
      heightLabel.font = UIFont.systemFontOfSize(20)
      heightLabel.frame = CGRectMake(0, 100, 300, 100)

      self.view.addSubview(heightLabel)
      updateHeight()
    
      let uploadButton = UIButton()
      uploadButton.setTitle("Upload", forState: .Normal)
      uploadButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
      let buttonWidth = (UIScreen.mainScreen().bounds.width - 80)
      uploadButton.frame = CGRectMake(40, 250, buttonWidth, 50)
      uploadButton.titleLabel!.textAlignment = .Center
      uploadButton.addTarget(self, action: "uploadPressed", forControlEvents: .TouchUpInside)
      uploadButton.layer.cornerRadius = 7.0
      uploadButton.backgroundColor = UIColor(red: 67/255.0, green: 114/255.0, blue: 170/255.0, alpha: 1.0)

      self.view.addSubview(uploadButton)
  }
    
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
    
  func uploadPressed() {
      let realm = try! Realm()
      var jsonArray : [[String:AnyObject]] = []
      for i in realm.objects(Sample) {
        jsonArray.append(i.asDict())
      }
      let json = ["samples":jsonArray]
      print("Device samples: " + json["samples"]!.count.description)
      Alamofire.request(.POST, "http://damsl.cs.jhu.edu/circator/post", parameters: json, encoding: .JSON)
  }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

  func authorizeHealthKit()
  {
    healthManager.authorizeHealthKit { (authorized,  error) -> Void in
      if authorized {
        print("HealthKit authorization received.")
      }
      else
      {
        print("HealthKit authorization denied!")
        if error != nil {
          print("\(error)")
        }
      }
    }
  }

  func updateHeight()
  {
    // 1. Construct an HKSampleType for Height
    let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!

    // 2. Call the method to read the most recent Height sample
    self.healthManager.readMostRecentSample(sampleType, completion: { (mostRecentHeight, error) -> Void in

      if( error != nil )
      {
        print("Error reading height from HealthKit Store: \(error.localizedDescription)")
        return;
      }

      var heightLocalizedString = self.kUnknownString;
      self.height = mostRecentHeight as? HKQuantitySample;

      // 3. Format the height to display it on the screen
      if let meters = self.height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
        let heightFormatter = NSLengthFormatter()
        heightFormatter.forPersonHeightUse = true;
        heightLocalizedString = heightFormatter.stringFromMeters(meters);
      }

      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.heightLabel.text = "HK Height: " + heightLocalizedString
      });
    })
  }    
}

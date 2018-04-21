

import UIKit
import Licensy

class LicenseViewController: UIViewController {

    @IBOutlet weak var tableView: LicensyTable!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    
    let librariesArray: Array<LibraryEntity> = [
        LibraryEntity(name: "Alamofire", organization: "Alamofire Software Foundation", url: "https://github.com/Alamofire/Alamofire", copyright: "Copyright (c) 2014-2018 Alamofire Software Foundation", license: MITLicense()),
        LibraryEntity(name: "SDWebImage", organization: "Olivier Poitrey", url: "https://github.com/rs/SDWebImage", copyright: "Copyright (c) 2009-2017 Olivier Poitrey rs@dailymotion.com", license: MITLicense()),
        LibraryEntity(name: "SwiftyJSON", organization: "Ruoyu Fu", url: "https://github.com/SwiftyJSON/SwiftyJSON", copyright: "Copyright (c) 2017 Ruoyu Fu", license: MITLicense()),
        LibraryEntity(name: "UICircularProgressRing", organization: "Luis Padron", url: "https://github.com/luispadron/UICircularProgressRing", copyright: "Copyright (c) 2017 Luis Padron", license: MITLicense()),
        LibraryEntity(name: "Animated Tab Bar", organization: "Ramotion Inc.", url: "https://github.com/Ramotion/animated-tab-bar", copyright: "Copyright (c) 2014 Ramotion", license: MITLicense()),
        LibraryEntity(name: "CRRefresh", organization: "W_C__L", url: "https://github.com/CRAnimation/CRRefresh", copyright: "Copyright (c) 2017 W_C__L", license: MITLicense()),
        LibraryEntity(name: "FloatingActionSheetController", organization: "ra1028", url: "https://github.com/ra1028/FloatingActionSheetController", copyright: "Copyright (c) 2015 ra1028", license: MITLicense()),
        LibraryEntity(name: "Licensy", organization: "David Jimenez Guinaldo & Guillermo Garcia Rebolo", url: "https://github.com/gygr969/Licensy", copyright: "Copyright (c) 2017 David Jiménez Guinaldo & Guillermo Garcia Rebolo", license: MITLicense()),
        LibraryEntity(name: "AKSwiftSlideMenu", organization: "Ashish Kakkad", url: "https://github.com/ashishkakkad8/AKSwiftSlideMenu", copyright: "Copyright (c) 2017 Ashish Kakkad", license: MITLicense())        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissLicense(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

//TableView
extension LicenseViewController {
    
    func createTableView (){
        tableView.setLibraries(librariesArray)
        tableView.appearance.headerBackgroundColor = UIColor(named: "SecondaryColor")
        tableView.appearance.headerContentColor = UIColor(named: "PrimaryColor")
        tableView.appearance.accentColor = UIColor(named: "SecondaryColor")

    }
    
}

//Botón
extension LicenseViewController {
    
    func resizeButton() {
        let widthScreen = view.bounds.width
        let heightScreen = view.bounds.height
        let widthConstraint = widthScreen < heightScreen ? 0.12 : 0.075
        let heightConstraint = widthScreen < heightScreen ? 0.06 : 0.1
        buttonWidth.constant = self.view.frame.width * CGFloat(widthConstraint)
        buttonHeight.constant = self.view.frame.height * CGFloat(heightConstraint)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.green.cgColor
    }

}






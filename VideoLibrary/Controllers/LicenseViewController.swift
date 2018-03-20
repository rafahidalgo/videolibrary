

import UIKit
import Licensy

class LicenseViewController: UIViewController {

    @IBOutlet weak var tableView: LicensyTable!
    
    let librariesArray: Array<LibraryEntity> = [
        LibraryEntity(name: "Alamofire", organization: "Alamofire Software Foundation", url: "https://github.com/Alamofire/Alamofire", copyright: "Copyright (c) 2014-2018 Alamofire Software Foundation", license: MITLicense()),
        LibraryEntity(name: "AlamofireImage", organization: "Alamofire Software Foundation", url: "https://github.com/Alamofire/AlamofireImage", copyright: "Copyright (c) 2015-2017 Alamofire Software Foundation", license: MITLicense()),
        LibraryEntity(name: "SwiftyJSON", organization: "Ruoyu Fu", url: "https://github.com/SwiftyJSON/SwiftyJSON", copyright: "Copyright (c) 2017 Ruoyu Fu", license: MITLicense()),
        LibraryEntity(name: "UICircularProgressRing", organization: "Luis Padron", url: "https://github.com/luispadron/UICircularProgressRing", copyright: "Copyright (c) 2017 Luis Padron", license: MITLicense()),
        LibraryEntity(name: "Animated Tab Bar", organization: "Ramotion Inc.", url: "https://github.com/Ramotion/animated-tab-bar", copyright: "Copyright (c) 2014 Ramotion", license: MITLicense()),
        LibraryEntity(name: "CRRefresh", organization: "W_C__L", url: "https://github.com/CRAnimation/CRRefresh", copyright: "Copyright (c) 2017 W_C__L", license: MITLicense()),
        LibraryEntity(name: "FloationgActionSheetController", organization: "ra1028", url: "https://github.com/ra1028/FloatingActionSheetController", copyright: "Copyright (c) 2015 ra1028", license: MITLicense()),
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
    
}

//TableView
extension LicenseViewController {
    
    func createTableView (){
        tableView.setLibraries(librariesArray)
//        tableView.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
//        tableView.layer.borderWidth = 1
        tableView.appearance.headerBackgroundColor = UIColor(named: "SecondaryColor")
        tableView.appearance.headerContentColor = UIColor(named: "PrimaryColor")
        tableView.appearance.accentColor = UIColor(named: "SecondaryColor")

    }
    
}





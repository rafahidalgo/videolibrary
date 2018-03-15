

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index: Int32)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!    
    @IBOutlet var buttonHeighConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var menuImage: UIImageView!
    
    var btnMenu: UIButton!
    var delegate: SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuFormat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.btnCloseTapped(btnCloseMenuOverlay) //Cierra el menú al cambiar de pestaña
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        menuFormat()
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        
        btnMenu.tag = 0
        btnMenu.isHidden = false
        
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
        
    }
}

extension MenuViewController {
    
    func menuFormat() {
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        let widthConstraint = view.bounds.width > view.bounds.height ? 0.75 : 0.5
        
        menuWidthConstraint.constant = self.view.bounds.width * CGFloat(widthConstraint)
        
        for i in 0..<menuButtons.count {
            buttonHeighConstraints[i].constant = menuButtons[i].layer.bounds.width / 5
            menuButtons[i].layer.cornerRadius = menuButtons[i].layer.bounds.width / 30
        }
        
        menuImage.layer.cornerRadius = menuImage.layer.bounds.width / 10
        
    }
    
}


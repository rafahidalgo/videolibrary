//
//  Utils.swift
//  VideoLibrary
//
//  Created by MIMO on 11/2/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    
    init() {
        
    }
    
    func showLoadingIndicator(title: String, view: UIView) -> (UIActivityIndicatorView, UIVisualEffectView) {
        //https://stackoverflow.com/questions/28785715/how-to-display-an-activity-indicator-with-text-on-ios-8-with-swift
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        
        activityIndicator.startAnimating()
        view.addSubview(effectView)
        
        return (activityIndicator, effectView)
    }
    
    func stopLoadingIndicator(indicator: (UIActivityIndicatorView, UIVisualEffectView)) {
        
        indicator.0.stopAnimating()
        indicator.1.removeFromSuperview()
    }
    
    
    
    func styleCardMoviesAndTVShows(cell: MovieViewCell) -> UICollectionViewCell{//lo pongo aqui porque puede que lo necesitemos para otra pantalla
        
        cell.layer.cornerRadius = 10.0
        cell.moviePoster.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    
    
}

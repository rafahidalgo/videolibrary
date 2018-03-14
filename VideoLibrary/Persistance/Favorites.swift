//
//  Favorites.swift
//  VideoLibrary
//
//  Created by MIMO on 8/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import Foundation
import CoreData

class Favorites {
    
    func addFavoriteMovie(id: Int, title: String, image: String?) -> Bool {
    
        //Comprobamos si la película ya está en favoritos
        if searchMovie(id: id) != nil {
            return false
        }
        
        let movie = NSEntityDescription.insertNewObject(forEntityName: "FavoriteMovies", into: CoreDataStack.sharedInstance.context) as! FavoriteMovies
        
        movie.id = id as NSNumber
        movie.movieName = title
        movie.posterUrl = image

        CoreDataStack.sharedInstance.saveContext()
        return true
    }
    
    func checkFavoritesMovies() -> [FavoriteMovies]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovies")
        
        do {
            
            let fetchedMovies = try CoreDataStack.sharedInstance.context.fetch(fetchRequest)
            let results = fetchedMovies as! [FavoriteMovies]
            let movies = (results.count > 0) ? results : nil
            
            return movies
            
        }catch let err as NSError{
            fatalError("Failed to fetch FavoriteMovies: \(err)")
        }
    }
    
    func searchMovie(id: Int) -> [FavoriteMovies]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovies")
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let fetchedMovie = try CoreDataStack.sharedInstance.context.fetch(request)
            let result = fetchedMovie as! [FavoriteMovies]
            
            let movie = (result.count > 0) ? result : nil

            return movie
            
        } catch let err as NSError {
            fatalError("Failed to fetch movie: \(err)")
        }
    }
    
    func deleteFavoriteMovie(id: Int) -> Bool {
        
        guard let movie = searchMovie(id: id) else {
            return false
        }
        
        for item in movie {
            CoreDataStack.sharedInstance.context.delete(item)
        }
        
        CoreDataStack.sharedInstance.saveContext()
        return true
    }
    
    func addFavoriteShow(id: Int, name: String, image: String?) -> Bool{
        
        //Comprobamos si la serie ya está en favoritos
        if searchTVShow(id: id) != nil {
            return false
        }
        
        let show = NSEntityDescription.insertNewObject(forEntityName: "FavoriteTVShows", into: CoreDataStack.sharedInstance.context) as! FavoriteTVShows
        
        show.id = id as NSNumber
        show.tvShowName = name
        show.posterUrl = image
        
        CoreDataStack.sharedInstance.saveContext()
        return true
    }
    
    func checkFavoritesShows() -> [FavoriteTVShows]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteTVShows")
        
        do {
            
            let fetchedShows = try CoreDataStack.sharedInstance.context.fetch(fetchRequest)
            let results = fetchedShows as! [FavoriteTVShows]
            let shows = (results.count > 0) ? results : nil
            
            return shows
            
        }catch let err as NSError{
            fatalError("Failed to fetch FavoriteMovies: \(err)")
        }
    }
    
    func searchTVShow(id: Int) -> [FavoriteTVShows]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteTVShows")
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let fetchedShow = try CoreDataStack.sharedInstance.context.fetch(request)
            let result = fetchedShow as! [FavoriteTVShows]
            
            let show = (result.count > 0) ? result : nil
            
            return show
            
        } catch let err as NSError {
            fatalError("Failed to fetch movie: \(err)")
        }
    }
    
    func deleteFavoriteShow(id: Int) -> Bool{
        
        guard let show = searchTVShow(id: id) else {
            return false
        }
        
        for item in show {
            CoreDataStack.sharedInstance.context.delete(item)
        }
        
        CoreDataStack.sharedInstance.saveContext()
        return true
    }
}

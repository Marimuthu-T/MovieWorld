//
//  ResultCollectionViewController.swift
//  MovieWorld
//
//  Created by Marimuthu T on 07/09/21.
//

import UIKit


class MovieDetailViewController: UIViewController {
    
    var poster : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPoster()
    }
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    func loadPoster()
    {
        moviePoster.image = poster
    }
    
    
    
}




class ResultCollectionViewController: UIViewController , UISearchBarDelegate , UICollectionViewDelegate , UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    var movieResults : MovieResults?
    var posters : [Int : UIImage] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSearchBar.delegate = self
        movieResultCollectionView.delegate = self
        movieResultCollectionView.dataSource = self
        
        setupLongGestureRecognizerOnCollection()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = self.movieResults?.results.count ?? 0
        print(cellCount)
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard movieResults != nil else {
            return movieResultCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterCell", for: indexPath) as! MoviePosterCollectionViewCell
        }
        let cell = movieResultCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterCell", for: indexPath) as! MoviePosterCollectionViewCell
        cell.poster.image = posters[movieResults!.results[indexPath.row].id]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  movieDetailsSegue = segue.destination as? MovieDetailViewController
        {
            let selectedRow = movieResultCollectionView.indexPathsForSelectedItems?[0].row ?? 0
            
            movieDetailsSegue.poster = posters[movieResults?.results[selectedRow].id ?? 0]
        }
    
    }

    //TODO : LongPress
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        movieResultCollectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    var longpressimage : UIImage?

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let poster = gestureRecognizer.location(in: movieResultCollectionView)

        if let indexPath = movieResultCollectionView?.indexPathForItem(at: poster) {
            longpressimage = posters[movieResults?.results[indexPath.row].id ?? 0]
            let action = UIAlertController(title: "longPress", message: "ActionSheet   for \(movieResults?.results[indexPath.row].title ?? "99")", preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "Download Poster", style: .default)
            let share = UIAlertAction(title: "Share", style: .default, handler: shareHandler(alertAction:))
            action.addAction(ok)
            action.addAction(share)
            self.present(action, animated: true)
            
         }
    }
    
    func shareHandler(alertAction : UIAlertAction) -> Void
    {
        
        present( UIActivityViewController(activityItems: [longpressimage ?? UIImage()], applicationActivities: nil) , animated: false )
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       performSegue(withIdentifier: "ShowPoster", sender: self)
       
    }
    

    
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
   
    @IBOutlet weak var movieResultCollectionView: UICollectionView!
 
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    var lastSearchTask : URLSessionTask?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        movieResults = nil
        posters = [:]
        movieResultCollectionView.reloadData()
        lastSearchTask?.cancel()
        guard searchText.count >= 2 else {
            lastSearchTask?.cancel()
            return
        }
        self.lastSearchTask = TMDBClient.movieSearch(for: searchText, completionHandler: movieSearchCompletionHandler(data:status:error:))
        lastSearchTask?.resume()
    }
    
    
   func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    if searchBar.text == "SearchForYourMovie.."
    {
        searchBar.text = ""
    }
    return true
   }
    
    
    func movieSearchCompletionHandler(data : MovieResults? , status : Bool , error : Error?)
    {
        
        guard status , error == nil else {
            print(error.debugDescription)
            return
        }
        
        guard let data = data else {
            print("Erroe")
            return
        }
        
        self.movieResults = data
        
        for movies in data.results
        {
            if  let posterpath = movies.posterPath
            {
                TMDBClient.imageLoader(forPath:posterpath)
                {
                    (data , status , error) in
                    if let  data =  data , status , error == nil
                    {
                        if let poster = UIImage(data: data)
                        {
                            
                            print(movies.title ?? "99")
                            self.posters[movies.id] = poster
                            
                            DispatchQueue.main.async {
                                self.movieResultCollectionView.reloadData()
                            }
                            return
                        }
                        print("7")
                    }
                    print(error.debugDescription)
                    self.posters[movies.id] = UIImage()
                }
            }
            else
            {
                print("rg")
            }
        }
    }
    
    

}

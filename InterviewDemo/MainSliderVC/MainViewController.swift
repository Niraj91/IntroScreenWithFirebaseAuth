//
//  ViewController.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slidesArray: [SliderModel] = []
    
    var timer = Timer()
    
    var counter = 0 {
        didSet {
            self.pageControl.currentPage = self.counter
            if counter == self.slidesArray.count - 1 {
                self.skipButton.isHidden = true
                self.nextButton.setTitle("GOT IT", for: .normal)
                self.timer.invalidate()
            } else {
                self.skipButton.isHidden = false
                self.nextButton.setTitle("NEXT", for: .normal)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slidesArray = [SliderModel(title: "Hello Food!", description: "The easiest way to order food from your favourite restaurant!", images: #imageLiteral(resourceName: "ic_food")),
                            SliderModel(title: "Movie Tickets", description: "Book movie tickets for your family and friends!", images: #imageLiteral(resourceName: "ic_movie")),
                            SliderModel(title: "Great Discounts", description: "Best discounts on every single service we offer!", images: #imageLiteral(resourceName: "ic_discount"))]
        self.sliderCollectionView.delegate = self
        self.sliderCollectionView.dataSource = self
        self.reloadCollectionView()
        
        let location: String = "382481"
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if ((placemarks?.count)! > 0) {
                let placemark: CLPlacemark = (placemarks?[0])!
                let state: String = placemark.administrativeArea!
                print(state);
            }
        } as! CLGeocodeCompletionHandler)
    }
}

// MARK: - Action Methods -
extension MainViewController {
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        
        self.timer.invalidate()
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc,animated: true)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if self.counter < self.slidesArray.count {
                    if self.counter == self.slidesArray.count - 1 {
                        self.timer.invalidate()
                        let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.navigationController?.pushViewController(vc,animated: true)
                    } else {
                        self.counter += 1
                        let index = IndexPath.init(item: self.counter, section: 0)
                        self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                    }
                } else {
                    self.counter = 0
                }
            }
        }
    }
}

// MARK: - Private Methods -
private extension MainViewController {
    
    func reloadCollectionView() {
        
        self.sliderCollectionView.reloadData()
        self.timer.invalidate()
        self.pageControl.currentPage = 0
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {

        if self.counter < self.slidesArray.count {
            self.counter += 1
            let index = IndexPath.init(item: self.counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.pageControl.currentPage = self.counter
        } else {
            self.counter = 0
            let index = IndexPath.init(item: self.counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            self.pageControl.currentPage = self.counter
            self.counter = 1
        }
    }
}

// MARK: - Collection view DataSource Method
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.slidesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCollectionViewCell.identifier, for: indexPath) as! SliderCollectionViewCell
        cell.setUp(slidesArray[indexPath.row])
        
        return cell
    }
}

// MARK: - Collection view Delegate Methods -
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        counter = Int(scrollView.contentOffset.x / width)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Method -
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
}

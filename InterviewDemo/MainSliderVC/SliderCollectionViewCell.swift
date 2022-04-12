//
//  SliderCollectionViewCell.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SliderCollectionViewCell.self)
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setUp(_ slider: SliderModel) {
        self.imageView.image = slider.images
        self.titleLabel.text = slider.title
        self.descriptionLabel.text = slider.description
    }
}

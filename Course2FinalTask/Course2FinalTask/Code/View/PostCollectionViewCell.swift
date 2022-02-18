import UIKit
import DataProvider

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = bounds
    }
    
    func configure(with postImage: UIImage?) {
        if let postImage = postImage {
            photoImageView.image = postImage
            setNeedsLayout()
        }
    }
}

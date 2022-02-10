import UIKit
import DataProvider

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var usernameTextView: UILabel!
    @IBOutlet weak var dateOfPublicationTextView: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var amountOfLikeTextView: UILabel!
    @IBOutlet weak var descriptionTextView: UILabel!
    @IBOutlet weak var likeButtonView: UIButton!
    
    @IBAction func likeButtonAction(_ sender: Any) {
        if likeButtonView.tintColor == .systemBlue {
            amountOfLikeTextView.text = String(Int(amountOfLikeTextView.text!)! - 1)
            likeButtonView.tintColor = .lightGray
        } else {
            amountOfLikeTextView.text = String(Int(amountOfLikeTextView.text!)! + 1)
            likeButtonView.tintColor = .systemBlue
        }
    }
    
    func configure(with post: Post) {
        configureAutoresizingMask()
        authorImageView.image = post.authorAvatar
        usernameTextView.text = post.authorUsername
        dateOfPublicationTextView.text = fromDateToString(from: post.createdTime)
        postImageView.image = post.image
        amountOfLikeTextView.text = String(post.likedByCount)
        descriptionTextView.text = post.description
        setNeedsLayout()
    }
    
    private func configureAutoresizingMask() {
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextView.translatesAutoresizingMaskIntoConstraints = false
        dateOfPublicationTextView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        amountOfLikeTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func fromDateToString(from date: Date) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        let dateFirstPart = relativeDateFormatter.string(from: date)

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
        let dateSecondPart = timeFormatter.string(from: date)
        
        return dateFirstPart + " at " + dateSecondPart
    }
}

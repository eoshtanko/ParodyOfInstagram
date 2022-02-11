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
    
    private static var likedPosts = Set<IndexPath>()
    private var indexPath: IndexPath!
    private var controller: FeedViewController!
    private var userIdentifier: User.Identifier!
    
    @IBAction func likeButtonAction(_ sender: Any) {
        if likeButtonView.tintColor == .systemBlue {
            amountOfLikeTextView.text = String(Int(amountOfLikeTextView.text!)! - 1)
            likeButtonView.tintColor = .lightGray
            FeedTableViewCell.likedPosts.remove(indexPath)
        } else {
            amountOfLikeTextView.text = String(Int(amountOfLikeTextView.text!)! + 1)
            likeButtonView.tintColor = .systemBlue
            FeedTableViewCell.likedPosts.insert(indexPath)
        }
    }
    
    func configure(with post: Post, index: IndexPath, instance: FeedViewController) {
        indexPath = index
        controller = instance
        userIdentifier = post.author
        configureAutoresizingMask()
        setLikeGestureRecognizer()
        setGoToProfileGestureRecognizer()
        likeButtonView.tintColor = setTintColor()
        configureValues(with: post)
        setNeedsLayout()
    }
    
    func setGoToProfileGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        authorImageView.addGestureRecognizer(tap)
    }
    
    @objc private func goToProfile() {
        controller.userIdentifier = userIdentifier
        controller.goToProfile()
    }
    
    func setLikeGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeAnimation))
        tap.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tap)
    }
    
    @objc func likeAnimation() {
        likeButtonAction(self)
    }
    
    private func setTintColor() -> UIColor {
        if FeedTableViewCell.likedPosts.contains(indexPath) {
            return UIColor.systemBlue
        }
        return UIColor.lightGray
    }
    
    private func configureValues(with post: Post) {
        authorImageView.image = post.authorAvatar
        usernameTextView.text = post.authorUsername
        dateOfPublicationTextView.text = fromDateToString(from: post.createdTime)
        postImageView.image = post.image
        amountOfLikeTextView.text = String(post.likedByCount)
        descriptionTextView.text = post.description
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
    
    private func configureAutoresizingMask() {
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextView.translatesAutoresizingMaskIntoConstraints = false
        dateOfPublicationTextView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        amountOfLikeTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
}

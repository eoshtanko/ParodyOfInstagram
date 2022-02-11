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
    @IBOutlet weak var likeImageView: UIImageView!
    
    private static var likedPosts = Set<IndexPath>()
    private var indexPath: IndexPath!
    private var controller: FeedViewController!
    private var userIdentifier: User.Identifier!
    
    @IBAction func likeButtonAction(_ sender: Any) {
        if likeButtonView.tintColor == .systemBlue {
            dislike()
        } else {
            like()
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
    
    private func like() {
        if (!FeedTableViewCell.likedPosts.contains(indexPath)) {
            amountOfLikeTextView.text = String(Int(amountOfLikeTextView.text!)! + 1)
            likeButtonView.tintColor = .systemBlue
            FeedTableViewCell.likedPosts.insert(indexPath)
        }
    }
    
    private func dislike() {
        if (FeedTableViewCell.likedPosts.contains(indexPath)) {
            amountOfLikeTextView.text = String(Int(amountOfLikeTextView.text!)! - 1)
            likeButtonView.tintColor = .lightGray
            FeedTableViewCell.likedPosts.remove(indexPath)
        }
    }
    
    private func setLikeGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapLikeAction))
        tap.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tap)
    }

    @objc private func doubleTapLikeAction() {
        likeAnimation()
        like()
    }
    
    private func likeAnimation() {
        CATransaction.begin()
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.values = [0, 1, 1]
        animation.keyTimes = [0, 0.03, 1]
        animation.duration = 0.3
        CATransaction.setCompletionBlock {
            self.gettingSmallerAnimation()
            self.likeImageView.layer.opacity = 0
        }
        self.likeImageView.layer.opacity = 1
        likeImageView.layer.add(animation, forKey: "appear")
        CATransaction.commit()
    }
    
    private func gettingSmallerAnimation() {
        let gettingSmallerAnimation = CABasicAnimation(keyPath: "opacity")
        gettingSmallerAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        gettingSmallerAnimation.fromValue = 1
        gettingSmallerAnimation.toValue = 0
        gettingSmallerAnimation.duration = 0.3
        gettingSmallerAnimation.isRemovedOnCompletion = false
        likeImageView.layer.add(gettingSmallerAnimation, forKey: "disappear")
    }
    
    func setGoToProfileGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        authorImageView.addGestureRecognizer(tap)
    }
    
    @objc private func goToProfile() {
        controller.userIdentifier = userIdentifier
        controller.goToProfile()
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

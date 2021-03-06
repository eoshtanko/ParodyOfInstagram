import UIKit
import DataProvider

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var usernameLabelView: UILabel!
    @IBOutlet weak var dateOfPublicationTextView: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesLabelView: UILabel!
    @IBOutlet weak var amountOfLikeLabelView: UILabel!
    @IBOutlet weak var descriptionLabelView: UILabel!
    @IBOutlet weak var likeButtonView: UIButton!
    @IBOutlet weak var likeImageView: UIImageView!
    
    private var post: Post!
    private var controller: FeedViewController!
    private var userIdentifier: User.Identifier!
    
    @IBAction func likeButtonAction(_ sender: Any) {
        if post.currentUserLikesThisPost {
            unlike()
        } else {
            like()
        }
    }
    
    func configure(with post: Post, instance: FeedViewController) {
        self.post = post
        controller = instance
        userIdentifier = post.author
        configureAutoresizingMask()
        setLikeGestureRecognizer()
        setGoToThoseWhoLikedGestureRecognizer()
        setGoToProfileGestureRecognizer()
        likeButtonView.tintColor = setTintColor()
        configureValues(with: post)
        setNeedsLayout()
    }
    
    private func like() {
        if (!post.currentUserLikesThisPost && DataProviders.shared.postsDataProvider.likePost(with: post.id)) {
            post.currentUserLikesThisPost = true
            amountOfLikeLabelView.text = String(Int(amountOfLikeLabelView.text!)! + 1)
            likeButtonView.tintColor = .systemBlue
        }
    }
    
    private func unlike() {
        if (post.currentUserLikesThisPost && DataProviders.shared.postsDataProvider.unlikePost(with: post.id)) {
            post.currentUserLikesThisPost = false
            amountOfLikeLabelView.text = String(Int(amountOfLikeLabelView.text!)! - 1)
            likeButtonView.tintColor = .lightGray
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
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: {
            self.likeImageView.layer.opacity = 1
        }){_ in
            self.likeImageView.layer.opacity = 1
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
                self.likeImageView.layer.opacity = 0
            }) {
                _ in
                self.likeImageView.layer.opacity = 0
            }
        }
    }
    
    func setGoToProfileGestureRecognizer() {
        let tapOnAuthorImage = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        authorImageView.addGestureRecognizer(tapOnAuthorImage)
        let tapOnUsername = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        usernameLabelView.addGestureRecognizer(tapOnUsername)
    }
    
    @objc private func goToProfile() {
        controller.userIdentifier = userIdentifier
        controller.goToProfile()
    }
    
    func setGoToThoseWhoLikedGestureRecognizer() {
        let tapOnLikesLabel = UITapGestureRecognizer(target: self, action: #selector(goToThoseWhoLiked))
        likesLabelView.addGestureRecognizer(tapOnLikesLabel)
        let tapOnLikesCount = UITapGestureRecognizer(target: self, action: #selector(goToThoseWhoLiked))
        amountOfLikeLabelView.addGestureRecognizer(tapOnLikesCount)
    }
    
    @objc private func goToThoseWhoLiked() {
        controller.postIdentifier = post.id
        controller.goToThoseWhoLiked()
    }
    
    private func setTintColor() -> UIColor {
        if post.currentUserLikesThisPost {
            return UIColor.systemBlue
        }
        return UIColor.lightGray
    }
    
    private func configureValues(with post: Post) {
        authorImageView.image = post.authorAvatar
        usernameLabelView.text = post.authorUsername
        dateOfPublicationTextView.text = fromDateToString(from: post.createdTime)
        postImageView.image = post.image
        amountOfLikeLabelView.text = String(post.likedByCount)
        descriptionLabelView.text = post.description
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
        usernameLabelView.translatesAutoresizingMaskIntoConstraints = false
        dateOfPublicationTextView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        amountOfLikeLabelView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabelView.translatesAutoresizingMaskIntoConstraints = false
    }
}

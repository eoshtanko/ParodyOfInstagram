import UIKit
import DataProvider

class ProfileHeaderView: UICollectionReusableView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabelView: UILabel!
    @IBOutlet weak var followersLabelView: UILabel!
    @IBOutlet weak var followersValueLabelView: UILabel!
    @IBOutlet weak var followingLabelView: UILabel!
    @IBOutlet weak var followingValueLabelView: UILabel!
    private var controller: ProfileViewController!
    
    func configureValues(with profile: User, instance: ProfileViewController) {
        controller = instance
        profileImageView.image = profile.avatar
        nameLabelView.text = profile.fullName
        followersValueLabelView.text = String(profile.followedByCount)
        followingValueLabelView.text = String(profile.followsCount)
        configureProfileImageView()
        configureGestureRecognizer()
    }
    
    private func configureProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func configureGestureRecognizer() {
        setGoToFollowersGestureRecognizer()
        setGoToFollowingGestureRecognizer()
    }
    
    @objc private func goToFollowers() {
        controller.goToFollowers()
    }
    
    @objc private func goToFollowing() {
        controller.goToFollowing()
    }
    
    func setGoToFollowersGestureRecognizer() {
        let tapOnFollowersLabel = UITapGestureRecognizer(target: self, action: #selector( goToFollowers))
        followersLabelView.addGestureRecognizer(tapOnFollowersLabel)
        let tapOnFollowersValue = UITapGestureRecognizer(target: self, action: #selector(goToFollowers))
        followersValueLabelView.addGestureRecognizer(tapOnFollowersValue)
    }
    
    func setGoToFollowingGestureRecognizer() {
        let tapOnFollowingLabel = UITapGestureRecognizer(target: self, action: #selector(goToFollowing))
        followingLabelView.addGestureRecognizer(tapOnFollowingLabel)
        let tapOnFollowingValue = UITapGestureRecognizer(target: self, action: #selector(goToFollowing))
        followingValueLabelView.addGestureRecognizer(tapOnFollowingValue)
    }
}

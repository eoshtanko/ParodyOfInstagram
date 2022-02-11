import UIKit
import DataProvider

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextView: UILabel!
    @IBOutlet weak var followersTextView: UILabel!
    @IBOutlet weak var followingTextView: UILabel!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var pageLable: UINavigationItem!
    
    var userIdentifier: User.Identifier?
    var currentProfile: User!
    
    override func viewDidLoad() {
        if userIdentifier != nil {
            currentProfile = DataProviders.shared.usersDataProvider.user(with: userIdentifier!)
        } else {
            currentProfile = DataProviders.shared.usersDataProvider.currentUser()
        }
        configureValues(with: currentProfile)
    }
    
    private func configureValues(with profile: User) {
        profileImageView.image = profile.avatar
        nameTextView.text = profile.fullName
        followersTextView.text = String(profile.followedByCount)
        followingTextView.text = String(profile.followsCount)
        pageLable.title = profile.username
    }
}

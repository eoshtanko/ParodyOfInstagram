import UIKit
import DataProvider

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabelView: UILabel!
    @IBOutlet weak var followersLabelView: UILabel!
    @IBOutlet weak var followersValueLabelView: UILabel!
    @IBOutlet weak var followingLabelView: UILabel!
    @IBOutlet weak var followingValueLabelView: UILabel!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var userIdentifier: User.Identifier!
    var currentProfile: User!
    var usersPosts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUser()
        configurePosts()
        configureValues(with: currentProfile)
        configureProfileImageView()
        configureGestureRecognizer()
        view.addSubview(postsCollectionView)
        postsCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Const.cellReuseIdentifier)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postsCollectionView.frame = CGRect(x: 0,
                                           y: 86 + view.safeAreaInsets.top,
                                            width: view.frame.width,
                                           height: view.frame.height - view.safeAreaInsets.bottom - 150)
        postsCollectionView.contentInset.bottom = postsCollectionView.safeAreaInsets.bottom
    }
    
    private func configureUser() {
        if userIdentifier != nil {
            currentProfile = DataProviders.shared.usersDataProvider.user(with: userIdentifier!)
        } else {
            currentProfile = DataProviders.shared.usersDataProvider.currentUser()
            userIdentifier = currentProfile.id
        }
    }
    
    private func configurePosts() {
        usersPosts = DataProviders.shared.postsDataProvider.findPosts(by: userIdentifier)
    }

    private func configureValues(with profile: User) {
        profileImageView.image = profile.avatar
        nameLabelView.text = profile.fullName
        followersValueLabelView.text = String(profile.followedByCount)
        followingValueLabelView.text = String(profile.followsCount)
        self.navigationItem.title = profile.username
    }
    
    private func configureProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    // Переходы
    
    func configureGestureRecognizer() {
        setGoToFollowersGestureRecognizer()
        setGoToFollowingGestureRecognizer()
    }
    
    func setGoToFollowersGestureRecognizer() {
        let tapOnFollowersLabel = UITapGestureRecognizer(target: self, action: #selector(goToFollowers))
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
    
    @objc private func goToFollowers() {
        performSegue(withIdentifier: "goToUsersList", sender: "Followers")
    }
    
    @objc private func goToFollowing() {
        performSegue(withIdentifier: "goToUsersList", sender: "Following")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserListViewController {
            self.navigationItem.backButtonTitle = currentProfile.username
            if (sender! as! String) == "Followers" {
                destination.navigationItem.title = "Followers"
                destination.users = DataProviders.shared.usersDataProvider.usersFollowingUser(with: userIdentifier)
            } else {
                destination.navigationItem.title = "Following"
                destination.users = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userIdentifier)
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        usersPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.cellReuseIdentifier, for: indexPath) as! PostCollectionViewCell
        
        cell.configure(with: usersPosts?[indexPath.row].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width / Const.numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    //--------------------------------------------------------------------------------

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private enum Const {
        static let numberOfColumns: CGFloat = 3
        static let cellReuseIdentifier = "postCell"
    }
}

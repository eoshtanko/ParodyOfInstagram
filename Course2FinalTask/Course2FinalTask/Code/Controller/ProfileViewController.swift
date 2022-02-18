import UIKit
import DataProvider

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var currentProfile: User!
    var usersPosts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUser()
        configurePosts()
        configurePostsCollection()
        configureNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postsCollectionView.frame = CGRect(x: 0,
                                           y: view.safeAreaInsets.top,
                                           width: view.frame.width,
                                           height: view.frame.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top)
    }
    
    private func configureUser() {
        if currentProfile == nil {
            currentProfile = DataProviders.shared.usersDataProvider.currentUser()
        }
    }
    
    private func configurePosts() {
        usersPosts = DataProviders.shared.postsDataProvider.findPosts(by: currentProfile.id)
    }
    
    private func configurePostsCollection() {
        view.addSubview(postsCollectionView)
        postsCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Const.cellReuseIdentifier)
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = currentProfile.username
    }
    
    // Переходы
    
    @objc func goToFollowers() {
        performSegue(withIdentifier: "goToUsersList", sender: "Followers")
    }
    
    @objc func goToFollowing() {
        performSegue(withIdentifier: "goToUsersList", sender: "Following")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserListViewController {
            self.navigationItem.backButtonTitle = currentProfile.username
            if (sender! as! String) == "Followers" {
                destination.navigationItem.title = "Followers"
                destination.users = DataProviders.shared.usersDataProvider.usersFollowingUser(with: currentProfile.id)
            } else {
                destination.navigationItem.title = "Following"
                destination.users = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: currentProfile.id)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "profileHeaderView", for: indexPath)
            guard let typedHeaderView = headerView as? ProfileHeaderView
            else { return headerView }
            typedHeaderView.configureValues(with: currentProfile, instance: self)
            return typedHeaderView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    private enum Const {
        static let numberOfColumns: CGFloat = 3
        static let cellReuseIdentifier = "postCell"
    }
}

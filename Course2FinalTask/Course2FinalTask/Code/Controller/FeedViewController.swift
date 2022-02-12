import UIKit
import DataProvider

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [Post] = []
    var userIdentifier: User.Identifier!
    var postIdentifier: Post.Identifier!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = DataProviders.shared.postsDataProvider.feed()
        view.addSubview(feedTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTableView.frame = view.frame
    }
    
    // Переходы.
    
    @objc func goToProfile() {
        performSegue(withIdentifier: "toTheProfile", sender: "Profile info")
    }
    
    @objc func goToThoseWhoLiked() {
        performSegue(withIdentifier: "toThoseWhoLiked", sender: "Likes info")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender! as! String) == "Profile info" {
            if let destination = segue.destination as? ProfileViewController {
                destination.userIdentifier = userIdentifier
            }
        } else {
            if let destination = segue.destination as? UserListViewController {
                destination.navigationItem.title = "Likes"
                destination.navigationItem.backButtonTitle = "Feed"
                destination.usersId = DataProviders.shared.postsDataProvider.usersLikedPost(with: postIdentifier)
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post, instance: self)
        return cell
    }
}

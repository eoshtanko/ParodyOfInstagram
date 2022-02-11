import UIKit
import DataProvider

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [Post] = []
    var userIdentifier: User.Identifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = DataProviders.shared.postsDataProvider.feed()
        view.addSubview(feedTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTableView.frame = view.frame
    }
    
    @objc func goToProfile() {
        performSegue(withIdentifier: "toTheProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProfileViewController {
            let profile = userIdentifier
            destination.userIdentifier = profile
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
        cell.configure(with: post, index: indexPath, instance: self)
        return cell
    }
}

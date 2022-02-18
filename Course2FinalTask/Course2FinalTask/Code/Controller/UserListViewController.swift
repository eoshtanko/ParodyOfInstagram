import UIKit
import DataProvider

class UserListViewController: UIViewController {
    
    @IBOutlet weak var usersListTableView: UITableView!
    
    var usersId: [User.Identifier]? = []
    var users: [User?]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(usersListTableView)
        configureUsers()
    }
    
    private func configureUsers() {
        if let usersId = usersId {
            for id in usersId {
                let user = DataProviders.shared.usersDataProvider.user(with: id)
                users?.append(user)
            }
        }
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        cell.textLabel?.text = users?[indexPath.row]?.fullName
        cell.imageView?.image = users?[indexPath.row]?.avatar
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToLikedUser", sender: nil)
        usersListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProfileViewController {
            let profile = users?[usersListTableView.indexPathForSelectedRow!.row]
            self.navigationItem.backButtonTitle = self.navigationItem.title
            destination.currentProfile = DataProviders.shared.usersDataProvider.user(with: profile!.id)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.heightOfRow
    }
    
    private enum Const {
        static let heightOfRow: CGFloat = 45
    }
}

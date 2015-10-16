import UIKit

class ServerViewController: AbstractViewController, UITableViewDataSource, UITableViewDelegate, ServerCellDelegate, APIManagerDelegate, AddCustomServerDelegate
{
    // MARK: - Variables

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    private let _dataManager : CoreDataManager = CoreDataManager()
    private let _apiManager :APIManager = APIManager()
    private var _isEditing = false
    private var _tempSubViews :[UIView] = []
    private var _alertShown :Bool = false
    
    var servers : [Server] = []

    // MARK: - Load Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        State.fromVC = SegueToServerVC
        State.currentVC = SegueToServerVC

        _apiManager.delegate = self
        
        servers = _dataManager.getServers()
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 10)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    // MARK: - IBAction

    @IBAction func addAccountTouchUpInside(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let serverCustomVC :AddCustomServerVC =  storyboard.instantiateViewControllerWithIdentifier("AddCustomServer") as! AddCustomServerVC
        serverCustomVC.view.frame = CGRect(x: 0, y: topView.frame.height, width: serverCustomVC.view.frame.width, height: serverCustomVC.view.frame.height - topView.frame.height)
        serverCustomVC.view.layer.opacity = 0
        serverCustomVC.delegate = self
        
        _tempSubViews.append(serverCustomVC.view)
        self.view.addSubview(serverCustomVC.view)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            serverCustomVC.view.layer.opacity = 1
            }, completion: nil)
    }
    
    @IBAction func backButtonTouchUpInside(sender: AnyObject) {
        if self.delegate != nil && self.delegate!.respondsToSelector("pageSelected:") {
            (self.delegate as! MainVCDelegate).pageSelected(State.lastVC)
        }
    }
    
    @IBAction func editButtonTouchUpInside(sender: AnyObject) {
        for cell in self.tableView.visibleCells {
            (cell as! ServerViewCell).inEditingState = !_isEditing
            (cell as! ServerViewCell).layoutCell(animated: true)
        }
        
        _isEditing = !_isEditing
    }
    
    // MARK: - TableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ServerViewCell = self.tableView.dequeueReusableCellWithIdentifier("serverCell") as! ServerViewCell
        cell.delegate = self
        
        let cellData  : Server = servers[indexPath.row]
        cell.serverName.text = "  " + cellData.protocolType + "://" + cellData.address + ":" + cellData.port
        if servers[indexPath.row] == State.currentServer {
            cell.isActiveServer = true
        }
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  State.currentServer != nil {
            
            var oldIndex = 0
            
            for var i = 0 ; i < servers.count ; i++ {
                if servers[i] == State.currentServer! {
                    oldIndex = i
                }
            }
            
            let oldIndexPath = NSIndexPath(forRow: oldIndex, inSection: 0)
            
            if oldIndexPath != indexPath {
                let serverCell = tableView.cellForRowAtIndexPath(oldIndexPath) as! ServerViewCell
                
                serverCell.isActiveServer = false
            }
        }
        
        let selectedServer :Server = servers[indexPath.row]
        
        State.currentServer = selectedServer
        
        _apiManager.heartbeat(selectedServer)
    }
    
    //MARK: - ServerCell Delegate
    
    func deleteCell(cell :UITableViewCell) {
        let index :NSIndexPath = tableView.indexPathForCell(cell)!
        
        if index.row < servers.count {
            _dataManager.deleteServer(server: servers[index.row])
            servers.removeAtIndex(index.row)
            
            tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    //MARK: - AddCustomServerDelegate Methods
    
    func serverAdded(successfuly: Bool) {
        if successfuly {
            servers = _dataManager.getServers()
            tableView.reloadData()
        }
    }
    
    //MARK: - APIManagerDelegate Methods
    
    final func heartbeatResponceFromServer(server :Server ,successed :Bool) {
        if successed {
            _apiManager.timeSynchronize(State.currentServer!)
            
            let loadData :LoadData = _dataManager.getLoadData()
            
            loadData.currentServer = State.currentServer!
            _dataManager.commit()
            
            if self.delegate != nil && self.delegate!.respondsToSelector("pageSelected:") {
                (self.delegate as! MainVCDelegate).pageSelected(SegueToLoginVC)
            }
        } else {
            State.currentServer = nil
            if !_alertShown {
                _alertShown = true
                
                let alert :UIAlertController = UIAlertController(title: NSLocalizedString("INFO", comment: "Title"), message: NSLocalizedString("SERVER_UNAVAILABLE", comment: "Description"), preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self._alertShown = false

                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}

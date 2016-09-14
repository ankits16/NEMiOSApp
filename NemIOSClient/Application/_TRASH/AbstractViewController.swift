import UIKit

class AbstractViewController: UIViewController
{
    weak fileprivate var _delegate :AnyObject?
    
    var delegate :AnyObject?{
        set{
            self._delegate = newValue
            delegateIsSetted()
        }
        
        get{
            return self._delegate
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func delegateIsSetted(){
        
    }
}

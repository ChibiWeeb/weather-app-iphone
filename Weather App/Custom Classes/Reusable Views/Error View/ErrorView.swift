//
//  ErrorView.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 06.02.21.
//

import UIKit

class ErrorView: UIView {
    
    @IBOutlet weak var reloadButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ErrorView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func layoutSubviews() {
        reloadButton.layer.cornerRadius = reloadButton.layer.frame.width * 0.1
        
        Glow.setGlow(to: reloadButton)
    }
    
}

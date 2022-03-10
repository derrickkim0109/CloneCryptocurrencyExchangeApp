//
//  CoinDetailsViewController.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/02.
//

import UIKit

class CoinDetailsViewController: ViewControllerInjectingViewModel<CoinDetailsViewModel> {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var interestButton: UIButton!
    @IBOutlet weak var topTabBar: UIStackView!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changeAmountLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChart!
    
    /// 상단 탭별 연결되는 ViewController를 정의
    var viewControllerByTab: [CoinDetailsTopTabs: UIViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        drawLineChart()
        setChildViewControllers()
        setTopTapBarTabEvent()
        
        self.bringSubviewToFront(with: CoinDetailsTopTabs(rawValue: 0) ?? .quote)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUI() {
        titleLabel.text = viewModel.dependency.order
        reflectData(by: viewModel.dependency)
    }
    
    func drawLineChart() {
        viewModel.setInitialDataForChart() { [weak self] data in
            let oneDayToSec: Double = 86400
            let startSec = Date().timeIntervalSince1970 - (oneDayToSec * 30 * 6)
            let openPrice = data.data
                .compactMap { StickInfo(data: $0) }
                .filter { $0.time > startSec * 1000 }
                .map { $0.openPrice }
            
            self?.lineChartView.drawChart(data: openPrice)
        }
    }
    
    func reflectData(by data: CryptocurrencyListTableViewEntity) {
        let currentPrice: String = "\(data.currentPrice)".setNumStringForm(isDecimalType: true)
        let changeRate: String = "\(data.changeRate.displayDecimal(to: 2).setNumStringForm(isMarkPlusMiuns: true))%"
        let changeAmount: String = "\(data.changeAmount)".setNumStringForm(isDecimalType: true, isMarkPlusMiuns: true)
        
        currentPriceLabel.text = currentPrice
        changeRateLabel.text = changeRate
        changeAmountLabel.text = changeAmount
        setColor(updown: UpDown(rawValue: changeAmount.first ?? "0") ?? .zero)
    }
    
    func setColor(updown: UpDown) {
        currentPriceLabel.textColor = updown.color
        changeRateLabel.textColor = updown.color
        changeAmountLabel.textColor = updown.color
    }
    
    /// 상단 탭에 연관되는 뷰컨트롤러를 ChildViewController로 설정
    private func setChildViewControllers() {
        let orderCurrency = viewModel.orderCurrency()
        let paymentCurrency = viewModel.paymentCurrency()
        
        let quoteViewController = QuoteViewController(
            viewModel: QuoteViewModel(
                nibName: "QuoteViewController"
            )
        )
        
        let chartViewController = ChartByTimesViewController(
            viewModel: ChartByTimesViewModel(
                nibName: "ChartByTimesViewController",
                repository: ProductionCandleStickRepository(),
                orderCurrency: .appoint(name: orderCurrency),
                paymentCurrency: PaymentCurrency(rawValue: paymentCurrency) ?? .KRW
            )
        )
        
        viewControllerByTab[.quote] = quoteViewController
        viewControllerByTab[.chart] = chartViewController
        
        viewControllerByTab.values.forEach {
            self.addChildVC($0)
        }
    }
    
    /// 상단 탭을 누름에 따라 touch 이벤트가 동작하도록 설정
    private func setTopTapBarTabEvent() {
        topTabBar.arrangedSubviews.enumerated().forEach { (index, button) in
            guard let button = button as? UIButton else { return }
            button.tag = index
            button.addTarget(
                self,
                action: #selector(didTapTab(button:)),
                for: .touchUpInside
            )
        }
    }

    /// touch 이벤트가 발생할 때마다 누른 탭에 연관되는 view를 최상단 subView로 가져온다
    @objc func didTapTab(button: UIButton) {
        guard let tabType = CoinDetailsTopTabs(rawValue: button.tag) else { return }
        self.bringSubviewToFront(with: tabType)
    }
    
    private func bringSubviewToFront(with type: CoinDetailsTopTabs) {
        guard let tappedView = viewControllerByTab[type]?.view else { return }
        self.view.bringSubviewToFront(tappedView)
    }
    
    private func addChildVC(_ viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: self.topTabBar.bottomAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        viewController.didMove(toParent: self)
    }
    
    private func removeChildVC(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
    }
    @IBAction func clickBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

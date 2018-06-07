//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import UIKit
import Cartography

final class Header: UITableViewHeaderFooterView {
    let connectionViewController: UserConnectionViewController
    static let headerViewReuseIdentifier = "Header"

    public init(connectionViewController: UserConnectionViewController) {
        self.connectionViewController = connectionViewController

        super.init(reuseIdentifier:Header.headerViewReuseIdentifier)

        ///TODO: embed

        self.backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func config() {

    }
}

extension ConversationContentViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    ///TODO: work on footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }


    func tableView(tableView:UITableView, willDisplayHeaderView view:UIView, forSection section:Int) {
        if let headerView:Header = view as? Header {
            headerView.config()
        }
    }

    func tableView(tableView:UITableView, viewForFooterInSection section:Int) -> UIView? {
        var headerView:Header? = tableView.dequeueReusableHeaderFooterView(withIdentifier: Header.headerViewReuseIdentifier) as? Header
        if (headerView == nil) {
            headerView = Header(connectionViewController: self.connectionViewController!)

        }

        headerView?.backgroundColor = .green
        return headerView!
    }

    
    @objc func createConstraints() {
        constrain(self.view, tableView) { (selfView, tableView) in
            selfView.edges == tableView.edges
        }

    }

    @objc func createTableView() {
        tableView = UpsideDownTableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

//        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"SectionHeader"];

        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: Header.headerViewReuseIdentifier)
    }

    /// TODO: update
    @objc func createTableViewHeader() {
        // Don't display the conversation header if the message window doesn't include the first message.
        guard messageWindow.messages.count == conversation.messages.count else { return }


        let connectionOrOneOnOne = conversation.conversationType == .connection || conversation.conversationType == .oneOnOne

        guard connectionOrOneOnOne, let otherParticipant = conversation.firstActiveParticipantOtherThanSelf() else { return }

        if let session = ZMUserSession.shared() {
            connectionViewController = UserConnectionViewController(userSession: session, user: otherParticipant)
        }

        if let headerView = connectionViewController?.view {
            headerView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 20)
            headerView.translatesAutoresizingMaskIntoConstraints = false

            tableView.tableHeaderView = headerView
        }
    }

    func updateHeaderViewSize() {
        let fittingSize = CGSize(width: tableView.bounds.size.width, height: headerHeight())

            headerViewHeight?.constant = fittingSize.height
    }

    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = tableView.tableHeaderView else { return }

        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
//        let header = tableView.tableHeaderView
//        tableView.tableHeaderView = header
    }

}

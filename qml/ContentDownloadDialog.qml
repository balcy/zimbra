import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Content 0.1

PopupBase {
    id: downloadDialog
    anchors.fill: parent
    property var activeTransfer
    property var downloadId
    property alias contentType: peerPicker.contentType

    Rectangle {
        anchors.fill: parent
        ContentPeerPicker {
            id: peerPicker
            handler: ContentHandler.Destination
            visible: parent.visible

            onPeerSelected: {
                activeTransfer = peer.request()
                activeTransfer.downloadId = downloadDialog.downloadId
                activeTransfer.state = ContentTransfer.Downloading
                PopupUtils.close(downloadDialog)
            }

            onCancelPressed: {
                PopupUtils.close(downloadDialog)
            }
        }
    }
}

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Content 1.3
import "MimeTypeMapper.js" as MimeTypeMapper
import "."

Component {
    Popups.PopupBase {
        id: picker
        objectName: "contentPickerDialog"

        // Set the parent at construction time, instead of letting show()
        // set it later on, which for some reason results in the size of
        // the dialog not being updated.
        parent: QuickUtils.rootItem(this)

        property var activeTransfer

        Rectangle {
            anchors.fill: parent

            ContentTransferHint {
                anchors.fill: parent
                activeTransfer: picker.activeTransfer
            }

            ContentPeerPicker {
                id: peerPicker
                anchors.fill: parent
                visible: true
                contentType: ContentType.All
                handler: ContentHandler.Source

                onPeerSelected: {
                    if (model.allowMultipleFiles) {
                        peer.selectionType = ContentTransfer.Multiple
                    } else {
                        peer.selectionType = ContentTransfer.Single
                    }
                    picker.activeTransfer = peer.request()
                    stateChangeConnection.target = picker.activeTransfer
                }

                onCancelPressed: {
                    model.reject()
                }
            }
        }

        Connections {
            id: stateChangeConnection
            target: null
            onStateChanged: {
                if (picker.activeTransfer.state === ContentTransfer.Charged) {
                    var selectedItems = []
                    for(var i in picker.activeTransfer.items) {
                        selectedItems.push(String(picker.activeTransfer.items[i].url).replace("file://", ""))
                    }
                    model.accept(selectedItems)
                }
            }
        }

        Component.onCompleted: {
            if(acceptTypes.length === 1) {
                var contentType = MimeTypeMapper.mimeTypeToContentType(acceptTypes[0])
                if(contentType == ContentType.Unknown) {
                    // If we don't recognise the type, allow uploads from any app
                    contentType = ContentType.All
                }
                peerPicker.contentType = contentType
            } else {
                peerPicker.contentType = ContentType.All
            }
            show()
        }
    }
}


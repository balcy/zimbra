import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.1

Dialog {
            id: offlineDialog
            visible: false
            title: i18n.tr("Offline Mode")

            Text {
                wrapMode: Text.WordWrap
                text: i18n.tr('This is a work in progress for Offline Mode use into Zimbra Client !')
            }

            Button {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                color: UbuntuColors.green 
                text: i18n.tr('OK')
                onClicked: PopupUtils.close(offlineDialog)
            }
        }


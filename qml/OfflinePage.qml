import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.1

Dialog {
            id: offlineDialog
            visible: false
            title: i18n.tr("How to Enable Offline Mode on PC Client")

            Text {
                wrapMode: Text.WordWrap
                text: i18n.tr('If you use the Zimbra PC Web Client in Chrome or Firefox, you can work offline with access to one month of data!')
            }

            Text {
                wrapMode: Text.WordWrap
                text: i18n.tr('To enable Offline Mode:')
            }
 
            Text {
                wrapMode: Text.WordWrap
                text: i18n.tr('1. Open the user menu in the top right corner of the Zimbra Web Client, and select Offline Mode, as shown below.')
            }

            Image {
                anchors.horizontalCenter: parent     
                source: 'assets/offline_mode.png'
                fillMode: Image.PreserveAspectFit 
            }
        
            Text {
                wrapMode: Text.WordWrap
                text: i18n.tr('2. Select Allow offline mode, and click OK.')
            }

            Image {
                anchors.horizontalCenter: parent
                source: 'assets/offline_mode_box.png'
                fillMode: Image.PreserveAspectFit 
            }

            Text {
                wrapMode: Text.WordWrap
                text: i18n.tr('3. Click Yes.')
            }

            Image {
                anchors.horizontalCenter: parent
                source: 'assets/offline_mode_warning.png'
                fillMode: Image.PreserveAspectFit 
            }

            Text {
                wrapMode: Text.WordWrap
                text: i18n.tr('4. Done.')
            }

            Button {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                color: UbuntuColors.green 
                text: i18n.tr('OK')
                onClicked: PopupUtils.close(offlineDialog)
            }
        }


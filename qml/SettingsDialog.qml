import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: settings
    title: i18n.tr("Settings")
 TextField {
                        id: address
                        width: parent.width
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        placeholderText: i18n.tr("https://zimbra.ubports.com")
                      

                    }

    Button {
        text: i18n.tr("OK")
         onClicked: PopupUtils.close(settings)
    }
}

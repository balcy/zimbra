import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
            id: aboutDialog
            visible: false
            title: i18n.tr("About Zimbra Client v2.0")
            text: i18n.tr("This is a Zimbra Client for<br>Ubuntu Touch.")

            Text {
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: i18n.tr('Copyright (c) 2018 <br> by Rudi Timmermans  <br><br> E-Mail: <a href=\"mailto://rudi.timmer@mail.ch\">rudi.timmer@mail.ch</a>')
            }

            Button {
                text: i18n.tr('Donate')
                onClicked: Qt.openUrlExternally('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=29THE9VFMZ4PS')
             }

            Button {
                text: i18n.tr('OK')
                onClicked: PopupUtils.close(aboutDialog)
            }
        }

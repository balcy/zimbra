import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.1

Rectangle {
    property string url
    signal refreshClicked()

    Column {
        anchors.fill: parent
        anchors.margins: units.gu(4)

        spacing: units.gu(3)

        Label {
            width: parent.width
            fontSize: "x-large"
            text: i18n.tr("Network Error")
        }

        Label {
            width: parent.width
            text: i18n.tr("It appears you are having trouble connecting your Zimbra Server.")
            wrapMode: Text.Wrap
        }

        Label {
            width: parent.width
            text: i18n.tr("Please check your network settings and try reconnect to your Zimbra Server.")
            wrapMode: Text.Wrap
        }

        Button {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            color: UbuntuColors.orange
            text: i18n.tr("Reconnect")
            onClicked: refreshClicked()
        }
    }
}


import QtQuick 2.4
import Ubuntu.Components 1.3

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
            // TRANSLATORS: %1 refers to the URL of the current page
            text: i18n.tr("It appears you are having trouble viewing: %1.").arg(url)
            wrapMode: Text.Wrap
        }

        Label {
            width: parent.width
            text: i18n.tr("Please check your network settings and try refreshing the page.")
            wrapMode: Text.Wrap
        }

        Button {
            text: i18n.tr("Refresh page")
            onClicked: refreshClicked()
        }
    }
}

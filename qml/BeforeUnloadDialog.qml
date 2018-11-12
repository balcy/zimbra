import QtQuick 2.4
import Ubuntu.Components 1.3

ModalDialog {
    objectName: "beforeUnloadDialog"
    title: i18n.tr("Confirm Navigation")
    
    signal accept()
    signal reject()
    
    onAccept: hide()
    onReject: hide()

    Button {
        text: i18n.tr("Leave")
        color: theme.palette.normal.negative
        objectName: "leaveButton"
        onClicked: accept()
    }

    Button {
        objectName: "stayButton"
        text: i18n.tr("Stay")
        onClicked: reject()
    }
}

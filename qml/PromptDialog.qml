import QtQuick 2.4
import Ubuntu.Components 1.3

ModalDialog {
    objectName: "promptDialog"
    title: i18n.tr("JavaScript Prompt")
    
    property string defaultValue
    
    signal accept(string text)
    signal reject()
    
    onAccept: hide()
    onReject: hide()

    TextField {
        id: input
        objectName: "inputTextField"
        text: defaultValue
        onAccepted: accept(input.text)
    }

    Button {
        text: i18n.tr("OK")
        color: theme.palette.normal.positive
        objectName: "okButton"
        onClicked: accept(input.text)
    }

    Button {
        objectName: "cancelButton"
        text: i18n.tr("Cancel")
        onClicked: reject()
    }

    /*
    Binding {
        target: model
        property: "currentValue"
        value: input.text
    }
    */
}

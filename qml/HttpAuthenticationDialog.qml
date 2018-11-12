import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3 as Popups

Popups.Dialog {
    id: dialog
    title: i18n.tr("Authentication required.")
    // TRANSLATORS: %1 refers to the URL of the current website and %2 is a string that the website sends with more information about the authentication challenge (technically called "realm")
    text: (host && realm) ? i18n.tr("The website at %1 requires authentication. The website says \"%2\"").arg(this.host).arg(this.realm) : ""

    //property QtObject request: null
    
    property string host
    property string realm
    
    signal accept(string username, string password)
    signal reject()
    
    onAccept: PopupUtils.close(dialog)
    onReject: PopupUtils.close(dialog)

    /*
    Connections {
        target: request
        onCancelled: PopupUtils.close(dialog)
    }
    */

    TextField {
        id: usernameInput
        objectName: "username"
        placeholderText: i18n.tr("Username")
        onAccepted: accept(usernameInput.text, passwordInput.text)
    }

    TextField {
        id: passwordInput
        objectName: "password"
        placeholderText: i18n.tr("Password")
        echoMode: TextInput.Password
        onAccepted: accept(usernameInput.text, passwordInput.text)
    }

    Button {
        objectName: "allow"
        text: i18n.tr("OK")
        color: theme.palette.normal.positive
        onClicked: accept(usernameInput.text, passwordInput.text)
    }

    Button {
        objectName: "deny"
        text: i18n.tr("Cancel")
        onClicked: reject()
    }
}

import QtQuick 2.9
import Morph.Web 0.1
import QtWebEngine 1.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.UnityWebApps 0.1 as UnityWebApps
import Ubuntu.Content 1.1
import QtMultimedia 5.8
import QtSystemInfo 5.0
import QtQml.Models 2.1
import Qt.labs.settings 1.0
import Ubuntu.DownloadManager 1.2
import "components"
import "actions" as Actions
import "."

MainView {
    id: root
    objectName: "mainView"
    theme.name: "Ubuntu.Components.Themes.Ambiance"
    focus: true

    anchors {
        fill: parent
    }

    applicationName: "zimbra.webmail"
    anchorToKeyboard: true
    automaticOrientation: true
    property bool blockOpenExternalUrls: false
    property bool runningLocalApplication: false
    property bool openExternalUrlInOverlay: true
    property bool popupBlockerEnabled: true
    
    property string appVersion : "v3.0"

    property string myPattern: ""
    Settings {
        id: settings
        property string myUrl
    }

    //property string myUA: "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"
    property string myUA: "Mozilla/5.0 (iPhone; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.25 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"

    Timer {
        id: checkUrlTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            if (!settings.myUrl) {
                PopupUtils.open(settingsComponent, root, {url: settings.myUrl});
            }
        }
    }

    Component.onCompleted: {
        checkUrlTimer.start();
    }


    Page {
        id: page
        header: Rectangle {
            color: "#000000"
            width: parent.width
            height: units.dp(.5)
            z: 1
        }

        anchors {
            fill: parent
            bottom: parent.bottom
        }
                   
        WebEngineView {
            id: webview

            WebEngineProfile {
            id: webContext 

            property alias userAgent: webContext.httpUserAgent
            property alias dataPath: webContext.persistentStoragePath

            dataPath: dataLocation

            userAgent: myUA

            persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies

            }

            anchors {
                fill: parent
                right: parent.right
                bottom: parent.bottom
                margins: units.gu(0)
                bottomMargin: units.gu(0)
            }

                zoomFactor: 2.5
                url: settings.myUrl

            onFileDialogRequested: function(request) {

            switch (request.mode)
        {
            case FileDialogRequest.FileModeOpen:
                request.accepted = true;
                var fileDialogSingle = PopupUtils.open(Qt.resolvedUrl("ContentPickerDialog.qml"));
                fileDialogSingle.allowMultipleFiles = false;
                fileDialogSingle.accept.connect(request.dialogAccept);
                fileDialogSingle.reject.connect(request.dialogReject);
                break;

            case FileDialogRequest.FileModeOpenMultiple:
                request.accepted = true;
                var fileDialogMultiple = PopupUtils.open(Qt.resolvedUrl("ContentPickerDialog.qml"));
                fileDialogMultiple.allowMultipleFiles = true;
                fileDialogMultiple.accept.connect(request.dialogAccept);
                fileDialogMultiple.reject.connect(request.dialogReject);
                break;

            case FilealogRequest.FileModeUploadFolder:
            case FileDialogRequest.FileModeSave:
                request.accepted = false;
                break;
            }

        }

        onNewViewRequested: function(request) {
                Qt.openUrlExternally(request.requestedUrl);
            }

        Loader {
            anchors {
                fill: popupWebview
            }
            active: webProcessMonitor.crashed || (webProcessMonitor.killed && !popupWebview.currentWebview.loading)
            sourceComponent: SadPage {
                webview: popupWebview
                objectName: "overlaySadPage"
            }
            WebProcessMonitor {
                id: webProcessMonitor
                webview: popupWebview
            }
            asynchronous: true
          }
       }

   Loader {
        id: downloadsViewLoader

        anchors.fill: parent
        active: false
        asynchronous: true
        Component.onCompleted: {
            setSource("DownloadsPage.qml", {
                          "downloadManager": Qt.binding(function () {return downloadHandlerLoader.item}),
                          "incognito": incognito,
                          "focus": true
            })
        }

        Connections {
            target: downloadsViewLoader.item
            onDone: downloadsViewLoader.active = false
        }

        onStatusChanged: {
            if (status == Loader.Ready) {
                forceActiveFocus()
            } else {
                internal.resetFocus()
            }
        }
    }

            Loader {
                id: contentHandlerLoader
                source: "ContentHandler.qml"
                asynchronous: true
            }
         
            Loader {
                id: downloadLoader
                source: "Downloader.qml"
                asynchronous: true
            }
            
            Loader {
                id: filePickerLoader
                source: "ContentPickerDialog.qml"
                asynchronous: true
            }

            Loader {
                id: downloadDialogLoader
                source: "ContentDownloadDialog.qml"
                asynchronous: true
            }

    Component {
        id: settingsComponent

        Dialog {
            id: settingsDialog
            text: i18n.tr('Please, introduce the FQDN of your Zimbra server<br>(e.g. zimbra.example.com).')

            property alias url: address.text
            onVisibleChanged: {
                if (visible) {
                    address.forceActiveFocus();
                }
            }

            function saveUrl() {
                var url = address.text;
                if (url && url.substring(0, 7) != 'http://' && url.substring(0, 8) != 'https://') {
                    url = 'https://' + url;
                }

                address.focus = false
                settings.myUrl = url;
                webview.url = settings.myUrl;
                PopupUtils.close(settingsDialog);
            }

            TextField {
                id: address
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase

                onAccepted: settingsDialog.saveUrl()
            }

            Button {
                text: i18n.tr('OK')
                color: UbuntuColors.green

                onClicked: settingsDialog.saveUrl()
            }
        }
    }

     BottomMenu {
        id: bottomMenu
        width: parent.width
     }
   }
 }    

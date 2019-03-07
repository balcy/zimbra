import QtQuick 2.9
import Ubuntu.Web 0.2
import QtWebEngine 1.7
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3
import com.canonical.Oxide 1.19 as Oxide
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.1
import QtMultimedia 5.0
import QtFeedback 5.0
import Qt.labs.settings 1.0
import Ubuntu.Unity.Action 1.1 as UnityActions
import "components"
import "actions" as Actions
import "."
import DownloadInterceptor 1.0

MainView {
    id: root
    objectName: "mainView"
    theme.name: "Ubuntu.Components.Themes.Ambiance"

    anchors {
        fill: parent
    }

    applicationName: "zimbra.webmail"

    anchorToKeyboard: true
    automaticOrientation: true

    property string myPattern: ""
    Settings {
        id: settings
        property string myUrl
    }

    property string myUA: "Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36 Ubuntu Touch"

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

        HapticsEffect {
            id: vibration
            attackIntensity: 0.0
            attackTime: 50
            intensity: 1.0
            duration: 10
            fadeTime: 50
            fadeIntensity: 0.0
        }

        SoundEffect {
            id: clicksound
            source: "../sounds/Click.wav"
        }

        WebContext {
            id: webcontext
            userAgent: myUA
        }

        WebView {
            id: webview

            anchors {
                fill: parent
                right: parent.right
                bottom: parent.bottom
                margins: units.gu(0)
                bottomMargin: units.gu(6)
            }
            width: parent.width
            height: parent.height
            context: webcontext
            url: settings.myUrl        

            onDownloadRequested: {
                console.log('download requested', request.url.toString(), request.suggestedFilename);
                DownloadInterceptor.download(request.url, request.cookies, request.suggestedFilename, webcontext.userAgent);

                request.action = Oxide.NavigationRequest.ActionReject;
                PopupUtils.open(downloadingDialog, root.mainView, { "fileName" : request.suggestedFilename })
            }

            contextualActions: ActionList {

            Action {
             text: i18n.tr(webview.contextualData.href.toString())
                    enabled: contextualData.herf.toString()
              }

        Action {
            text: i18n.tr("Copy Link")
                   enabled: webview.contextualData.href.toString()

                   //contextualData.href.toString()
            onTriggered: Clipboard.push([webview.contextualData.href])
              }

               Action {
                  text: i18n.tr("Share Link")
                  enabled: webview.contextualData.href.toString()
                  onTriggered: {
                      var component = Qt.createComponent("Share.qml")
                      console.log("component..."+component.status)
                      if (component.status == Component.Ready) {
                          var share = component.createObject(webview)
                          share.onDone.connect(share.destroy)
                          share.shareLink(webview.contextualData.href.toString(), webview.contextualData.title)
                      } else {
                          console.log(component.errorString())
                      }
                  }
                  }

               Action {
                  text: i18n.tr("Copy Image")
                  enabled: webview.contextualData.img.toString()
                  onTriggered: Clipboard.push([webview.contextualData.img])
               }

               Action {
                   text: i18n.tr("Download Image")
                   enabled: webview.contextualData.img.toString() && downloadLoader.status == Loader.Ready
                   onTriggered: downloadLoader.item.downloadPicture(webview.contextualData.img)
               }
            }

	    Component {
                id: downloadingDialog

                DownloadingDialog {
                    anchors.fill: parent
                }
            }

            Component {
                id: customDieDialogComponent

                CustomDieDialog {
                    id: customDieDialog
                }
            }

            function navigationRequestedDelegate(request) {
                var url = request.url.toString();

                if (Conf.hapticLinks) {
                    vibration.start()
                }

                if (Conf.audibleLinks) {
                    clicksound.play()
                }

                if(isValid(url) == false) {
                    console.warn("Opening remote: " + url);
                    PopupUtils.open(customDieDialogComponent, url)
                    request.action = Oxide.NavigationRequest.ActionReject
                 }
            }

            Component.onCompleted: {

                preferences.localStorageEnabled = true
                preferences.pluginsEnabled = true
                preferences.offlineWebApplicationCacheEnabled = true
                preferences.allowFileAccessFromFileUrls = true
                preferences.allowUniversalAccessFromFileUrls = true
                preferences.javascriptCanAccessClipboard = true
                preferences.javaEnabled = true

                if (Qt.application.arguments[2] != undefined ) {
                    console.warn("got argument: " + Qt.application.arguments[1])
                    if(isValid(Qt.application.arguments[1]) == true) {
                        url = Qt.application.arguments[1]
                    }
                }

                console.warn("url is: " + url)
            }

            onGeolocationPermissionRequested: { request.accept() }

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
            
            filePicker: pickerComponent
            
        Loader {
                anchors {
                    fill: webview

                }
                active: webview &&
                        (webProcessMonitor.crashed || (webProcessMonitor.killed && !webview.loading))
                sourceComponent: SadPage {
                    webview: webview
                    objectName: "webviewSadPage"
                }

                WebProcessMonitor {
                    id: webProcessMonitor
                    webview: webview
                }
                asynchronous: true
            }
                Loader {
            anchors {
                fill: webview

            }

            asynchronous: true
            }            

            function isValid (url){
                var pattern = myPattern.split(',');
                for (var i=0; i<pattern.length; i++) {
                    var tmpsearch = pattern[i].replace(/\*/g,'(.*)')
                    var search = tmpsearch.replace(/^https\?:\/\//g, '(http|https):\/\/');
                    if (url.match(search)) {
                       return true;
                    }
                }
                return false;
            }
        }

        NewProgressBar {
            webview: webview
            width: parent.width + units.gu(5)
            z: 2
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
            }
        }
        
    Component {
        id: openDialogComponent

        OpenDialog {
            anchors.fill: parent
     }
   }      
        
    Component {
        id: pickerComponent
        PickerDialog {}
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
                    url = 'https://' + url + '/m';
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
              
    Connections {
        target: Qt.inputMethod
        onVisibleChanged: nav.visible = !nav.visible
    }
        Connections {
        target: webview
        onFullscreenRequested: webview.fullscreen = fullscreen

        onFullscreenChanged: {
                nav.visible = !webview.fullscreen
                if (webview.fullscreen == true) {
                    window.visibility = 5
                } else {
                    window.visibility = 4
                }
            }
    }
    Connections {
        target: UriHandler
        onOpened: {
            if (uris.length === 0 ) {
                return;
            }
            webview.url = uris[0]
            console.warn("uri-handler request")
        }
    }
}

    BottomMenu {
        id: bottomMenu
        width: parent.width
    }

    Connections {
        target: DownloadInterceptor
        onSuccess: {
            PopupUtils.open(openDialogComponent, root, {'path': path});
        }

        onFail: {
            PopupUtils.open(downloadFailedComponent, root, {'text': message});
        }
    }
 }

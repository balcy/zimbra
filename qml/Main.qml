import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.3
import com.canonical.Oxide 1.19 as Oxide
import Ubuntu.Components.Popups 1.3
import "UCSComponents"
import Ubuntu.Content 1.1
import "actions" as Actions
import QtMultimedia 5.0
import QtFeedback 5.0
import Ubuntu.Unity.Action 1.1 as UnityActions
import "."
import "config.js" as Conf
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

    property string myUrl: Conf.webappUrl
    property string myPattern: Conf.webappUrlPattern
    property url webviewOverrideFile: Qt.resolvedUrl("WebViewImplOxide.qml")

    property string myUA: Conf.webappUA ? Conf.webappUA : "Mozilla/5.0 (Linux; Android 4.4.4; One Build/KTU84L.H4) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari537.36"

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
            userScripts: [
                Oxide.UserScript {
                    context: 'oxide://main-world'
                    emulateGreasemonkey: true
                    url: Qt.resolvedUrl('userscripts/injectcss.js')
                }
            ]
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
            url: myUrl

            preferences.localStorageEnabled: true
            preferences.allowFileAccessFromFileUrls: true
            preferences.allowUniversalAccessFromFileUrls: true
            preferences.appCacheEnabled: true
            preferences.javascriptCanAccessClipboard: true        

            onDownloadRequested: {
                console.log('download requested', request.url.toString(), request.suggestedFilename);
                DownloadInterceptor.download(request.url, request.cookies, request.suggestedFilename, webcontext.userAgent);

                request.action = Oxide.NavigationRequest.ActionReject;
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
            sourceComponent: ErrorSheet {
                visible: webview && webview.lastLoadFailed
                url: webview ? webview.url : ""
                onRefreshClicked: {
                    if (webview)
                        webview.reload()
                }
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

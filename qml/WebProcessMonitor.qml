import QtQuick 2.4
import com.canonical.Oxide 1.8 as Oxide

Item {
    id: monitor

    visible: false

    property var webview: null

    readonly property bool killed: webview &&
                                   (webview.webProcessStatus == Oxide.WebView.WebProcessKilled)
    readonly property bool crashed: webview &&
                                    (webview.webProcessStatus == Oxide.WebView.WebProcessCrashed)

    // When the renderer process is killed (most likely by the system’s
    // OOM killer), try to reload the page once, and if this results in
    // the process being killed again within one minute, then display
    // the sad tab.

    readonly property int killedRetries: internal.killedRetries

    QtObject {
        id: internal
        property int killedRetries: 0
    }

    Connections {
        target: webview
        onWebProcessStatusChanged: {
            if (webview.webProcessStatus == Oxide.WebView.WebProcessKilled) {
                if (internal.killedRetries == 0) {
                    // Do not attempt reloading right away, this would result in a crash
                    delayedReload.restart()
                }
            }
        }
    }

    Timer {
        id: delayedReload
        interval: 100
        onTriggered: {
            monitorTimer.restart()
            monitor.webview.reload()
            internal.killedRetries++
        }
    }

    Timer {
        id: monitorTimer
        interval: 60000 // 1 minute
        onTriggered: internal.killedRetries = 0
    }

    onWebviewChanged: {
        internal.killedRetries = 0
        delayedReload.stop()
        monitorTimer.stop()
    }
}

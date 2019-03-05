import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: bottomMenu
    z: 100000
    width: parent.width
    height: units.gu(6)
    color: "#000000"
    anchors {
        bottom: parent.bottom
    }

    Rectangle {
        width: parent.width
        height: units.gu(0.1)
        color: UbuntuColors.lightGrey
    }

    Row {
        width: parent.width
        height: parent.height-units.gu(0.2)
        anchors {
            centerIn: parent
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.9)
                height: width
                name: "home"
                color: "#FFFFFF"
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = settings.myUrl;
                }
            }
        } 

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "reload"
                color: "#FFFFFF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.reload()
                }
            }
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.9)
                height: width
                name: "switch"
                color: "#FFFFFF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                  PopupUtils.open(Qt.resolvedUrl("../OfflinePage.qml") 
               )
             }
           }
         }    
        
        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.9)
                height: width
                name: "settings"
                color: "#FFFFFF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    PopupUtils.open(settingsComponent, root, {url: settings.myUrl});
                }
            }
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.9)
                height: width
                name: "info"
                color: "#FFFFFF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    PopupUtils.open(Qt.resolvedUrl("../AboutPage.qml")
                    )
                }
            }
        }
    }
}



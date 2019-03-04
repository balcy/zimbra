TEMPLATE = app
TARGET = gmail

load(ubuntu-click)

QT += qml quick

SOURCES += main.cpp

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  gmail.apparmor \
               img/icon.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               gmail.desktop

#specify where the config files are installed to
config_files.path = /gmail
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /gmail
desktop_file.files = $$OUT_PWD/gmail.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

DISTFILES += \
qml/UCSComponents/EmptyState.qml \
qml/UCSComponents/RadialAction.qml \
qml/UCSComponents/RadialBottomEdge.qml \
qml/UCSComponents/BottomMenu.qml \
qml/Main.qml \
qml/actions/Copy.qml \
qml/actions/CopyImage.qml \
qml/actions/CopyLink.qml \
qml/actions/SaveImage.qml \
qml/actions/ShareLink.qml \
qml/MimeTypeMapper.js \
qml/Downloader.qml \
qml/FileExtensionMapper.js \
qml/ContentDownloadDialog.qml \
qml/DownloadingDialog.qml \
qml/ContentShareDialog.qml \
qml/Share.qml \
qml/PickerDialog.qml \
qml/OpenDialog.qml \
qml/ContentPickerDialog \
qml/ErrorSheet.qml \
qml/SadPage.qml \
qml/WebProcessMonitor.qml \
qml/config.js \
qml/userscripts/injectcss.js \
qml/AboutPage.qml \
qml/OfflinePage.qml

// Includes relevant modules used by the QML
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami

// Provides basic features needed for all kirigami applications
Kirigami.ApplicationWindow {
    // Unique identifier to reference this object
    id: root

    // Window title
    // i18nc() makes a string translatable
    // and provides additional context for the translators
    title: i18nc("@title:window", "Test Kountdown")

    globalDrawer: Kirigami.GlobalDrawer {
        isMenu: true
        actions: [
            Kirigami.Action {
                text: i18n("Quit")
                icon.name: "gtk-quit"
                shortcut: StandardKey.Quit
                onTriggered: Qt.quit()
            }
        ]
    }
    
    // Set the first page that will be loaded when the app opens
    // This can also be set to an id of a Kirigami.Page
    pageStack.initialPage: Kirigami.ScrollablePage {
        title: i18nc("@title", "Kountdown")
        
        actions.main: Kirigami.Action{
            id: addAction
            icon.name: "list-add"
            text: i18nc("@action:button", "Add Kountdown")
            onTriggered: addSheet.open()
        }
        
        Kirigami.CardsListView{
            id: kountdownList
            model: kountdownlistmodel
            delegate: kountdowndelegate
        }

        ListModel{
            id: kountdownlistmodel
            ListElement{
                name: "Un titre sympa"
                description: "Une petite description sympa"
                date: 100
            }
        }

        Kirigami.OverlaySheet {
            id: addSheet
            header: Kirigami.Heading {
                text: i18nc("@title:window", "Add kountdown")
            }
            Kirigami.FormLayout {
                Controls.TextField {
                    id: nameField
                    Kirigami.FormData.label: i18nc("@label:textbox", "Name:")
                    placeholderText: i18n("Event name (required)")
                    onAccepted: descriptionField.forceActiveFocus()
                }
                Controls.TextField {
                    id: descriptionField
                    Kirigami.FormData.label: i18nc("@label:textbox", "Description:")
                    placeholderText: i18n("Optional")
                    onAccepted: dateField.forceActiveFocus()
                }
                Controls.TextField {
                    id: dateField
                    Kirigami.FormData.label: i18nc("@label:textbox", "Date:")
                    placeholderText: i18n("YYYY-MM-DD")
                    inputMask: "0000-00-00"
                }
                Controls.Button {
                    id: doneButton
                    Layout.fillWidth: true
                    text: i18nc("@action:button", "Done")
                    enabled: nameField.text.length > 0
                    onClicked: {
                        kountdownlistmodel.append({
                            name: nameField.text,
                            description: descriptionField.text,
                            // The parse() method parses a string and returns the number of milliseconds
                            // since January 1, 1970, 00:00:00 UTC.
                            date: Date.parse(dateField.text)
                        });
                        nameField.text = ""
                        descriptionField.text = ""
                        dateField.text = ""
                        addSheet.close();
                    }
                }
            }
        }
        
        Component{
            id: "kountdowndelegate"
            Kirigami.AbstractCard {
                contentItem: Item{
                    implicitWidth: delegateLayout.implicitWidth
                    implicitHeight: delegateLayout.implicitHeight
                    GridLayout{
                        id: delegateLayout
                        anchors {
                            left: parent.left
                            top: parent.top
                            right: parent.right
                        }
                        rowSpacing: Kirigami.Units.largeSpacing
                        columnSpacing: Kirigami.Units.largeSpacing
                        columns: root.wideScreen ? 4 : 2
                        
                        Kirigami.Heading{
                            Layout.fillHeight: true
                            level: 1
                            text: (date < 100000) ? date : i18n("%1 days", Math.round((date-Date.now())/86400000))
                        }
                        
                        ColumnLayout {
                            Kirigami.Heading {
                                Layout.fillWidth: true
                                level: 2
                                text: name
                            }
                            Kirigami.Separator {
                                Layout.fillWidth: true
                                visible: description.length > 0
                            }
                            Controls.Label {
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                text: description

                            }
                        }

                        Controls.Button {
                            Layout.alignment: Qt.AlignRight
                            Layout.columnSpan: 2
                            text: i18n("Edit")
                            // onClicked: to be done... soon!
                        }
                    }
                }
            }
        }
    }
}

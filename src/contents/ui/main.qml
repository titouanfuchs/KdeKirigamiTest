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

    // Set the first page that will be loaded when the app opens
    // This can also be set to an id of a Kirigami.Page
    pageStack.initialPage: Kirigami.ScrollablePage {
        title: i18nc("@title", "Kountdown")
        
        actions.main: Kirigami.Action{
            id: addAction
            icon.name: "list-add"
            text: i18nc("@action:button", "Add Kountdown")
            onTriggered: kountdownlistmodel.append({
                name: "Kirigami action card Added !",
                description: "It just work!",
                date: 200
            })
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

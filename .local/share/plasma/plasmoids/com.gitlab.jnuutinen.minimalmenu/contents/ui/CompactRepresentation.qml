/*
*  Copyright 2018 Juha Nuutinen <juha.nuutinen@protonmail.com>
*
*  This file is a part of Minimal Menu.
*  Minimal Menu is forked from Simple menu (https://github.com/KDE/plasma-simplemenu)
*
*  Takeoff is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Takeoff is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    readonly property var screenGeometry: plasmoid.screenGeometry
    readonly property bool inPanel: (plasmoid.location === PlasmaCore.Types.TopEdge
        || plasmoid.location === PlasmaCore.Types.RightEdge
        || plasmoid.location === PlasmaCore.Types.BottomEdge
        || plasmoid.location === PlasmaCore.Types.LeftEdge)
    readonly property bool vertical: (plasmoid.formFactor === PlasmaCore.Types.Vertical)
    readonly property bool useCustomButtonImage: (plasmoid.configuration.useCustomButtonImage
        && plasmoid.configuration.customButtonImage.length !== 0)
    property QtObject dashWindow: null

    Plasmoid.status: dashWindow && dashWindow.visible ? PlasmaCore.Types.RequiresAttentionStatus : PlasmaCore.Types.PassiveStatus

    onWidthChanged: updateSizeHints()
    onHeightChanged: updateSizeHints()

    function updateSizeHints() {
        if (useCustomButtonImage) {
            if (vertical) {
                var scaledHeight = Math.floor(parent.width * (buttonIcon.implicitHeight / buttonIcon.implicitWidth));
                root.Layout.minimumHeight = scaledHeight;
                root.Layout.maximumHeight = scaledHeight;
                root.Layout.minimumWidth = units.iconSizes.small;
                root.Layout.maximumWidth = inPanel ? units.iconSizeHints.panel : -1;
            } else {
                var scaledWidth = Math.floor(parent.height * (buttonIcon.implicitWidth / buttonIcon.implicitHeight));
                root.Layout.minimumWidth = scaledWidth;
                root.Layout.maximumWidth = scaledWidth;
                root.Layout.minimumHeight = units.iconSizes.small;
                root.Layout.maximumHeight = inPanel ? units.iconSizeHints.panel : -1;
            }
        } else {
            root.Layout.minimumWidth = units.iconSizes.small;
            root.Layout.maximumWidth = inPanel ? units.iconSizeHints.panel : -1;
            root.Layout.minimumHeight = units.iconSizes.small
            root.Layout.maximumHeight = inPanel ? units.iconSizeHints.panel : -1;
        }
    }

    Connections {
        target: units.iconSizeHints

        onPanelChanged: updateSizeHints()
    }

    PlasmaCore.IconItem {
        id: buttonIcon

        anchors.fill: parent

        readonly property double aspectRatio: (vertical ? implicitHeight / implicitWidth
            : implicitWidth / implicitHeight)

        source: useCustomButtonImage ? plasmoid.configuration.customButtonImage : plasmoid.configuration.icon

        active: mouseArea.containsMouse

        roundToIconSize: !useCustomButtonImage

        onSourceChanged: updateSizeHints()
    }

    MouseArea
    {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true

        onClicked: {
            dashWindow.visible = !dashWindow.visible;
        }
    }

    Component.onCompleted: {
        dashWindow = Qt.createQmlObject("MenuRepresentation {}", root);
        plasmoid.activated.connect(function() {
            dashWindow.visible = !dashWindow.visible;
        });
    }
}

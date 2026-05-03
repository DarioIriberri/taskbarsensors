/*
    SPDX-FileCopyrightText: 2019 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2019 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2019 Arjen Hiemstra <ahiemstra@heimr.nl>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import org.kde.ksysguard.sensors as Sensors
import org.kde.ksysguard.faces as Faces
import org.kde.ksysguard.formatter as Formatter

import org.kde.quickcharts as Charts
import org.kde.quickcharts.controls as ChartsControls


Faces.CompactSensorFace {
    id: root

    Layout.minimumWidth: horizontalFormFactor ? Math.max(contentItem.Layout.minimumWidth, defaultMinimumSize) : defaultMinimumSize
    Layout.minimumHeight: verticalFormFactor ? Math.max(contentItem.Layout.minimumHeight, defaultMinimumSize) : defaultMinimumSize
    // Layout.preferredWidth: 30
    Layout.maximumWidth: horizontalFormFactor ? Math.max(contentItem.preferredWidth, defaultMinimumSize) : -1
    Layout.preferredWidth: fixedSize ? (horizontalFormFactor ? height : 30) : widgetWidth
    Layout.preferredHeight: verticalFormFactor ? width : 30

    FontMetrics {
        id: defaultMetrics
        font: Kirigami.Theme.defaultFont
    }

    FontMetrics {
        id: smallMetrics
        font: Kirigami.Theme.smallFont
    }

    readonly property bool useSmallFont: (horizontalFormFactor && height < defaultMetrics.lineSpacing + 2) || (verticalFormFactor && width < defaultMetrics.averageCharacterWidth * 6 + Kirigami.Units.smallSpacing)
    readonly property real lineHeight: useSmallFont ? smallMetrics.lineSpacing : defaultMetrics.lineSpacing
    readonly property string fontFamily: root.controller.faceConfiguration.fontFamily
    readonly property int fontSize: root.controller.faceConfiguration.fontSize
    readonly property bool isBold: root.controller.faceConfiguration.isBold
    readonly property bool useColorGradient: root.controller.faceConfiguration.useColorGradient
    readonly property string solidColor: root.controller.faceConfiguration.solidColor
    readonly property string bkgColor: root.controller.faceConfiguration.bkgColor
    readonly property int redTemp: root.controller.faceConfiguration.redTemp
    readonly property int greenTemp: root.controller.faceConfiguration.greenTemp
    readonly property bool fixedSize: root.controller.faceConfiguration.fixedSize
    readonly property int widgetWidth: root.controller.faceConfiguration.widgetWidth
    readonly property int cornerRadius: root.controller.faceConfiguration.cornerRadius

    clip: true

    contentItem: Rectangle {
        color: root.bkgColor
        implicitWidth: maxTempLabel.implicitWidth + 20
        implicitHeight: maxTempLabel.implicitHeight + 10
        radius: root.cornerRadius
        Text {
            id: maxTempLabel
            anchors.fill: parent
            font.pixelSize: {
                let effectiveSize = root.fontSize === 0 ? parent.height * 0.8 : root.fontSize;
                let finalSize = (Math.round(currentHigh) >= 100 && sensorIsPercentage && root.fixedSize) ? effectiveSize * 0.8 : effectiveSize;
                
                return finalSize;
            }
            font.bold: root.isBold
            font.family: root.fontFamily
            //style: Text.Outline
            //styleColor: "#40FFFFFF" // Or a very dark version of the current color
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            
            property int mAXCOLOR : root.redTemp  
            property int mIDCOLOR : (root.redTemp + root.greenTemp) / 2
            property int mINCOLOR : root.greenTemp
            property real currentHigh: 0
            property bool sensorIsPercentage: false
            property bool sensorIsTemerature: false
            
            color: root.useColorGradient ? (currentHigh >= mIDCOLOR ? getGreen(currentHigh) : getRed(currentHigh)) : root.solidColor

            Instantiator {
                id: sensorFactory
                model: root.controller.highPrioritySensorIds
                
                delegate: Sensors.Sensor {
                    sensorId: modelData
                    updateRateLimit: root.controller.updateRateLimit
                    onValueChanged: maxTempLabel.requestUpdate()
                    
                    Component.onCompleted: {
                        // THIS IS THE ONLY TIME THE STRING CHECK RUNS
                        let id = sensorId.toLowerCase();
                        maxTempLabel.sensorIsPercentage = id.includes("percentage") || id.includes("usage")
                        maxTempLabel.sensorIsTemerature = id.includes("temperature")
                        
                        console.log("!!!!!!!!!!!!!!!!!!!! ************ sensorId ************: " + sensorId)
                        console.log("!!!!!!!!!!!!!!!!!!!! ************ sensorIsPercentage ************: " + maxTempLabel.sensorIsPercentage)
                        console.log("!!!!!!!!!!!!!!!!!!!! ************ sensorIsTemerature ************: " + maxTempLabel.sensorIsTemerature)
                    }
                }
            }

            function requestUpdate() {
                // console.log("!!!!!!!!!!!!!!!!!!!! ************ default ************: " + Kirigami.Theme.defaultFont)
                // console.log("!!!!!!!!!!!!!!!!!!!! ************************: " + root.fontFamily)
                let high = 0;
                for (let i = 0; i < sensorFactory.count; ++i) {
                    let s = sensorFactory.objectAt(i);
                    if (s && s.value > high) {
                        high = s.value;
                    }
                }
                maxTempLabel.currentHigh = high;
                text = high > 0 ? Math.round(high) : "...";
            }
            
            function getRed(temperature) {
                var val = temperature - mINCOLOR
                val = Math.max(0, val)
                val = Math.min(mIDCOLOR - mINCOLOR, val)
                var factor = Math.round(( val / (mIDCOLOR - mINCOLOR) ) * 255)
                var factorHex = factor.toString(16)
                factorHex = factorHex.length == 1 ? '0' + factorHex : factorHex
                return '#FF' + factorHex + 'FF00'
            }
            
            function getGreen(temperature) {
                var val = mAXCOLOR - temperature
                val = Math.max(0, val)
                val = Math.min(mAXCOLOR - mIDCOLOR, val)
                var factor = Math.round(( val / (mAXCOLOR - mIDCOLOR) ) * 255)
                var factorHex = factor.toString(16)
                factorHex = factorHex.length == 1 ? '0' + factorHex : factorHex
                return '#FFFF' + factorHex + '00'
            }

            text: "..."
        }
    }
}

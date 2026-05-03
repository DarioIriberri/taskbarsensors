/*
    SPDX-FileCopyrightText: 2019 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kquickcontrols as KQuickControls

import org.kde.kirigami as Kirigami

import org.kde.ksysguard.sensors as Sensors
import org.kde.ksysguard.faces as Faces

Kirigami.FormLayout {
    id: root
        
    property string cfg_fontFamily
    property alias cfg_fontSize: fontSize.value
    property alias cfg_isBold: boldCheckbox.checked
    property alias cfg_useColorGradient: useColorGradientCheckbox.checked
    property alias cfg_solidColor: solidColor.color
    property alias cfg_bkgColor: bkgColor.color
    property alias cfg_redTemp: redTemp.value     
    property alias cfg_greenTemp: greenTemp.value
    property alias cfg_fixedSize: fixedSize.checked
    property alias cfg_widgetWidth: widgetWidth.value
    property alias cfg_cornerRadius: cornerRadius.value
    
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Font Settings")
    }
    
    QQC2.ComboBox {
        id: fontSelector
        Kirigami.FormData.label: "Font Family:"
        
        model: Qt.fontFamilies()
        
        currentIndex: model.indexOf(root.cfg_fontFamily)
        onActivated: root.cfg_fontFamily = currentText
    }
    
    QQC2.SpinBox {
        id: fontSize
        Kirigami.FormData.label: i18nc("@label:spinbox", "Font Size (0 = autofill):")
        editable: true
        from: 0
        to: 100
    }
    QQC2.CheckBox {
        id: boldCheckbox
        Kirigami.FormData.label: "Bold Text:"
    }
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Color Settings")
    }
    QQC2.CheckBox {
        id: useColorGradientCheckbox
        Kirigami.FormData.label: "Use Color Gradient:"
    }
    KQuickControls.ColorButton {
        id: solidColor
        Kirigami.FormData.label: "Pick Text Color:"
        enabled: !useColorGradientCheckbox.checked
        showAlphaChannel: true
    }
    KQuickControls.ColorButton {
        id: bkgColor
        Kirigami.FormData.label: "Pick Background Color:"
        showAlphaChannel: true
    }
    QQC2.SpinBox {
        id: redTemp
        Kirigami.FormData.label: i18nc("@label:spinbox", "Red Value:")
        enabled: useColorGradientCheckbox.checked
        editable: true
        from: 0
        to: 100
    }
    QQC2.SpinBox {
        id: greenTemp
        Kirigami.FormData.label: i18nc("@label:spinbox", "Green Value:")
        enabled: useColorGradientCheckbox.checked
        editable: true
        from: 0
        to: 100
    }
    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Miscellaneous Settings")
    }
    QQC2.CheckBox {
        id: fixedSize
        Kirigami.FormData.label: "Fixed Size:"
    }
    QQC2.SpinBox {
        id: widgetWidth
        Kirigami.FormData.label: i18nc("@label:spinbox", "Width in Pixels:")
        enabled: !fixedSize.checked
        editable: true
        from: 5
        to: 1000
    }
    QQC2.SpinBox {
        id: cornerRadius
        Kirigami.FormData.label: i18nc("@label:spinbox", "Rounded Corners Radius:")
        editable: true
        from: 0
        to: 100
    }
}


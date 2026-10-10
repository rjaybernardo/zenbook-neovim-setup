import QtQuick
import QtQuick.Effects

// Idle: wallpaper + big clock. Any key or click: the wallpaper blurs and the
// sign-in form fades in. Typing goes straight into the password field.
Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1b325b"

    readonly property string fontFamily: config.font || "Adwaita Sans"
    readonly property color accent: config.accent || "#f2c4b0"
    readonly property color glass: Qt.rgba(1, 1, 1, 0.14)
    readonly property color glassBorder: Qt.rgba(1, 1, 1, 0.28)

    property bool active: false
    property string userName: userModel.lastUser
    property string realName: ""
    property int sessionIndex: sessionModel.lastIndex
    property var sessionNames: []
    property bool busy: false

    function wake() {
        active = true
        idleTimer.restart()
        password.forceActiveFocus()
    }

    function doLogin() {
        if (busy || password.text.length === 0)
            return
        busy = true
        errorText.text = ""
        sddm.login(userName, password.text, sessionIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            root.busy = false
            password.text = ""
            errorText.text = "Wrong password"
            shake.restart()
            password.forceActiveFocus()
        }
        function onLoginSucceeded() {
            root.busy = false
        }
    }

    // Collect user and session names from the models.
    Repeater {
        model: userModel
        delegate: Item {
            Component.onCompleted: {
                if (model.name === root.userName)
                    root.realName = model.realName || model.name
            }
        }
    }
    Repeater {
        model: sessionModel
        delegate: Item {
            Component.onCompleted: {
                var names = root.sessionNames.slice()
                names[index] = model.name
                root.sessionNames = names
            }
        }
    }

    Timer {
        id: idleTimer
        interval: 45000
        onTriggered: {
            if (password.text.length === 0 && !root.busy)
                root.active = false
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            clock.text = Qt.formatTime(now, config.clockFormat || "h:mm")
            date.text = Qt.formatDate(now, config.dateFormat || "dddd, MMMM d")
        }
    }

    // ── Background ────────────────────────────────────────────────
    Image {
        id: wallpaper
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
        cache: true
        smooth: true
    }

    MultiEffect {
        anchors.fill: wallpaper
        source: wallpaper
        blurEnabled: true
        blurMax: 64
        blur: 1.0
        saturation: 0.1
        opacity: root.active ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, root.active ? 0.22 : 0.0) }
            GradientStop { position: 1.0; color: Qt.rgba(0.04, 0.07, 0.16, root.active ? 0.45 : 0.25) }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: false
        onClicked: root.wake()
    }

    // ── Clock ─────────────────────────────────────────────────────
    Column {
        id: clockColumn
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.active ? parent.height * 0.12 : parent.height * 0.22
        spacing: 0
        Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

        Text {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.family: root.fontFamily
            font.pixelSize: root.active ? 96 : 140
            font.weight: Font.Light
            Behavior on font.pixelSize { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            style: Text.Raised
            styleColor: Qt.rgba(0, 0, 0, 0.12)
        }
        Text {
            id: date
            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.rgba(1, 1, 1, 0.9)
            font.family: root.fontFamily
            font.pixelSize: 22
            font.weight: Font.Medium
            style: Text.Raised
            styleColor: Qt.rgba(0, 0, 0, 0.12)
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 56
        text: "Press any key to sign in"
        color: Qt.rgba(1, 1, 1, 0.75)
        font.family: root.fontFamily
        font.pixelSize: 15
        opacity: root.active ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }

    // ── Sign-in form ──────────────────────────────────────────────
    Column {
        id: form
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: root.active ? 70 : 100
        spacing: 18
        opacity: root.active ? 1 : 0
        enabled: root.active
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        Behavior on anchors.verticalCenterOffset { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 104
            height: 104
            radius: width / 2
            color: root.glass
            border.color: root.glassBorder
            border.width: 1
            Text {
                anchors.centerIn: parent
                text: (root.realName || root.userName || "?").charAt(0).toUpperCase()
                color: "white"
                font.family: root.fontFamily
                font.pixelSize: 44
                font.weight: Font.Normal
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.realName || root.userName
            color: "white"
            font.family: root.fontFamily
            font.pixelSize: 24
            font.weight: Font.DemiBold
        }

        Item { width: 1; height: 4 }

        Rectangle {
            id: field
            anchors.horizontalCenter: parent.horizontalCenter
            width: 320
            height: 48
            radius: height / 2
            color: root.glass
            border.width: password.activeFocus ? 1.5 : 1
            border.color: password.activeFocus ? root.accent : root.glassBorder
            Behavior on border.color { ColorAnimation { duration: 150 } }

            SequentialAnimation {
                id: shake
                NumberAnimation { target: field; property: "anchors.horizontalCenterOffset"; to: -12; duration: 50 }
                NumberAnimation { target: field; property: "anchors.horizontalCenterOffset"; to: 12; duration: 70 }
                NumberAnimation { target: field; property: "anchors.horizontalCenterOffset"; to: -8; duration: 60 }
                NumberAnimation { target: field; property: "anchors.horizontalCenterOffset"; to: 6; duration: 60 }
                NumberAnimation { target: field; property: "anchors.horizontalCenterOffset"; to: 0; duration: 50 }
            }

            TextInput {
                id: password
                anchors.left: parent.left
                anchors.right: submit.left
                anchors.leftMargin: 22
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                echoMode: TextInput.Password
                passwordCharacter: "●"
                passwordMaskDelay: 0
                color: "white"
                selectionColor: root.accent
                font.family: root.fontFamily
                font.pixelSize: 16
                font.letterSpacing: 2
                clip: true
                focus: true
                enabled: !root.busy
                cursorDelegate: Rectangle {
                    width: 2
                    color: root.accent
                    visible: password.activeFocus
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: password.activeFocus
                        NumberAnimation { to: 0; duration: 500 }
                        NumberAnimation { to: 1; duration: 500 }
                    }
                }

                onTextChanged: {
                    if (text.length > 0) {
                        root.wake()
                        errorText.text = ""
                    }
                }
                onAccepted: root.doLogin()
                Keys.onEscapePressed: {
                    text = ""
                    root.active = false
                }
                Keys.onPressed: function (event) {
                    if (!root.active)
                        root.wake()
                    event.accepted = false
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Password"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.family: root.fontFamily
                    font.pixelSize: 16
                    visible: password.text.length === 0
                }
            }

            Rectangle {
                id: submit
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                radius: 18
                color: submitArea.containsMouse || password.text.length > 0
                       ? Qt.rgba(1, 1, 1, 0.26) : Qt.rgba(1, 1, 1, 0.1)
                Behavior on color { ColorAnimation { duration: 150 } }
                Image {
                    anchors.centerIn: parent
                    source: "icons/arrow.svg"
                    sourceSize: Qt.size(18, 18)
                    opacity: root.busy ? 0.4 : 1
                }
                MouseArea {
                    id: submitArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.doLogin()
                }
            }
        }

        Text {
            id: errorText
            anchors.horizontalCenter: parent.horizontalCenter
            height: 20
            color: root.accent
            font.family: root.fontFamily
            font.pixelSize: 14
            font.weight: Font.Medium
            text: ""
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Caps Lock is on"
            color: Qt.rgba(1, 1, 1, 0.8)
            font.family: root.fontFamily
            font.pixelSize: 13
            opacity: keyboard.capsLock ? 1 : 0
        }
    }

    // ── Bottom bar: session + power ───────────────────────────────
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 32
        spacing: 12
        opacity: root.active ? 1 : 0.7
        Behavior on opacity { NumberAnimation { duration: 250 } }

        Rectangle {
            visible: root.sessionNames.length > 0
            height: 40
            width: sessionLabel.implicitWidth + 32
            radius: 20
            color: sessionArea.containsMouse ? Qt.rgba(1, 1, 1, 0.24) : root.glass
            border.color: root.glassBorder
            border.width: 1
            Behavior on color { ColorAnimation { duration: 150 } }
            Text {
                id: sessionLabel
                anchors.centerIn: parent
                text: root.sessionNames[root.sessionIndex] || ""
                color: "white"
                font.family: root.fontFamily
                font.pixelSize: 14
                font.weight: Font.Medium
            }
            MouseArea {
                id: sessionArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.sessionIndex = (root.sessionIndex + 1) % Math.max(1, root.sessionNames.length)
                    root.wake()
                }
            }
        }

        Repeater {
            model: [
                { icon: "icons/suspend.svg", show: sddm.canSuspend, action: function () { sddm.suspend() } },
                { icon: "icons/restart.svg", show: sddm.canReboot, action: function () { sddm.reboot() } },
                { icon: "icons/power.svg", show: sddm.canPowerOff, action: function () { sddm.powerOff() } }
            ]
            delegate: Rectangle {
                visible: modelData.show
                width: 40
                height: 40
                radius: 20
                color: btnArea.containsMouse ? Qt.rgba(1, 1, 1, 0.24) : root.glass
                border.color: root.glassBorder
                border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }
                Image {
                    anchors.centerIn: parent
                    source: modelData.icon
                    sourceSize: Qt.size(18, 18)
                }
                MouseArea {
                    id: btnArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.action()
                }
            }
        }
    }

    Component.onCompleted: password.forceActiveFocus()
}

/* Vertex Linux — Calamares installation slideshow */
import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation
    timer.interval: 5000

    // ── Slide 1: Welcome ──────────────────────────────────────────────────────
    Slide {

        Image {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            source: "slide1.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        Rectangle {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            color:  "#CC1A0B2E"
        }

        Image {
            id: logo1
            anchors.horizontalCenter: parent.horizontalCenter
            y: 60
            width: 120; height: 120
            source: "vertex-logo.svg"
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: logo1.y + logo1.height + 20
            text: "Welcome to Vertex Linux"
            color: "#FFFFFF"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            text: "A modern, rolling-release desktop powered by KDE Plasma 6"
            color: "#C4B5FD"
            font.pixelSize: 15
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 52
            text: "Installation is in progress — this will only take a few minutes."
            color: "#8B949E"
            font.pixelSize: 13
        }
    }

    // ── Slide 2: Package Management ───────────────────────────────────────────
    Slide {

        Image {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            source: "slide2.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        Rectangle {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            color:  "#CC0F051E"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 80
            text: "Unified Package Management"
            color: "#FFFFFF"
            font.pixelSize: 30
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 128
            text: "vpkg — one command for Pacman, AUR, and Flatpak"
            color: "#A78BFA"
            font.pixelSize: 15
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 20
            spacing: 16
            Text { text: "  vpkg pm  install  neovim";              color: "#34D399"; font.pixelSize: 17; font.family: "monospace" }
            Text { text: "  vpkg aur install  yay";                 color: "#34D399"; font.pixelSize: 17; font.family: "monospace" }
            Text { text: "  vpkg fp  install  com.spotify.Client";  color: "#34D399"; font.pixelSize: 17; font.family: "monospace" }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 52
            text: "Access official repos, AUR, and Flathub — all from one tool."
            color: "#8B949E"
            font.pixelSize: 13
        }
    }

    // ── Slide 3: KDE Plasma ───────────────────────────────────────────────────
    Slide {

        Image {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            source: "slide3.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        Rectangle {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            color:  "#CC140828"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 80
            text: "KDE Plasma 6 Desktop"
            color: "#FFFFFF"
            font.pixelSize: 30
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 128
            text: "Beautiful, fast, and endlessly customisable"
            color: "#A78BFA"
            font.pixelSize: 15
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 20
            spacing: 14
            Text { text: "✦  Wayland-first with full X11 compatibility"; color: "#E2D9F3"; font.pixelSize: 15 }
            Text { text: "✦  Plasma panels, widgets, and themes";        color: "#E2D9F3"; font.pixelSize: 15 }
            Text { text: "✦  KDE Connect — sync with your phone";        color: "#E2D9F3"; font.pixelSize: 15 }
            Text { text: "✦  Discover — graphical software centre";      color: "#E2D9F3"; font.pixelSize: 15 }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 52
            text: "Fully configured and ready to use out of the box."
            color: "#8B949E"
            font.pixelSize: 13
        }
    }

    // ── Slide 4: Always Up to Date ────────────────────────────────────────────
    Slide {

        Image {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            source: "slide4.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        Rectangle {
            x: 0; y: 0
            width:  parent.width
            height: parent.height
            color:  "#CC0A0314"
        }

        Image {
            id: logo4
            anchors.horizontalCenter: parent.horizontalCenter
            y: 60
            width: 100; height: 100
            source: "vertex-logo.svg"
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: logo4.y + logo4.height + 20
            text: "Always Up to Date"
            color: "#FFFFFF"
            font.pixelSize: 30
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: logo4.y + logo4.height + 68
            text: "Rolling release — latest software, always"
            color: "#A78BFA"
            font.pixelSize: 15
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 40
            spacing: 14
            Text { text: "✦  Vertex Updater — one-click system updates";      color: "#E2D9F3"; font.pixelSize: 15 }
            Text { text: "✦  OS features sync automatically from GitHub";      color: "#E2D9F3"; font.pixelSize: 15 }
            Text { text: "✦  Vertex Driver Manager — GPU drivers made easy";  color: "#E2D9F3"; font.pixelSize: 15 }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 52
            text: "Almost there — your Vertex Linux system is nearly ready."
            color: "#8B949E"
            font.pixelSize: 13
        }
    }

    // onActivate is called when the slideshow becomes visible.
    // Leave empty — the Presentation timer handles auto-advance from slide 0.
    function onActivate() { }
    function onLeave()    { }
}

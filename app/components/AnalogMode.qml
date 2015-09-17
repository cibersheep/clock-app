/*
 * Copyright (C) 2014-2015 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.2

ClockCircle {
    id: _innerCircleAnalog

    // Property to set the max width when running the animation
    property int maxWidth

    // Property to show/hide the seconds hand
    property bool showSeconds

    signal animationComplete()

    function startAnimation() {
        _animationTimer.start()
    }

    width: units.gu(0)

    Timer {
        id: _animationTimer
        interval: 200
        repeat: false
        onTriggered: _innerCircleAnimation.start()
    }

    Image {
        id: hourHand

        z: minuteHand.z + 1
        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Hour_Hand.png"
        fillMode: Image.PreserveAspectFit
        // notLocalizedTimeString.split(":")[0] is hours
        // notLocalizedTimeString.split(":")[1] is minutes
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 12 hours in clock face,
        // For hours: 360deg/12h=30 deg/h, for minutes 30deg/60min= 0.5 deg/min
        rotation: (parseInt(notLocalizedTimeString.split(":")[0]) * 30) + (parseInt(notLocalizedTimeString.split(":")[1]) * 0.5)
    }

    Image {
        id: minuteHand

        width: parent.width
        anchors.centerIn: parent

        smooth: true
        source: "../graphics/Minute_Hand.png"
        fillMode: Image.PreserveAspectFit
        // notLocalizedTimeString.split(":")[1] is minutes
        // notLocalizedTimeString.split(":")[2] is seconds
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 60 miutes in clock face,
        // For minutes: 360deg/60min=6 deg/min, for seconds 6deg/60sec= 0.1 deg/sec
        rotation: (parseInt(notLocalizedTimeString.split(":")[1]) * 6) + (parseInt(notLocalizedTimeString.split(":")[2]) * 0.1)
    }

    Image {
        id: secondHand

        anchors.centerIn: parent
        width: parent.width + units.gu(2)

        smooth: true
        visible: showSeconds
        source: "../graphics/Second_Hand.png"
        fillMode: Image.PreserveAspectFit
        // notLocalizedTimeString.split(":")[2] is seconds
        // We need to calculate degree number for rotation (0 degrees means no rotation).
        // Full rotate has 360 degrees and we have 60 seconds in clock face,
        // For seconds 360deg/60sec= 6 deg/sec
        rotation: visible ? parseInt(notLocalizedTimeString.split(":")[2]) * 6 : 0
    }

    Image {
        id: center

        z: hourHand.z + 1
        width: parent.width
        anchors.centerIn: parent

        fillMode: Image.PreserveAspectFit
        source: "../graphics/Knob.png"
    }

    SequentialAnimation {
        id: _innerCircleAnimation

        PropertyAnimation {
            target: _innerCircleAnalog
            property: "width"
            from: units.gu(0)
            to: maxWidth
            duration: 900
        }

        // Fire signal that the animation is complete.
        ScriptAction {
            script: animationComplete()
        }
    }
}

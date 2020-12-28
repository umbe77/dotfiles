/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 1.0
import "../code/data-loader.js" as DataLoader
import "../code/config-utils.js" as ConfigUtils
import "../code/icons.js" as IconTools
import "../code/unit-utils.js" as UnitUtils
import "providers"

Item {
    id: main

    property string placeIdentifier
    property string placeAlias
    property string cacheKey
    property var cacheMap: {}
    property var lastReloadedMsMap: {}
    property bool renderMeteogram: plasmoid.configuration.renderMeteogram
    property int temperatureType: plasmoid.configuration.temperatureType
    property int pressureType: plasmoid.configuration.pressureType
    property int windSpeedType: plasmoid.configuration.windSpeedType
    property int timezoneType: plasmoid.configuration.timezoneType
    property bool twelveHourClockEnabled: Qt.locale().timeFormat(Locale.ShortFormat).toString().indexOf('AP') > -1
    property string placesJsonStr: plasmoid.configuration.places
    property bool onlyOnePlace: true

    property string datetimeFormat: 'yyyy-MM-dd\'T\'hh:mm:ss'
    property var xmlLocale: Qt.locale('en_GB')
    property var additionalWeatherInfo: {}

    property string overviewImageSource
    property string creditLink
    property string creditLabel
    property int reloadIntervalMin: plasmoid.configuration.reloadIntervalMin
    property int reloadIntervalMs: reloadIntervalMin * 60 * 1000

    property bool loadingData: false
    property double loadingDataSinceTime: 0
    property int loadingDataTimeoutMs: 15000
    property var loadingXhrs: []
    property bool loadingError: false
    property bool imageLoadingError: true
    property bool alreadyLoadedFromCache: false

    property string lastReloadedText: '⬇ 0m ago'
    property string tooltipSubText: ''

    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    property bool onDesktop: (plasmoid.location == PlasmaCore.Types.Desktop || plasmoid.location == PlasmaCore.Types.Floating)
    property bool inTray: false
    property string plasmoidCacheId: plasmoid.id

    property int inTrayActiveTimeoutSec: plasmoid.configuration.inTrayActiveTimeoutSec

    property int nextDaysCount: 8

    property bool textColorLight: ((theme.textColor.r + theme.textColor.g + theme.textColor.b) / 3) > 0.5

    // 0 - standard
    // 1 - vertical
    // 2 - compact
    property int layoutType: plasmoid.configuration.layoutType

    property bool updatingPaused: true

    property var currentProvider: null

    property bool meteogramModelChanged: false

    anchors.fill: parent

    property Component crInTray: CompactRepresentationInTray { }
    property Component cr: CompactRepresentation { }

    property Component frInTray: FullRepresentationInTray { }
    property Component fr: FullRepresentation { }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: cr
    Plasmoid.fullRepresentation: fr

    property bool debugLogging: false

    function dbgprint(msg) {
        if (!debugLogging) {
            return
        }
        print('[weatherWidget] ' + msg)
    }

    FontLoader {
        source: '../fonts/weathericons-regular-webfont-2.0.10.ttf'
    }

    YrNo {
        id: yrnoProvider
    }

    OpenWeatherMap {
        id: owmProvider
    }

    ListModel {
        id: actualWeatherModel
    }

    ListModel {
        id: nextDaysModel
    }

    ListModel {
        id: meteogramModel
    }

    function action_toggleUpdatingPaused() {
        updatingPaused = !updatingPaused
        abortTooLongConnection(true)
        plasmoid.setAction('toggleUpdatingPaused', updatingPaused ? i18n('Resume Updating') : i18n('Pause Updating'), updatingPaused ? 'media-playback-start' : 'media-playback-pause');
    }

    WeatherCache {
        id: weatherCache
        cacheId: plasmoidCacheId
    }

    Component.onCompleted: {

        inTray = (plasmoid.parent !== null && (plasmoid.parent.pluginName === 'org.kde.plasma.private.systemtray' || plasmoid.parent.objectName === 'taskItemContainer'))
        plasmoidCacheId = inTray ? plasmoid.parent.id : plasmoid.id
        dbgprint('inTray=' + inTray + ', plasmoidCacheId=' + plasmoidCacheId)

        additionalWeatherInfo = {
            sunRise: new Date('2000-01-01T00:00:00'),
            sunSet: new Date('2000-01-01T00:00:00'),
            sunRiseTime: '0:00',
            sunSetTime: '0:00',
            nearFutureWeather: {
                iconName: null,
                temperature: null
            }
        }

        // systray settings
        if (inTray) {
            Plasmoid.compactRepresentation = crInTray
            Plasmoid.fullRepresentation = frInTray
        }

        // init contextMenu
        action_toggleUpdatingPaused()

        var cacheContent = weatherCache.readCache()

        dbgprint('readCache result length: ' + cacheContent.length)

        // fill xml cache xml
        if (cacheContent) {
            try {
                cacheMap = JSON.parse(cacheContent)
                dbgprint('cacheMap initialized - keys:')
                for (var key in cacheMap) {
                    dbgprint('  ' + key + ', data: ' + cacheMap[key])
                }
            } catch (error) {
                dbgprint('error parsing cacheContent')
            }
        }
        cacheMap = cacheMap || {}

        // fill last reloaded
        var lastReloadedMsJson = plasmoid.configuration.lastReloadedMsJson
        if (lastReloadedMsJson) {
            lastReloadedMsMap = JSON.parse(lastReloadedMsJson)
        }
        lastReloadedMsMap = lastReloadedMsMap || {}

        // set initial place
        setNextPlace(true)
    }

    onPlacesJsonStrChanged: {
        setNextPlace(true)
        onlyOnePlace = ConfigUtils.getPlacesArray().length === 1
    }

    function showData() {
        dbgprint('init: plasmoid.configuration.lastReloadedMs = ' + getLastReloadedMs())

        var ok = loadFromCache()
        if (!ok) {
            reloadData()
        }
        updateLastReloadedText()
        reloadMeteogram()
    }

    function setCurrentProviderAccordingId(providerId) {
        if (providerId === 'owm') {
            dbgprint('setting provider OpenWeatherMap')
            currentProvider = owmProvider
        } else {
            dbgprint('setting provider yr.no')
            currentProvider = yrnoProvider
        }
    }

    function setNextPlace(initial) {
        actualWeatherModel.clear()
        nextDaysModel.clear()
        meteogramModel.clear()

        var places = ConfigUtils.getPlacesArray()
        dbgprint('places count=' + places.length + ', placeIndex=' + plasmoid.configuration.placeIndex)
        var placeIndex = plasmoid.configuration.placeIndex
        if (!initial) {
            placeIndex++
        }
        if (placeIndex > places.length - 1) {
            placeIndex = 0
        }
        plasmoid.configuration.placeIndex = placeIndex
        dbgprint('placeIndex now: ' + plasmoid.configuration.placeIndex)
        var placeObject = places[placeIndex]
        placeIdentifier = placeObject.placeIdentifier
        placeAlias = placeObject.placeAlias
        dbgprint('next placeIdentifier is: ' + placeIdentifier)
        cacheKey = DataLoader.generateCacheKey(placeIdentifier)
        dbgprint('next cacheKey is: ' + cacheKey)

        alreadyLoadedFromCache = false

        setCurrentProviderAccordingId(placeObject.providerId)

        showData()
    }

    function dataLoadedFromInternet(contentToCache) {
        loadingData = false

        dbgprint('saving cacheKey = ' + cacheKey)
        cacheMap[cacheKey] = contentToCache
        dbgprint('cacheMap now has these keys:')
        for (var key in cacheMap) {
            dbgprint('  ' + key)
        }
        alreadyLoadedFromCache = false
        weatherCache.writeCache(JSON.stringify(cacheMap))

        reloadMeteogram()

        reloaded()

        loadFromCache()
    }

    function reloadDataFailureCallback() {
        main.loadingData = false
        handleLoadError()
    }

    function reloadData() {
        var nowTime = (new Date()).getTime();

        if (loadingData) {
            dbgprint('still loading')
            return
        }

        loadingDataSinceTime = nowTime
        loadingData = true

        loadingXhrs = currentProvider.loadDataFromInternet(dataLoadedFromInternet, reloadDataFailureCallback, { placeIdentifier: placeIdentifier })

        dbgprint('reload called, cacheKey is: ' + cacheKey)
    }

    function reloadMeteogram() {
        currentProvider.reloadMeteogramImage(placeIdentifier)
    }

    function setLastReloadedMs(lastReloadedMs) {
        lastReloadedMsMap[cacheKey] = lastReloadedMs
        plasmoid.configuration.lastReloadedMsJson = JSON.stringify(lastReloadedMsMap)
    }

    function getLastReloadedMs() {
        if (!lastReloadedMsMap) {
            return new Date().getTime()
        }
        return lastReloadedMsMap[cacheKey]
    }

    function reloaded() {
        setLastReloadedMs(DataLoader.setReloaded())
        updateLastReloadedText()
        dbgprint('reloaded')
    }

    function loadFromCache() {
        dbgprint('loading from cache, config key: ' + cacheKey)

        if (alreadyLoadedFromCache) {
            dbgprint('already loaded from cache')
            return true
        }

        creditLink = currentProvider.getCreditLink(placeIdentifier)
        creditLabel = currentProvider.getCreditLabel(placeIdentifier)

        if (!cacheMap || !cacheMap[cacheKey]) {
            dbgprint('cache not available')
            return false
        }

        var success = currentProvider.setWeatherContents(cacheMap[cacheKey])
        if (!success) {
            dbgprint('setting weather contents not successful')
            return false
        }

        alreadyLoadedFromCache = true
        return true
    }

    function handleLoadError() {
        dbgprint('Error getting weather data. Scheduling data reload...')
        DataLoader.scheduleDataReload()

        loadFromCache()
    }

    onInTrayActiveTimeoutSecChanged: {
        updateLastReloadedText()
    }

    function updateLastReloadedText() {
        var lastReloadedMs = getLastReloadedMs()
        lastReloadedText = '⬇ ' + i18n('%1 ago', DataLoader.getLastReloadedTimeText(lastReloadedMs))
        plasmoid.status = DataLoader.getPlasmoidStatus(lastReloadedMs, inTrayActiveTimeoutSec)
    }

    function updateAdditionalWeatherInfoText() {
        var sunRise = additionalWeatherInfo.sunRise
        var sunSet = additionalWeatherInfo.sunSet
        var now = new Date()
        sunRise = UnitUtils.convertDate(sunRise, timezoneType)
        sunSet = UnitUtils.convertDate(sunSet, timezoneType)
        additionalWeatherInfo.sunRiseTime = Qt.formatTime(sunRise, Qt.locale().timeFormat(Locale.ShortFormat))
        additionalWeatherInfo.sunSetTime = Qt.formatTime(sunSet, Qt.locale().timeFormat(Locale.ShortFormat))
        refreshTooltipSubText()
    }

    function refreshTooltipSubText() {
        dbgprint('refreshing sub text')
        if (additionalWeatherInfo === undefined || additionalWeatherInfo.nearFutureWeather.iconName === null || actualWeatherModel.count === 0) {
            dbgprint('model not yet ready')
            return
        }
        var nearFutureWeather = additionalWeatherInfo.nearFutureWeather
        var futureWeatherIcon = IconTools.getIconCode(nearFutureWeather.iconName, currentProvider.providerId, getPartOfDayIndex())
        var windDirectionIcon = IconTools.getWindDirectionIconCode(actualWeatherModel.get(0).windDirection)
        var subText = ''

        subText += '<br /><font size="4" style="font-family: weathericons">' + windDirectionIcon + '</font><font size="4"> ' + UnitUtils.getWindSpeedText(actualWeatherModel.get(0).windSpeedMps, windSpeedType) + '</font>'
        subText += '<br /><font size="4">' + UnitUtils.getPressureText(actualWeatherModel.get(0).pressureHpa, pressureType) + '</font>'
        subText += '<br /><table>'
        if (typeof(actualWeatherModel.get(0).humidity) === 'string' && typeof(actualWeatherModel.get(0).cloudiness) === 'string') {
            subText += '<tr>'
            subText += '<td><font size="4"><font style="font-family: weathericons">\uf07a</font>&nbsp;' + actualWeatherModel.get(0).humidity + '%</font></td>'
            subText += '<td><font size="4"><font style="font-family: weathericons">\uf013</font>&nbsp;' + actualWeatherModel.get(0).cloudiness + '%</font></td>'
            subText += '</tr>'
            subText += '<tr><td>&nbsp;</td><td></td></tr>'
        }
        subText += '<tr>'
        subText += '<td><font size="4"><font style="font-family: weathericons">\uf051</font>&nbsp;' + additionalWeatherInfo.sunRiseTime + '&nbsp;&nbsp;&nbsp;</font></td>'
        subText += '<td><font size="4"><font style="font-family: weathericons">\uf052</font>&nbsp;' + additionalWeatherInfo.sunSetTime + '</font></td>'
        subText += '</tr>'
        subText += '</table>'

        subText += '<br /><br />'
        subText += '<font size="3">' + i18n('near future') + '</font>'
        subText += '<b>'
        subText += '<font size="6">&nbsp;&nbsp;&nbsp;' + UnitUtils.getTemperatureNumber(nearFutureWeather.temperature, temperatureType) + UnitUtils.getTemperatureEnding(temperatureType)
        subText += '&nbsp;&nbsp;&nbsp;<font style="font-family: weathericons">' + futureWeatherIcon + '</font></font>'
        subText += '</b>'

        tooltipSubText = subText
    }

    function getPartOfDayIndex() {
        var now = new Date()
        return additionalWeatherInfo.sunRise < now && now < additionalWeatherInfo.sunSet ? 0 : 1
    }

    function abortTooLongConnection(forceAbort) {
        if (!loadingData) {
            return
        }
        var nowTime = (new Date()).getTime();
        dbgprint('loadingDataSinceTime=' + loadingDataSinceTime + ', loadingDataTimeoutMs=' + loadingDataTimeoutMs + ', now=' + nowTime + ', forceAbort=' + forceAbort)
        if (forceAbort || (loadingDataSinceTime + loadingDataTimeoutMs < nowTime)) {
            dbgprint('timeout reached, aborting existing xhrs')
            loadingXhrs.forEach(function (xhr) {
                xhr.abort()
            })
            reloadDataFailureCallback()
        } else {
            dbgprint('regular loading, no aborting yet')
            return
        }
    }

    function tryReload() {
        updateLastReloadedText()

        if (updatingPaused) {
            return
        }

        if (imageLoadingError && !loadingError) {
            reloadMeteogram()
            imageLoadingError = false
        }

        if (DataLoader.isReadyToReload(reloadIntervalMs, getLastReloadedMs())) {
            reloadData()
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            tryReload()
            abortTooLongConnection()
        }
    }

    onTemperatureTypeChanged: {
        refreshTooltipSubText()
    }

    onPressureTypeChanged: {
        refreshTooltipSubText()
    }

    onWindSpeedTypeChanged: {
        refreshTooltipSubText()
    }

    onTwelveHourClockEnabledChanged: {
        refreshTooltipSubText()
    }

    onTimezoneTypeChanged: {
        meteogramModelChanged = !meteogramModelChanged
        updateAdditionalWeatherInfoText()
    }

}

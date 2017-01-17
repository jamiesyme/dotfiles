import os, json, strutils, math


type
  SinkType* = enum
    stHeadphones,
    stSpeakers
  SinkSettings* = tuple
    volume: int
    muted: bool
  Sink* = tuple
    sinkType: SinkType
    settings: SinkSettings

proc strToSinkType*(sinkName: string): SinkType =
  case sinkName
  of "headphones":
    return stHeadphones
  of "speakers":
    return stSpeakers
  else:
    raiseAssert("invalid sink name: " & sinkName)

proc `$`*(sinkType: SinkType): string =
  case sinkType
  of stHeadphones:
    return "headphones"
  of stSpeakers:
    return "speakers"

proc defaultSinkSettings(): SinkSettings =
  return (volume: 75, muted: false)


proc getAlsaVolume(volume: int): int =
  let
    volMin = 0.0
    volMax = log10(11.0)
    volRng = volMax - volMin
    normVol = log10(volume.clamp(0, 100).float / 10.0 + 1.0).clamp(volMin, volMax) / volRng
  result = (normVol * 100.0).int


proc getSettingsPath(sinkType: SinkType): string =
  case sinkType
  of stHeadphones:
    return getConfigDir() & "malsa/headphones"
  of stSpeakers:
    return getConfigDir() & "malsa/speakers"

proc load*(sink: var Sink) =
  let settingsPath = getSettingsPath(sink.sinkType)
  if fileExists(settingsPath):
    let settingsJson = parseFile(settingsPath)
    sink.settings = (
      volume: int(settingsJson["volume"].getNum()),
      muted: settingsJson["muted"].getBVal()
    )
  else:
    sink.settings = defaultSinkSettings()

proc save*(sink: Sink) =
  let settingsPath = getSettingsPath(sink.sinkType)
  if not dirExists(parentDir(settingsPath)):
    createDir(parentDir(settingsPath))
  discard execShellCmd("touch " & settingsPath)
  let settingsJson: JsonNode = %* {
    "volume": %sink.settings.volume.clamp(0, 100),
    "muted": %sink.settings.muted
  }
  writeFile(settingsPath, settingsJson.pretty())

proc apply*(sink: Sink) =
  let
    alsaName = case sink.sinkType
               of stHeadphones:
                 "Headphone"
               of stSpeakers:
                 "Front"
    alsaVolume = if sink.settings.muted: 0
                 else: getAlsaVolume(sink.settings.volume)
    alsaMute = "unmute" #if sink.settings.muted or sink.settings.volume == 0: "mute"
               #else: "unmute"
  discard execShellCmd(
    "amixer -c 0 set $# playback $#% $# > /dev/null" %
    [
      alsaName,
      alsaVolume.intToStr(),
      alsaMute
    ]
  )


proc main() =
  let args = commandLineParams()
  doAssert(args.len >= 1, "no sink specified")
  case args[0]
  of "sync":
    var sink: Sink
    for st in [stHeadphones, stSpeakers]:
      sink.sinkType = st
      sink.load()
      sink.apply()
  else:
    var sink: Sink
    sink.sinkType = strToSinkType(args[0])
    sink.load()
    doAssert(args.len >= 2, "no command specified")
    case args[1]
    of "volume":
      doAssert(args.len >= 3, "no volume modifier specified")
      let modifier = args[2]
      case modifier[0]
      of '+':
        sink.settings.volume += parseInt(modifier[1..^1])
      of '-':
        sink.settings.volume -= parseInt(modifier[1..^1])
      else:
        sink.settings.volume = parseInt(modifier)
        sink.save()
        sink.apply()
    of "mute":
      sink.settings.muted = true
      sink.save()
      sink.apply()
    of "unmute":
      sink.settings.muted = false
      sink.save()
      sink.apply()
    else:
      discard

if isMainModule:
  main()

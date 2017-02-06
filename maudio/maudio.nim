import os, json
import malsa


type
  MaudioSettings* = tuple
    currentSink: SinkType

proc defaultMaudioSettings(): MaudioSettings =
  return (currentSink: stSpeakers)


proc getSettingsPath(): string =
  return getConfigDir() & "maudio/config"

proc load*(settings: var MaudioSettings) =
  let settingsPath = getSettingsPath()
  if fileExists(settingsPath):
    let settingsJson = parseFile(settingsPath)
    settings = (
      currentSink: strToSinkType(settingsJson["currentSink"].getStr())
    )
  else:
    settings = defaultMaudioSettings()

proc save(settings: MaudioSettings) =
  let settingsPath = getSettingsPath()
  if not dirExists(parentDir(settingsPath)):
    createDir(parentDir(settingsPath))
    discard execShellCmd("touch " & settingsPath)
  let settingsJson: JsonNode = %* {
    "currentSink": %($settings.currentSink)
  }
  writeFile(settingsPath, settingsJson.pretty())

proc apply(settings: MaudioSettings) =
  var sink: Sink
  sink.sinkType = settings.currentSink
  sink.load()
  sink.settings.muted = false
  sink.save()
  sink.apply()
  if settings.currentSink == stHeadphones:
    sink.sinkType = stSpeakers
  else:
    sink.sinkType = stHeadphones
  sink.load()
  sink.settings.muted = true
  sink.save()
  sink.apply()


proc main() =
  let args = commandLineParams()
  doAssert(args.len >= 1, "no command specified")
  case args[0]
  of "sync":
    var settings: MaudioSettings
    settings.load()
    settings.apply()
  of "sink":
    doAssert(args.len >= 2, "no sink modifier specified")
    var settings: MaudioSettings
    settings.load()
    case args[1]
    of "toggle":
      if settings.currentSink == stHeadphones:
        settings.currentSink = stSpeakers
      else:
        settings.currentSink = stHeadphones
      settings.save()
      settings.apply()
    else:
      raiseAssert("invalid sink modifier: " & args[1])
  of "volume":
    doAssert(args.len >= 2, "no volume modifier specified")
    var
      settings: MaudioSettings
      sink: Sink
    settings.load()
    sink.sinkType = settings.currentSink
    sink.load()
    case args[1]
    of "down":
      sink.settings.volume -= 5
    of "up":
      sink.settings.volume += 5
    of "toggle":
      sink.settings.muted = not sink.settings.muted
    else:
      raiseAssert("invalid volume modifier: " & args[1])
    sink.save()
    sink.apply()
  of "show":
    doAssert(args.len >= 2, "no show modifier specified")
    var
      settings: MaudioSettings
      sink: Sink
    settings.load()
    sink.sinkType = settings.currentSink
    sink.load()
    case args[1]
    of "sink":
      echo $sink.sinkType
    of "volume":
      echo $sink.settings.volume
    of "mute":
      echo if sink.settings.muted: "1" else: "0"
    else:
      raiseAssert("invalid show modifier: " & args[1])
  else:
    raiseAssert("invalid command: " & args[0])

if isMainModule:
  main()

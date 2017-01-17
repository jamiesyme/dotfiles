import maudio, malsa

proc main =
  var
    maudioSettings: MaudioSettings
    currentSink: Sink
  maudioSettings.load()
  currentSink.sinkType = maudioSettings.currentSink
  currentSink.load()
  var str = case currentSink.sinkType
            of stHeadphones:
              "Headphones "
            of stSpeakers:
              "Speakers "
  str &= $currentSink.settings.volume & "%"
  if currentSink.settings.muted:
    str &= " [M]"
  echo str

main()

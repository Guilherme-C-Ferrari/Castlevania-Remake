extends Node

@onready var bgm_streamer := $BackgroundMusic

const VAMPIRE_KILLER__COURTYARD_MUSIC = preload("uid://b1whcpxd6f0eg")

var musics := [
	VAMPIRE_KILLER__COURTYARD_MUSIC
]

var current_music_index := 0

func _ready() -> void:
	bgm_streamer.finished.connect(_on_music_finished)

	#play_current_music()


#Da play na musica atual da lista, possibilitando uma fila de musicas
func play_current_music() -> void:
	bgm_streamer.stream = musics[current_music_index]
	bgm_streamer.bus = "Music"
	bgm_streamer.play()

func _on_music_finished() -> void:
	current_music_index += 1

	if current_music_index >= musics.size():
		current_music_index = 0

	play_current_music()

#Cria um SFX com diferentes configurações
func play_sound_effect(stream: AudioStream, bus: String = "Master", volume_db: float = 0.0, pitch_min: float = 0.90, pitch_max: float = 1.05) -> void:
	var new_sfx := AudioStreamPlayer.new()

	new_sfx.stream = stream
	new_sfx.bus = bus
	new_sfx.volume_db = volume_db
	new_sfx.pitch_scale = randf_range(pitch_min, pitch_max)
	
	new_sfx.finished.connect(
		destroy_stream_player.bind(new_sfx)
	)
	add_child(new_sfx)
	new_sfx.play()

func destroy_stream_player(stream_player: AudioStreamPlayer) -> void:
	stream_player.queue_free()

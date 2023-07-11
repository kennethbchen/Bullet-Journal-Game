extends CharacterBody2D

class_name Projectile

@export var speed: float = 60
@export var lifespan: float = 5

func _ready():
	get_tree().create_timer(lifespan).timeout.connect(queue_free)

func _process(delta):
	position += transform.x * speed * delta

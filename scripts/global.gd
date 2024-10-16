extends Node

var gameStarted: bool

var playerBody: CharacterBody2D

var playerAlive: bool
var playerDamageZone: Area2D
var playerDamageAmount: int
var playerHitbox: Area2D

var batDamageZone: Area2D
var batDamageAmout: int

var skeletonDamageZone: Area2D
var skeletonDamageAmount: int


var currentWave: int
var movingToNextWave: bool

var highScore = 0
var currentScore: int
var previousScore: int

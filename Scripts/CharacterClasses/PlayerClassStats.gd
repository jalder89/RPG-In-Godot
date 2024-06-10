extends ClassStats
class_name PlayerClassStats

const MAX_EXPERIENCE := 100

var experience := 0:
	set(value):
		experience = value
		while experience >= MAX_EXPERIENCE:
			experience = experience - MAX_EXPERIENCE
			level += 1

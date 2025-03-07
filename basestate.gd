extends Node

# 모든 상태가 구현해야 하는 함수들

# 이 상태의 열거형 값을 반환
func get_state_enum():
	# 자식 클래스에서 오버라이드해야 함
	return -1

# 상태 진입 시 호출
func enter():
	# 자식 클래스에서 오버라이드
	pass

# 상태 종료 시 호출
func exit():
	# 자식 클래스에서 오버라이드
	pass

# 이 상태에서의 처리 로직
func process(delta):
	# 자식 클래스에서 오버라이드
	pass

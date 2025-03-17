extends Node 
class_name TetrominoData

# 모든 테트로미노의 모든 회전 및 뒤집기 형태를 저장
# 첫 번째 차원: 테트로미노 종류 (0: 빈 블록, 1: O, 2: I, 3: S, 4: T, 5: L)
# 두 번째 차원: 회전/뒤집기 상태 (8가지 가능한 상태)
# 세 번째 차원: 블록을 구성하는 좌표 (Vector2 배열)
const all_tetrominos = [
	# 0: 빈 블록
	[
		[] # 빈 블록은 회전/뒤집기 없음
	],
	
	# 1: O 블록 (회전/뒤집기해도 모양이 동일)
	[
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		# 좌우 뒤집기 (O 블록은 뒤집어도 동일)
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)]
	],
	
	# 2: I 블록
	[
		[Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2)], # 기본
		[Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(2,0)], # 90도 회전
		[Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2)], # 기본
		[Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(2,0)], # 90도 회전
		# 좌우 뒤집기 (I 블록은 좌우 뒤집어도 같은 형태)
		[Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2)], # 기본
		[Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(2,0)], # 90도 회전
		[Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2)], # 기본
		[Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(2,0)], # 90도 회전
	],
	
	# 3: S 블록
	[
		[Vector2(0,-1), Vector2(0,0), Vector2(1,0), Vector2(1,1)], # 기본
		[Vector2(-1,1), Vector2(0,0), Vector2(0,1), Vector2(1,0)], # 90도 회전
		[Vector2(0,-1), Vector2(0,0), Vector2(1,0), Vector2(1,1)], # 180도 회전 (기본과 동일)
		[Vector2(-1,1), Vector2(0,0), Vector2(0,1), Vector2(1,0)], # 270도 회전 (90도와 동일)
		# 좌우 뒤집기 (Z 블록이 됨)
		[Vector2(0,-1), Vector2(0,0), Vector2(-1,0), Vector2(-1,1)], # 기본
		[Vector2(-1,1), Vector2(0,0), Vector2(0,1), Vector2(1,0)], # 90도 회전
		[Vector2(0,-1), Vector2(0,0), Vector2(-1,0), Vector2(-1,1)], # 기본
		[Vector2(1,1), Vector2(0,0), Vector2(0,1), Vector2(-1,0)], # 270도 회전 (90도와 동일)		
	],
	
	# 4: T 블록
	[
		[Vector2(-1,0), Vector2(0,-1), Vector2(0,0), Vector2(1,0)], # 180도 회전
		[Vector2(-1,0), Vector2(0,-1), Vector2(0,0), Vector2(0,1)], # 270도 회전
		[Vector2(-1,0), Vector2(0,0), Vector2(0,1), Vector2(1,0)], # 기본
		[Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(1,0)], # 90도 회전
		# 좌우 뒤집기
		[Vector2(-1,0), Vector2(0,-1), Vector2(0,0), Vector2(1,0)], # 180도 회전
		[Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(1,0)], # 90도 회전
		[Vector2(-1,0), Vector2(0,0), Vector2(0,1), Vector2(1,0)], # 기본
		[Vector2(-1,0), Vector2(0,-1), Vector2(0,0), Vector2(0,1)], # 270도 회전
	],
	
	# 5: L 블록
	[
		[Vector2(-1,-1), Vector2(-1,0), Vector2(0,0), Vector2(1,0)], # 기본
		[Vector2(0,-1), Vector2(1,-1), Vector2(0,0), Vector2(0,1)], # 90도 회전
		[Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(1,1)], # 180도 회전
		[Vector2(-1,1), Vector2(0,-1), Vector2(0,0), Vector2(0,1)], # 270도 회전
		# 좌우 뒤집기 (J 블록이 됨)
		[Vector2(1,-1), Vector2(-1,0), Vector2(0,0), Vector2(1,0)], # 
		[Vector2(0,-1), Vector2(-1,-1), Vector2(0,0), Vector2(0,1)], # 90도 회전
		[Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(-1,1)], # 180도 회전
		[Vector2(1,1), Vector2(0,-1), Vector2(0,0), Vector2(0,1)], # 270도 회전
	],
	
	# 6: O 블록 (회전/뒤집기해도 모양이 동일)
	[
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
		[Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)]
	]
]

# 테트로미노의 회전 상태를 반환하는 헬퍼 함수
func get_tetromino(type: int, rotation: int, flipped: bool) -> Array:
	# 유효하지 않은 타입 체크
	if type < 0 or type >= all_tetrominos.size():
		return []
		
	# 회전 값은 0-3 사이로 제한 (0: 0도, 1: 90도, 2: 180도, 3: 270도)
	var rot_index = rotation % 4
	
	# 뒤집기 상태에 따라 인덱스 조정
	if flipped:
		rot_index += 4
		
	# 타입과 회전/뒤집기 상태에 해당하는 테트로미노 반환
	if rot_index < all_tetrominos[type].size():
		return all_tetrominos[type][rot_index]
	else:
		# O 블록처럼 회전이 의미없는 경우를 위한 폴백
		return all_tetrominos[type][0]

addi a1, zero, 0		# reset a1
csrrw a0, 0xf00, x0 		# write switches into register a0
#li a7, 5
#ecall

lui a1, 0x1999a
addi a1, a1, -0x666		# get 1/10 (2^32 * 1/10) contstant (stored as fixed point (32, 32))
addi a2, zero, 10		# need constant 10 in a2
addi a3, zero, 0		# this will be the register that is given to hex displays

mul t0, a0, a1			# get fractional bits and store in t0
mulhu t0, t0, a2		# multiply fractional part by 10 to get decimal digit
slli t0, t0, 0			# shift left to set the correct grouping of 4 bits
or a3, a3, t0			# set the register that will be displayed at end
mulhu a0, a0, a1		# get whole part

mul t0, a0, a1			# get fractional bits and store in t0
mulhu t0, t0, a2		# multiply fractional part by 10 to get decimal digit
slli t0, t0, 4			# shift left to set the correct grouping of 4 bits
or a3, a3, t0			# set the register that will be displayed at end
mulhu a0, a0, a1		# get whole part

mul t0, a0, a1			# get fractional bits and store in t0
mulhu t0, t0, a2		# multiply fractional part by 10 to get decimal digit
slli t0, t0, 8			# shift left to set the correct grouping of 4 bits
or a3, a3, t0			# set the register that will be displayed at end
mulhu a0, a0, a1		# get whole part

mul t0, a0, a1			# get fractional bits and store in t0
mulhu t0, t0, a2		# multiply fractional part by 10 to get decimal digit
slli t0, t0, 12			# shift left to set the correct grouping of 4 bits
or a3, a3, t0			# set the register that will be displayed at end
mulhu a0, a0, a1		# get whole part

mul t0, a0, a1			# get fractional bits and store in t0
mulhu t0, t0, a2		# multiply fractional part by 10 to get decimal digit
slli t0, t0, 16			# shift left to set the correct grouping of 4 bits
or a3, a3, t0			# set the register that will be displayed at end
mulhu a0, a0, a1		# get whole part

mul t0, a0, a1			# get fractional bits and store in t0
mulhu t0, t0, a2		# multiply fractional part by 10 to get decimal digit
slli t0, t0, 20			# shift left to set the correct grouping of 4 bits
or a3, a3, t0			# set the register that will be displayed at end
mulhu a0, a0, a1		# get whole part

csrrw x0, 0xf02, a3		# write result to hex displays

################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/audioget/audioget.c \
../src/audioget/fftradix4.c 

OBJS += \
./src/audioget/audioget.o \
./src/audioget/fftradix4.o 

C_DEPS += \
./src/audioget/audioget.d \
./src/audioget/fftradix4.d 


# Each subdirectory must supply rules for building sources it contributes
src/audioget/%.o: ../src/audioget/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: AVR Compiler'
	avr-gcc -Wall -Os -fpack-struct -fshort-enums -ffunction-sections -fdata-sections -std=gnu99 -funsigned-char -funsigned-bitfields -mmcu=atmega8 -DF_CPU=16000000UL -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '



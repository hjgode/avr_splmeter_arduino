################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/uart/subdir.mk
-include src/audioget/subdir.mk
-include src/adc/subdir.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
LSS += \
avr_splmeter.lss \

FLASH_IMAGE += \
avr_splmeter.hex \

EEPROM_IMAGE += \
avr_splmeter.eep \

SIZEDUMMY += \
sizedummy \


# All Target
all: avr_splmeter.elf secondary-outputs

# Tool invocations
avr_splmeter.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: AVR C Linker'
	avr-gcc -Wl,-Map,avr_splmeter.map -mmcu=atmega8 -o "avr_splmeter.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

avr_splmeter.lss: avr_splmeter.elf
	@echo 'Invoking: AVR Create Extended Listing'
	-avr-objdump -h -S avr_splmeter.elf  >"avr_splmeter.lss"
	@echo 'Finished building: $@'
	@echo ' '

avr_splmeter.hex: avr_splmeter.elf
	@echo 'Create Flash image (ihex format)'
	-avr-objcopy -R .eeprom -R .fuse -R .lock -R .signature -O ihex avr_splmeter.elf  "avr_splmeter.hex"
	@echo 'Finished building: $@'
	@echo ' '

avr_splmeter.eep: avr_splmeter.elf
	@echo 'Create eeprom image (ihex format)'
	-avr-objcopy -j .eeprom --no-change-warnings --change-section-lma .eeprom=0 -O ihex avr_splmeter.elf  "avr_splmeter.eep"
	@echo 'Finished building: $@'
	@echo ' '

sizedummy: avr_splmeter.elf
	@echo 'Invoking: Print Size'
	-avr-size --format=avr --mcu=atmega8 avr_splmeter.elf
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(ASM_DEPS)$(EEPROM_IMAGE)$(FLASH_IMAGE)$(ELFS)$(LSS)$(S_DEPS)$(SIZEDUMMY)$(S_UPPER_DEPS) avr_splmeter.elf
	-@echo ' '

secondary-outputs: $(LSS) $(FLASH_IMAGE) $(EEPROM_IMAGE) $(SIZEDUMMY)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

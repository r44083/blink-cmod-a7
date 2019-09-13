PARTNAME := xc7a35tcpg236-1

VHDLS := ./src/main.vhd

CONSTRAINTS := ./CmodA7_Master.xdc

# ------------------------------------------------------------------------------
PROJNAME := $(notdir $(CURDIR))

ROOT := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

BUILDDIR := $(ROOT)/build
REPORTDIR := $(BUILDDIR)/report

LOG := $(BUILDDIR)/$(PROJNAME).log

ARGS := -mode batch -notrace
ARGS += -tempDir $(BUILDDIR) -applog -log $(LOG) -nojournal


ifeq ($(OS),Windows_NT)

define MKDIR
@if not exist "$(1)" mkdir "$(1)"
endef
define RMDIR
@if exist "$(1)" rmdir /s /q "$(1)"
endef
define RM
@del /q "$(1)" 2>nul
endef

else

define MKDIR
@mkdir -p "$(1)"
endef
define RMDIR
@rm -rf "$(1)"
endef
define RM
@rf "$(1)"
endef

endif

all:
	$(call MKDIR,$(BUILDDIR))
	$(call MKDIR,$(REPORTDIR))
	vivado $(VIVADOARGS)

clean:
	$(call RMDIR,$(BUILDDIR))

PARTNAME := xc7a35tcpg236-1

VHDLS := ./src/main.vhd

CONSTRAINTS := ./CmodA7_Master.xdc

# ------------------------------------------------------------------------------
PROJNAME := $(notdir $(CURDIR))

ROOT := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

OUTDIR := $(ROOT)/out
REPORTDIR := $(OUTDIR)/report

LOG := $(OUTDIR)/$(PROJNAME).log
JOURNAL := $(OUTDIR)/$(PROJNAME).jou

VIVADOARGS := -mode batch -notrace
VIVADOARGS += -tempDir $(OUTDIR) -log $(LOG) -journal $(JOURNAL)
VIVADOARGS += -source vivado_script.tcl
# Start of custom tcl args
VIVADOARGS += -tclargs
VIVADOARGS += -projname $(PROJNAME) 
VIVADOARGS += -partname $(PARTNAME)
VIVADOARGS += -vhdls $(VHDLS)
VIVADOARGS += -constraints $(CONSTRAINTS)
# End of custom tcl args

ifeq ($(OS),Windows_NT)
define MKDIR
	if not exist "$(1)" mkdir "$(1)"
endef
define RMDIR
	if exist "$(1)" rmdir /s /q "$(1)"
endef
define RM
	del /q "$(1)" 2>nul
endef
else
define MKDIR
	mkdir -p $(1)
endef
define RMDIR
	rm -rf $(1)
endef
define RM
	rf -f "$(1)"
endef
endif

all:
	$(call MKDIR,$(OUTDIR))
	$(call MKDIR,$(REPORTDIR))
	vivado $(VIVADOARGS)

clean:
	$(call RMDIR,$(OUTDIR))
	$(call RM,usage_statistics_webtalk.html)
	$(call RM,usage_statistics_webtalk.xml)

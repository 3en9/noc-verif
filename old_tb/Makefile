#-----------------------------------------------------------------------------
# Common settings
#-----------------------------------------------------------------------------
ifeq ($(OS),Windows_NT)
    RM = del /Q
    RMDIR = rmdir /s /q
    CREATE_DIR = if not exist $1 mkdir $1
else
    RM = rm -f
    RMDIR = rm -rf
    CREATE_DIR = mkdir -p $1
endif

#-----------------------------------------------------------------------------
# Verification parameters
#-----------------------------------------------------------------------------

RTL ?= /
BASE_ROUTER_TB = ../base_tb/base_router_tb
BASE_NOC_TB    = ../base_tb/base_noc_tb
ROUTER_TB = old_router_tb
NOC_TB = old_noc_tb

#-----------------------------------------------------------------------------
# Defines
#-----------------------------------------------------------------------------
TOPOLOGY ?= MESH_TORUS
PL ?= 32
CS ?= 2
REN ?= 5
X ?= 4
Y ?= 4
RN ?= 16

MASTER_ROUTER_F ?= 0
MASTER_ROUTER_S ?= 0

DEFINES = +define+PL=$(PL) +define+CS=$(CS) +define+REN=$(REN) +define+RN=$(RN) +define+$(TOPOLOGY) +define+X=$(X) +define+Y=$(Y) +define+MASTER_ROUTER_F=$(MASTER_ROUTER_F) +define+MASTER_ROUTER_S=$(MASTER_ROUTER_S)

#-----------------------------------------------------------------------------
# Target selection (router or noc)
#-----------------------------------------------------------------------------
TARGET ?= noc

ifeq ($(TARGET),router)
	CHILD_TB = $(ROUTER_TB)
    TEST ?= old_router_rand_test
    PACKETS_COUNT ?= 100
    SRC_PORT ?= -1
    DEST_ROUTER ?= -1
    RAND_READY ?= 100
    STRESS_MODE ?= 0
	COMP_ARGS = -sv $(DEFINES) +incdir+$(CHILD_TB) $(CHILD_TB)/old_router_package.sv $(CHILD_TB)/tb_top.sv
	TOP_LEVEL = tb_top
	COV_INST_NAME = dut
    SIM_ARGS = +UVM_TESTNAME=$(TEST) \
               +ROUTERS_NUM=$(RN) \
               +PACKETS_COUNT=$(PACKETS_COUNT) \
               +SRC_PORT=$(SRC_PORT) \
               +DEST_ROUTER=$(DEST_ROUTER) \
               +RAND_READY=$(RAND_READY) \
               +STRESS_MODE=$(STRESS_MODE)
else
	CHILD_TB = $(NOC_TB)
    TEST ?= old_noc_rand_test
    PACKETS_COUNT ?= 100
    RAND_READY ?= 100
    SRC_ROUTER ?= -1
    DEST_ROUTER ?= -1
    STRESS_MODE ?= 0
    AGENT_ACTIVE ?= 1
	COMP_ARGS = -sv $(DEFINES) +incdir+$(CHILD_TB) $(CHILD_TB)/old_noc_package.sv $(CHILD_TB)/tb_top.sv
	TOP_LEVEL = tb_top
	COV_INST_NAME = dut
    SIM_ARGS = +UVM_TESTNAME=$(TEST) \
               +PACKETS_COUNT=$(PACKETS_COUNT) \
               +RAND_READY=$(RAND_READY) \
               +SRC_ROUTER=$(SRC_ROUTER) \
               +DEST_ROUTER=$(DEST_ROUTER) \
               +AGENT_ACTIVE=$(AGENT_ACTIVE)
endif

#-----------------------------------------------------------------------------
# Coverage settings
#-----------------------------------------------------------------------------
COVERAGE ?= 0
COVERAGE_TYPES = bcest
COV_DB = coverage_db
COVERAGE_FILE = $(COV_DB)/cov.ucdb
COVERAGE_REPORT_FILE = $(COV_DB)/cov_report.txt
COVERAGE_HTML_DIR = $(COV_DB)/html

ifeq ($(COVERAGE),1)
    VLOG_COVERAGE_FLAGS = -cover $(COVERAGE_TYPES) -covercells
    VSIM_COVERAGE_FLAGS = -coverage
    POST_SIM_CMD = -do "coverage save -onexit $(COVERAGE_FILE); log -r /*; run -all; quit"
else
    VLOG_COVERAGE_FLAGS =
    VSIM_COVERAGE_FLAGS =
    POST_SIM_CMD = -do "log -r /*; run -all; quit"
endif

#-----------------------------------------------------------------------------
# Targets
#-----------------------------------------------------------------------------
init:
	$(call CREATE_DIR,$(COV_DB))
	vlib work
	vmap work work

rtl_compile: init
	vlog -sv $(VLOG_COVERAGE_FLAGS) +incdir+$(RTL) $(RTL)/inc/*.svh $(RTL)/src/*.sv $(RTL)/noc/*.sv

base_tb_compile: rtl_compile
	vlog -sv +incdir+$(BASE_ROUTER_TB) +incdir+$(BASE_NOC_TB) $(BASE_ROUTER_TB)/base_router_package.sv $(BASE_NOC_TB)/base_noc_package.sv

tb_compile: base_tb_compile
	vlog -sv $(COMP_ARGS)

sim: tb_compile
	vsim -novopt $(VSIM_COVERAGE_FLAGS) -c $(POST_SIM_CMD) $(TOP_LEVEL) $(SIM_ARGS)

clean:
	-$(RM) modelsim.ini tr_db.log transcript vsim.wlf
	-$(RMDIR) work 
	-$(RMDIR) $(COV_DB)

view_cov:
	vsim -viewcov $(COVERAGE_FILE)

cov_report:
	vsim -c -do "coverage report -file $(COVERAGE_REPORT_FILE) -lines -code $(COVERAGE_TYPES); quit" -viewcov $(COVERAGE_FILE)

cov_html_report:
	vsim -c -do "coverage report -html -htmldir $(COVERAGE_HTML_DIR) -code $(COVERAGE_TYPES); quit" -viewcov $(COVERAGE_FILE)

view_wave:
	vsim -view vsim.wlf -do "add wave -r /$(TOP_LEVEL)/$(COV_INST_NAME)/*"

help:
	@echo ==========================================
	@echo Available Commands:
	@echo ==========================================
	@echo make sim TARGET=router   - Run router simulation
	@echo make sim TARGET=noc      - Run NoC simulation (default)
	@echo make sim COVERAGE=1      - Run with coverage collection
	@echo make view_cov            - View coverage results
	@echo make cov_report          - Generate text coverage report
	@echo make cov_html_report     - Generate html coverage report
	@echo make view_wave           - View waveforms
	@echo make clean               - Clean all generated files
	@echo ==========================================
	@echo Router parameters (TARGET=router):
	@echo   TEST=name        - Test name
	@echo   PACKETS_COUNT=N  - Number of packets (default: 100)
	@echo   SRC_PORT=N       - Source port (default: -1 random)
	@echo   DEST_ROUTER=N    - Destination router (default: -1 random)
	@echo   STRESS_MODE=N    - Stress mode (default: 0)
	@echo ==========================================
	@echo NoC parameters (TARGET=noc):
	@echo   TEST=name        - Test name
	@echo   PACKETS_COUNT=N  - Number of packets (default: 100)
	@echo   SRC_ROUTER=N     - Source router (default: -1 random)
	@echo   DEST_ROUTER=N    - Destination router (default: -1 random)
	@echo   STRESS_MODE=N    - Stress mode (default: 0)
	@echo   AGENT_ACTIVE=1   - UVM_ACTIVE/PASSIVE (default: 1)
	@echo ==========================================
	@echo Common parameters:
	@echo   RAND_READY=N%%    - Ready probability (default: 100)
	@echo   COVERAGE=1       - Enable coverage collection
	@echo ==========================================
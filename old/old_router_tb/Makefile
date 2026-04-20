ifeq ($(OS),Windows_NT)
    RM = del /Q
else
    RM = rm -f
endif

ifeq ($(OS),Windows_NT)
    RMDIR = rmdir /s /q
else
    RMDIR = rm -rf
endif

SIMULATOR_PATH ?= C:/modeltech64_10.4c
UVM_HOME = $(SIMULATOR_PATH)/verilog_src/uvm-1.2
UVM_DPI = $(SIMULATOR_PATH)/uvm-1.2/win64/uvm_dpi
UVM_SRC  = $(UVM_HOME)/src

BASE_TB  = ../../base_tb/base_router_tb
CHILD_TB = .
RTL = ../old_rtl

COVERAGE ?= 0
COVERAGE_TYPES = bcestf
COV_DB = coverage_db
COVERAGE_FILE = $(COV_DB)/cov.ucdb
COVERAGE_REPORT_FILE = $(COV_DB)/cov_report.txt
VLOG_COVERAGE_FLAGS = 
VSIM_COVERAGE_FLAGS = 
POST_SIM_CMD = -do "log -r /*; run -all; quit"
ifeq ($(COVERAGE),1)
	VLOG_COVERAGE_FLAGS = -cover $(COVERAGE_TYPES)
	VSIM_COVERAGE_FLAGS = -coverage
	POST_SIM_CMD = -do "coverage save -onexit $(COVERAGE_FILE); log -r /*; run -all; quit"
else
	VLOG_COVERAGE_FLAGS =
	VSIM_COVERAGE_FLAGS =
	POST_SIM_CMD = -do "log -r /*; run -all; quit"
endif

ifeq ($(OS),Windows_NT)
    CREATE_COV_DB = if not exist $(COV_DB) mkdir $(COV_DB)
else
    CREATE_COV_DB = mkdir -p $(COV_DB)
endif


TEST ?= old_router_sample_test

PACKETS_COUNT ?= 100
SRC_PORT ?= -1
DEST_ROUTER ?= -1
ROUTERS_NUM ?= 16
RAND_READY ?= 100
STRESS_MODE ?= 0

TOPOLOGY = MESH_TORUS
PL = 32
CS = 2
REN = 5
X = 4
Y = 4

init:
	$(CREATE_COV_DB)
	vlib work
	vmap work work
	vlog -sv +incdir+$(UVM_SRC) $(UVM_SRC)/uvm_pkg.sv

rtl_compile: init
	vlog -sv $(VLOG_COVERAGE_FLAGS) +incdir+$(RTL) $(RTL)/inc/*.svh $(RTL)/src/router.sv

base_tb_compile: rtl_compile
	vlog -sv +incdir+$(UVM_SRC) +incdir+$(BASE_TB) $(BASE_TB)/base_router_package.sv

tb_compile: base_tb_compile
	vlog -sv +incdir+$(UVM_SRC) +incdir+$(CHILD_TB) $(CHILD_TB)/old_router_package.sv +define+PL=$(PL) +define+CS=$(CS) +define+REN=$(REN) +define+$(TOPOLOGY) +define+X=$(X) +define+Y=$(Y)
	vlog -sv $(CHILD_TB)/tb_top.sv +define+$(TOPOLOGY) +define+CS=$(CS)

sim: tb_compile
	vsim -sv_lib $(UVM_DPI) -novopt $(VSIM_COVERAGE_FLAGS) -c $(POST_SIM_CMD) \
						tb_top \
						+UVM_TESTNAME=$(TEST) \
						+ROUTERS_NUM=$(ROUTERS_NUM) \
						+PACKETS_COUNT=$(PACKETS_COUNT) \
						+SRC_PORT=$(SRC_PORT) \
						+DEST_ROUTER=$(DEST_ROUTER) \
						+RAND_READY=$(RAND_READY) \
						+STRESS_MODE=$(STRESS_MODE)

clean:
	$(RM) modelsim.ini tr_db.log transcript vsim.wlf
	$(RMDIR) work
	$(RMDIR) $(COV_DB)

view_cov:
	vsim -viewcov $(COVERAGE_FILE)

cov_report:
	vsim -c -do "coverage report -file $(COVERAGE_REPORT_FILE) -lines -code $(COVERAGE_TYPES); quit" -viewcov $(COVERAGE_FILE)

view_wave:
	vsim -view vsim.wlf -do "add wave -r /tb_top/dut/*"



help:
	@echo ==========================================
	@echo Available Commands:
	@echo ==========================================
	@echo make sim            - Run simulation without coverage
	@echo make sim COVERAGE=1 - Run simulation with coverage collection
	@echo make view_cov       - View coverage results (after sim with COVERAGE=1)
	@echo make cov_report     - Generate text coverage report
	@echo make view_wave      - View waveforms
	@echo make clean          - Clean all generated files
	@echo ==========================================
	@echo Test parameters:
	@echo   TEST=name        - Test name (e.g.: old_router_sample_test)
	@echo   PACKETS_COUNT=N  - Number of sending packets (default: 100)
	@echo   ROUTERS_NUM=N    - Number of routers in NoC (default: 16)
	@echo   SRC_PORT=N       - Number of source sender port (default: -1 - random)
	@echo   DEST_ROUTER=N    - Number of destination router (default: -1 - random)
	@echo   STRESS_MODE=N    - Enable stress mode, every port sends packets (default: 0)
	@echo   RAND_READY=N%%    - Ready probability (default: 100)
	@echo   COVERAGE=1       - Enable coverage collection
	@echo ==========================================
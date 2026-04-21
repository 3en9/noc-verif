# Верификация сетей на кристалле для HDLNoCGEN

Базовые окружения base_noc_tb и base_router_tb адаптированы под конкретную реализацию сети, сгенерированной программой HDLNoCGEN  

Для запуска тестов необходим ModelSim/QuestaSim с поддержкой UVM  
Порядок запуска:  
`make -C program/Makefile`  
`bin\generator.exe <rtl_path> <topology> <PL> <CS> <REN> <X> <Y> <RN>`  
После успешной генерации Makefile:  
`make help` - для получения справки  
vdel -all
vlog -source  -lint *.sv *.svp
#vsim  work.top
vsim -voptargs=+acc work.top
add wave -position insertpoint sim:/top/*
add wave -position insertpoint sim:/top/DUT/*
run -all

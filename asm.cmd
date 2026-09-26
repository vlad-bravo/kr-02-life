@echo off
del LIFE.BIN
..\retroassembler\retroassembler.exe LIFE.ASM
fc /b life.rkr life.bin

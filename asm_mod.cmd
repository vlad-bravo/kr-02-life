@echo off

del life_mod.rkr 2>nul
del *.o 2>nul

C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o life.o life_mod.asm

C:\dev\wla_dx_v10.6_Win64\wlalink.exe link_mod.cfg life_mod.rkr

del *.o 2>nul

fc /b life.rkr life_mod.rkr

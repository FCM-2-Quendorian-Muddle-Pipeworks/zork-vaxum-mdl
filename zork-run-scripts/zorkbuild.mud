<SETG NL <ASCII 10>>

<DEFINE RUN-CHECK (STATUS OPERATION)
  <COND
    (<NOT <0? .STATUS>>
      <PRINC "zorkbuild: process failed: ">
      <PRINC .OPERATION>
      <PRINC " (exit ">
      <PRINC .STATUS>
      <PRINC ")">
      <PRINC ,NL>
      <QUIT>)>>

<PRINC "Building Dungeon 3.2b (Fortran)">
<PRINC ,NL>

<RUN-CHECK
  <GIRGOL-EXECUTE
    "make"
    ["-C" "dungeon_3_2b" "FC=gfortran"]
    "">
  "Dungeon 3.2b build">

<PRINC "Dungeon 3.2b (Fortran) build completed.">
<PRINC ,NL>

<QUIT>

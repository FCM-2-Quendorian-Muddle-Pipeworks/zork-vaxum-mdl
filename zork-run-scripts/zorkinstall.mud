
<SETG NL <ASCII 10>>

<DEFINE ZORK-INSTALL-CHECK (STATUS OPERATION)
  <COND
    (<NOT <0? .STATUS>>
      <PRINC "zorkinstall: operation failed: ">
      <PRINC .OPERATION>
      <PRINC ,NL>
      <QUIT>)>>

<DEFINE ZORK-INSTALL-RUN (PROGRAM ARGS OPERATION)
  <ZORK-INSTALL-CHECK
    <GIRGOL-EXECUTE .PROGRAM .ARGS "">
    .OPERATION>>

<DEFINE ZORK-INSTALL-GAME (VERSION SHARE)
  <PROG ((DEST <STRING .SHARE "/mdlzork_" .VERSION>)
         (SOURCE
          <STRING
            "mdlzork_" .VERSION "/patched_confusion">))
    <ZORK-INSTALL-RUN
      "mkdir" ["-p" .DEST]
      <STRING "create game directory " .VERSION>>
    <ZORK-INSTALL-RUN
      "cp" ["-R" .SOURCE .DEST]
      <STRING "copy game tree " .VERSION>>
    <PRINC "Installed game tree ">
    <PRINC .VERSION>
    <PRINC ,NL>>>

<DEFINE ZORK-INSTALL ()
  <PROG
    ((OUT <GIRGOL-GETENV "ZORK_VAXUM_INSTALL_PREFIX">)
     (EXPECT-PREFIX <GIRGOL-GETENV "ZORK_VAXUM_EXPECT_PREFIX">)
     (SHARE <>)
     (LIBEXEC <>)
     (EXPECT <>))

    <SET SHARE <STRING .OUT "/share/zork-vaxum-mdl">>
    <SET LIBEXEC <STRING .OUT "/libexec/zork-vaxum-mdl">>
    <SET EXPECT <STRING .EXPECT-PREFIX "/bin/expect">>

    <ZORK-INSTALL-CHECK
      <GIRGOL-EXECUTE "test" ["-x" .EXPECT] "">
      "check Expect executable">

    <ZORK-INSTALL-RUN
      "mkdir" ["-p" .SHARE .LIBEXEC]
      "create installation directories">

    <ZORK-INSTALL-RUN
      "ln" ["-s" .EXPECT <STRING .LIBEXEC "/expect">]
      "install Expect link">

    <ZORK-INSTALL-RUN
      "cp" ["-R" "dungeon_3_2b" .SHARE]
      "install Dungeon 3.2b">

    <ZORK-INSTALL-GAME "771212" .SHARE>
    <ZORK-INSTALL-GAME "780124" .SHARE>
    <ZORK-INSTALL-GAME "791211" .SHARE>
    <ZORK-INSTALL-GAME "810722" .SHARE>

    <ZORK-INSTALL-RUN
      "cp"
      ["-R"
       "mdlzork_780402"
       "zork_285"
       "mdlzork_binaries_for_pdp-10_its"
       .SHARE]
      "install reference trees">

    <ZORK-INSTALL-RUN
      "cp"
      ["zork-run-scripts/zorkmenu.mud"
       "zork-run-scripts/zorkrun.mud"
       "zork-run-scripts/zorkintro.mud"
       .SHARE]
      "install MDL runtime scripts">

    <ZORK-INSTALL-RUN
      "cp"
      ["zork-run-scripts/zork-restore.exp" .LIBEXEC]
      "install Expect restore script">

    <PRINC "Zork VAXUM MDL installation completed.">
    <PRINC ,NL>>>

<ZORK-INSTALL>
<QUIT>

<SETG NL <ASCII 10>>
<SETG ROOT <GIRGOL-GETCWD>>
<SETG MDLI "mdli">

<DEFINE INSTALL-CHECK (RESULT OPERATION)
  <COND
    (<NOT .RESULT>
      <PRINC "zorkinstall: operation failed: ">
      <PRINC .OPERATION>
      <PRINC ,NL>
      <QUIT>)>>

<DEFINE INSTALL-RUN-CHECK (STATUS OPERATION)
  <COND
    (<NOT <0? .STATUS>>
      <PRINC "zorkinstall: process failed: ">
      <PRINC .OPERATION>
      <PRINC " (exit ">
      <PRINC .STATUS>
      <PRINC ")">
      <PRINC ,NL>
      <QUIT>)>>

<DEFINE INSTALL-GENERATE-SEED (VERSION)
  <PROG ((SEED "MDL/MADADV.SAVE"))

    <PRINC "Generating interpreter seed for ">
    <PRINC .VERSION>
    <PRINC ,NL>

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE "rm" ["-f" .SEED] "">
      <STRING "remove previous seed for " .VERSION>>

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        ,MDLI
        []
        <STRING
          "<FLOAD "
          <ASCII 34>
          "run.mud"
          <ASCII 34>
          ">"
          ,NL>>
      <STRING "generate seed for " .VERSION>>

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE "test" ["-s" .SEED] "">
      <STRING "verify generated seed for " .VERSION>>

    <INSTALL-CHECK
      <GIRGOL-CHMOD .SEED 292>
      <STRING "make seed read-only for " .VERSION>>

    <PRINC "Generated interpreter seed for ">
    <PRINC .VERSION>
    <PRINC ,NL>>>

<DEFINE INSTALL-GAME (VERSION SHARE)
  <PROG ((DEST <STRING .SHARE "/mdlzork_" .VERSION>)
         (SOURCE
          <STRING
            "mdlzork_" .VERSION "/patched_confusion">))

    <INSTALL-CHECK
      <GIRGOL-CHDIR .SOURCE>
      <STRING "enter game tree " .VERSION>>

    <INSTALL-GENERATE-SEED .VERSION>

    <INSTALL-CHECK
      <GIRGOL-CHDIR ,ROOT>
      "return to repository root">

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE "mkdir" ["-p" .DEST] "">
      <STRING "create game directory " .VERSION>>

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "cp"
        ["-R" .SOURCE .DEST]
        "">
      <STRING "install game tree " .VERSION>>

    <PRINC "Installed game tree ">
    <PRINC .VERSION>
    <PRINC ,NL>>>

<DEFINE ZORK-INSTALL ()
  <PROG
    ((OUT <GIRGOL-GETENV "ZORK_VAXUM_INSTALL_PREFIX">)
     (EXPECT-PREFIX <GIRGOL-GETENV "ZORK_VAXUM_EXPECT_PREFIX">)
     (SHARE <>)
     (LIBEXEC <>)
     (BIN <>)
     (EXPECT <>))

    <SET SHARE <STRING .OUT "/share/zork-vaxum-mdl">>
    <SET LIBEXEC <STRING .OUT "/libexec/zork-vaxum-mdl">>
    <SET BIN <STRING .OUT "/bin">>
    <SET EXPECT <STRING .EXPECT-PREFIX "/bin/expect">>

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE "test" ["-x" .EXPECT] "">
      "check Expect executable">

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "mkdir"
        ["-p" .SHARE .LIBEXEC .BIN]
        "">
      "create installation directories">

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "ln"
        ["-s" .EXPECT <STRING .LIBEXEC "/expect">]
        "">
      "install Expect link">

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "cp"
        ["-R" "dungeon_3_2b" .SHARE]
        "">
      "install Dungeon 3.2b">

    <INSTALL-GAME "771212" .SHARE>
    <INSTALL-GAME "780124" .SHARE>
    <INSTALL-GAME "791211" .SHARE>
    <INSTALL-GAME "810722" .SHARE>

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "cp"
        ["-R"
         "mdlzork_780402"
         "zork_285"
         "mdlzork_binaries_for_pdp-10_its"
         .SHARE]
        "">
      "install reference trees">

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "cp"
        ["zork-run-scripts/zorkmenu.mud"
         "zork-run-scripts/zorkrun.mud"
         "zork-run-scripts/zorkintro.mud"
         .SHARE]
        "">
      "install MDL runtime scripts">

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "cp"
        ["zork-run-scripts/zork-restore.exp" .LIBEXEC]
        "">
      "install Expect restore script">

    <INSTALL-RUN-CHECK
      <GIRGOL-EXECUTE
        "cp"
        ["zork-run-scripts/zork-mdl" .BIN]
        "">
      "install zork-mdl launcher">

    <INSTALL-CHECK
      <GIRGOL-CHMOD
        <STRING .BIN "/zork-mdl">
        493>
      "make zork-mdl executable">

    <PRINC "Zork VAXUM MDL installation completed.">
    <PRINC ,NL>>>

<ZORK-INSTALL>
<QUIT>

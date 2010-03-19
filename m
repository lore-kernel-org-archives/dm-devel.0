From: heinzm@sourceware.org
Subject: dmraid include/dmraid/lib_context.h lib/log/lo ...
Date: 19 Mar 2010 12:07:49 -0000
Message-ID: <20100319120749.2296.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2010-03-19 12:07:48

Modified files:
	include/dmraid : lib_context.h 
	lib/log        : log.h 
	lib/metadata   : metadata.c 
	tools          : commands.c 

Log message:
	Added pthread lib to tools build. Removed superfluous DMRAID_MINI conditionals and sorted option definitions in commands.c

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/lib_context.h.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/log/log.h.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/include/dmraid/lib_context.h	2010/03/18 13:10:42	1.5
+++ dmraid/include/dmraid/lib_context.h	2010/03/19 12:07:47	1.6
@@ -133,23 +133,18 @@
 	ACTIVATE = 0x1,
 	DEACTIVATE = 0x2,
 	FORMAT = 0x4,
-#ifndef	DMRAID_MINI
 	BLOCK_DEVICES = 0x8,
 	COLUMN = 0x10,
 	DBG = 0x20,
 	DUMP = 0x40,
 	DMERASE = 0x80,
 	GROUP = 0x100,
-#endif
 	HELP = 0x200,
-#ifndef	DMRAID_MINI
 	LIST_FORMATS = 0x400,
 #  ifdef	DMRAID_NATIVE_LOG
 	NATIVE_LOG = 0x800,
 #  endif
-#endif
 	NOPARTITIONS = 0x1000,
-#ifndef	DMRAID_MINI
 	RAID_DEVICES = 0x2000,
 	RAID_SETS = 0x4000,
 	TEST = 0x8000,
@@ -157,10 +152,8 @@
 	ACTIVE = 0x20000,
 	INACTIVE = 0x40000,
 	SEPARATOR = 0x80000,
-#endif
 	VERSION = 0x100000,
 	IGNORELOCKING = 0x200000,
-#ifndef DMRAID_MINI
 	DEL_SETS = 0x400000,
 	CREATE = 0x800000,
 	REBUILD = 0x1000000,
@@ -169,12 +162,8 @@
 	END_REBUILD = 0x8000000,
 	GET_MEMBERS = 0x10000000,
 	PARTCHAR = 0x20000000,
-
-#endif
 	RMPARTITIONS = 0x40000000,
-#ifndef DMRAID_MINI
 	IGNOREMONITORING = 0x80000000,
-#endif
 };
 
 /* Arguments allowed ? */
--- dmraid/lib/log/log.h	2008/02/22 16:57:36	1.1
+++ dmraid/lib/log/log.h	2010/03/19 12:07:48	1.2
@@ -26,21 +26,6 @@
 	  int line, const char *format, ...);
 int log_alloc_err(struct lib_context *lc, const char *who);
 
-#  ifdef DMRAID_MINI
-
-#define log_info(lc, x...)
-#define log_info_nnl(lc, x...)
-#define log_notice(lc, x...)
-#define log_notice_nnl(lc, x...)
-#define log_warn(lc, x...)
-#define log_warn_nn(lc, x...)
-#define log_debug(lc, x...)
-#define log_debug_nnl(lc, x...)
-#define log_dbg(lc, x...)
-#define log_dbg_nnl(lc, x...)
-
-#  else
-
 #define _log_info(lc, lf, x...) plog(lc, _PLOG_INFO, lf, __FILE__, __LINE__, x)
 #define log_info(lc, x...) _log_info(lc, 1, x)
 #define log_info_nnl(lc, x...) _log_info(lc, 0, x)
@@ -61,8 +46,6 @@
 #define log_dbg(lc, x...) log_debug(lc, x)
 #define log_dbg_nnl(lc, x...) log_debug_nnl(lc, x)
 
-#  endif
-
 #define	log_level(lc, level, x...) plog(lc, level, 1, __FILE__, __LINE__, x)
 #define	log_level_nnl(lc, level, x...) plog(lc, level, 0, __FILE__, __LINE__, x)
 
--- dmraid/lib/metadata/metadata.c	2010/03/18 16:53:17	1.10
+++ dmraid/lib/metadata/metadata.c	2010/03/19 12:07:48	1.11
@@ -2102,7 +2102,6 @@
 	if (!(M_RAID & p->metadata))
 		return 1;
 
-#ifndef	DMRAID_MINI
 	/* Discover RAID disks and keep RAID metadata (eg, hpt45x) */
 	discover_raid_devices(lc,
 # ifdef	DMRAID_NATIVE_LOG
@@ -2111,9 +2110,6 @@
 # else
 			      (RAID_DEVICES & action) ? argv : NULL);
 # endif
-#else
-	discover_raid_devices(lc, NULL);
-#endif
 
 	if (!OPT_HOT_SPARE_SET(lc) && !OPT_CREATE(lc)
 	    && !count_devices(lc, RAID)) {
--- dmraid/tools/commands.c	2010/03/18 13:10:43	1.7
+++ dmraid/tools/commands.c	2010/03/19 12:07:48	1.8
@@ -31,50 +31,43 @@
  * Command line options.
  */
 static char const *short_opts = "a:hipP:"
-#ifndef	DMRAID_MINI
 	"bc::dDEf:gIlxM:"
 #ifdef	DMRAID_NATIVE_LOG
 	"n"
 #endif
-	"rR:s::tv"
-#endif
-	"VC:S::Z";
+	"rR:s::tvVC:S::Z";
 
 #ifdef HAVE_GETOPTLONG
 static struct option long_opts[] = {
 	{"activate", required_argument, NULL, 'a'},
-	{"format", required_argument, NULL, 'f'},
-	{"partchar", required_argument, NULL, 'P'},
-	{"no_partitions", no_argument, NULL, 'p'},
-# ifndef DMRAID_MINI
 	{"block_devices", no_argument, NULL, 'b'},
-	{"display_columns", optional_argument, NULL, 'c'},
+	{"create", required_argument, NULL, 'C'},
 	{"debug", no_argument, NULL, 'd'},
+	{"display_columns", optional_argument, NULL, 'c'},
+	{"display_group", no_argument, NULL, 'g'},
 	{"dump_metadata", no_argument, NULL, 'D'},
+	{"format", required_argument, NULL, 'f'},
 	{"erase_metadata", no_argument, NULL, 'E'},
-	{"display_group", no_argument, NULL, 'g'},
-# endif
 	{"help", no_argument, NULL, 'h'},
 	{"ignorelocking", no_argument, NULL, 'i'},
-# ifndef DMRAID_MINI
+	{"ignoremonitoring", no_argument, NULL, 'I'},
 	{"list_formats", no_argument, NULL, 'l'},
 	{"media", required_argument, NULL, 'M'},
 #  ifdef DMRAID_NATIVE_LOG
 	{"native_log", no_argument, NULL, 'n'},
 #  endif
+	{"no_partitions", no_argument, NULL, 'p'},
+	{"partchar", required_argument, NULL, 'P'},
 	{"raid_devices", no_argument, NULL, 'r'},
 	{"rebuild", required_argument, NULL, 'R'},
-	{"sets", optional_argument, NULL, 's'},
 	{"remove", no_argument, NULL, 'x'},
+	{"rm_partitions", no_argument, NULL, 'Z'},
+	{"sets", optional_argument, NULL, 's'},
 	{"separator", required_argument, NULL, SEPARATOR},	/* long only. */
+	{"spare", optional_argument, NULL, 'S'},
 	{"test", no_argument, NULL, 't'},
 	{"verbose", no_argument, NULL, 'v'},
-# endif
 	{"version", no_argument, NULL, 'V'},
-	{"create", required_argument, NULL, 'C'},
-	{"spare", optional_argument, NULL, 'S'},
-	{"rm_partitions", no_argument, NULL, 'Z'},
-	{"ignoremonitoring", no_argument, NULL, 'I'},
 	{NULL, no_argument, NULL, 0}
 };
 #endif /* #ifdef HAVE_GETOPTLONG */
@@ -120,7 +113,6 @@
 	return check_optarg(lc, 'a', def);
 }
 
-#ifndef	DMRAID_MINI
 /* Check active/inactive option arguments. */
 static int
 check_active(struct lib_context *lc, struct actions *a)
@@ -209,7 +201,6 @@
 	lc_inc_opt(lc, a->arg);
 	return 1;
 }
-#endif
 
 /* Check and store option for partition separator. */
 static int
@@ -227,18 +218,6 @@
 {
 	char *c = lc->cmd;
 
-#ifdef	DMRAID_MINI
-	log_print(lc, "%s: Device-Mapper Software RAID tool "
-		  "[Early Boot Version]\n", c);
-	log_print(lc, "%s\t{-a|--activate} {y|n|yes|no} [-i|--ignorelocking]\n" 
-		  "\t[-f|--format fORMAT[,FORMAT...]]\n"
-		  "\t[-P|--partchar CHAR]\n"
-		  "\t[-p|--no_partitions]\n"
-		  "\t[-Z|--rm_partitions]\n"
-		  "\t[--separator SEPARATOR]\n" "\t[RAID-set...]\n", c);
-	log_print(lc, "%s\t{-h|--help}\n", c);
-	log_print(lc, "%s\t{-V/--version}\n", c);
-#else
 	log_print(lc, "%s: Device-Mapper Software RAID tool\n", c);
 	log_print(lc,
 		  "* = [-d|--debug]... [-v|--verbose]... [-i|--ignorelocking]\n");
@@ -285,7 +264,6 @@
 		  "\t{-S|--spare [RAID-set]} \n"
 		  "\t{-M|--media \"device-path\"}\n", c);
 	log_print(lc, "%s\t{-V/--version}\n", c);
-#endif
 	return 1;
 }
 
@@ -298,69 +276,16 @@
 static struct actions actions[] = {
 	/* [De]activate option. */
 	{'a',
-	 UNDEF,			/* Set in check_activate() by mandatory option argument. */
+	 UNDEF,	 /* Set in check_activate() by mandatory option argument. */
 	 UNDEF,
-	 ACTIVATE | DEACTIVATE | FORMAT | HELP | IGNORELOCKING | NOPARTITIONS |
-	 SEPARATOR | RMPARTITIONS
-#ifndef DMRAID_MINI
-	 | DBG | TEST | VERBOSE | IGNOREMONITORING
-#endif
-	 , ARGS,
+	 ACTIVATE | DBG | DEACTIVATE | FORMAT | HELP | IGNORELOCKING |
+	 IGNOREMONITORING | NOPARTITIONS | RMPARTITIONS | SEPARATOR |
+	 TEST | VERBOSE,
+	 ARGS,
 	 check_activate,
 	 0,
 	 },
 
-	/* Format option. */
-	{'f',
-	 FORMAT,
-	 ACTIVATE | DEACTIVATE | IGNORELOCKING
-#ifndef DMRAID_MINI
-#  ifdef DMRAID_NATIVE_LOG
-	 | NATIVE_LOG
-#  endif
-	 | RAID_DEVICES | RAID_SETS,
-	 ACTIVE | INACTIVE | COLUMN | DBG | DUMP | DMERASE | GROUP | HELP |
-	 NOPARTITIONS | SEPARATOR | TEST | VERBOSE | RMPARTITIONS |
-	 IGNOREMONITORING
-#else
-	 , UNDEF
-#endif
-	 , ARGS,
-#ifndef DMRAID_MINI
-	 check_identifiers,
-#else
-	 NULL,
-#endif
-	 LC_FORMAT,
-	 },
-
-	/* Partition separator. */
-	{'P',
-	 PARTCHAR,
-	 ACTIVATE | DEACTIVATE,
-	 FORMAT | HELP | IGNORELOCKING | SEPARATOR | RMPARTITIONS
-#ifndef DMRAID_MINI
-	 | DBG | TEST | VERBOSE | IGNOREMONITORING
-#endif
-	 , ARGS,
-	 check_part_separator,
-	 0,
-	 },
-
-	/* Partition option. */
-	{'p',
-	 NOPARTITIONS,
-	 ACTIVATE | DEACTIVATE,
-	 FORMAT | HELP | IGNORELOCKING | SEPARATOR | RMPARTITIONS
-#ifndef DMRAID_MINI
-	 | DBG | TEST | VERBOSE | IGNOREMONITORING
-#endif
-	 , ARGS,
-	 NULL,
-	 0,
-	 },
-
-#ifndef	DMRAID_MINI
 	/* Block devices option. */
 	{'b',
 	 BLOCK_DEVICES,
@@ -375,13 +300,23 @@
 	{'c',
 	 COLUMN,
 	 BLOCK_DEVICES | RAID_DEVICES | RAID_SETS,
-	 ACTIVE | INACTIVE | DBG | DUMP | FORMAT | GROUP | HELP | IGNORELOCKING
-	 | SEPARATOR | VERBOSE,
+	 ACTIVE | INACTIVE | DBG | DUMP | FORMAT | GROUP | HELP |
+	 IGNORELOCKING | SEPARATOR | VERBOSE,
 	 ARGS,
 	 check_identifiers,
 	 LC_COLUMN,
 	 },
 
+	/* RAID set creation. */
+	{'C',
+	 CREATE,
+	 UNDEF,
+	 DBG | HELP | IGNORELOCKING | IGNOREMONITORING | VERBOSE,
+	 NO_ARGS,
+	 check_create_argument,
+	 LC_CREATE,
+	 },
+
 	/* Debug option. */
 	{'d',
 	 DBG,
@@ -412,18 +347,33 @@
 	 0,
 	 },
 
+	/* Format option. */
+	{'f',
+	 FORMAT,
+	 ACTIVATE | DEACTIVATE |
+#  ifdef DMRAID_NATIVE_LOG
+	 NATIVE_LOG |
+#  endif
+	 RAID_DEVICES | RAID_SETS,
+	 ACTIVE | INACTIVE | COLUMN | DBG | DUMP | DMERASE | GROUP | HELP |
+	 IGNORELOCKING | NOPARTITIONS | SEPARATOR | TEST |
+	 VERBOSE | RMPARTITIONS,
+	 ARGS,
+	 check_identifiers,
+	 LC_FORMAT,
+	 },
+
 	/* RAID groups option. */
 	{'g',
 	 GROUP,
 	 RAID_SETS,
-	 ACTIVE | INACTIVE | DBG | COLUMN | FORMAT | HELP | IGNORELOCKING
-	 | SEPARATOR | VERBOSE,
+	 ACTIVE | INACTIVE | DBG | COLUMN | FORMAT | HELP |
+	 IGNORELOCKING | SEPARATOR | VERBOSE,
 	 ARGS,
 	 _lc_inc_opt,
 	 LC_GROUP,
 	 },
 
-#endif
 	/* Help option. */
 	{'h',
 	 HELP,
@@ -444,7 +394,17 @@
 	 LC_IGNORELOCKING,
 	 },
 
-#ifndef	DMRAID_MINI
+	/* ignoremonitoring option. */
+	{'I',
+	 IGNOREMONITORING,
+	 ACTIVATE | DEACTIVATE,
+	 DBG | FORMAT | HELP | IGNORELOCKING | NOPARTITIONS |
+	 PARTCHAR | RMPARTITIONS | SEPARATOR | VERBOSE,
+	 ARGS,
+	 _lc_inc_opt,
+	 LC_IGNOREMONITORING,
+	 },
+
 	/* List metadata format handlers option. */
 	{'l',
 	 LIST_FORMATS,
@@ -455,18 +415,17 @@
 	 0,
 	 },
 
-	/* Delete a RAID set option. */
-	{'x',
-	 DEL_SETS,
-	 UNDEF,			//RAID_SETS,
-	 RAID_SETS | INACTIVE | COLUMN | DBG | FORMAT | GROUP | HELP |
-	 IGNORELOCKING | SEPARATOR | VERBOSE,
+	/* Media/drive option */
+	{'M',
+	 MEDIA,
+	 UNDEF,
+	 DBG | HELP | IGNORELOCKING | VERBOSE | REBUILD,
 	 ARGS,
-	 NULL,
-	 0,
+	 check_identifiers,
+	 LC_REBUILD_DISK,
 	 },
 
-#  ifdef DMRAID_NATIVE_LOG
+#ifdef DMRAID_NATIVE_LOG
 	/* Native log option. */
 	{'n',
 	 NATIVE_LOG,
@@ -477,7 +436,29 @@
 	 0,
 	 },
 
-#  endif
+#endif
+	/* No partitions option. */
+	{'p',
+	 NOPARTITIONS,
+	 ACTIVATE | DEACTIVATE,
+	 FORMAT | HELP | IGNORELOCKING | SEPARATOR | RMPARTITIONS
+	 | DBG | TEST | VERBOSE | IGNOREMONITORING,
+	 ARGS,
+	 NULL,
+	 0,
+	 },
+
+	/* Partition separator character option. */
+	{'P',
+	 PARTCHAR,
+	 ACTIVATE | DEACTIVATE,
+	 FORMAT | HELP | IGNORELOCKING | SEPARATOR | RMPARTITIONS
+	 | DBG | TEST | VERBOSE | IGNOREMONITORING,
+	 ARGS,
+	 check_part_separator,
+	 0,
+	 },
+
 	/* Display RAID devices option. */
 	{'r',
 	 RAID_DEVICES,
@@ -493,36 +474,20 @@
 	{'R',
 	 REBUILD,
 	 UNDEF,
-#ifdef DMRAID_MINI
-	 HELP, IGNORELOCKING,
-#else
 	 DBG | HELP | IGNORELOCKING | VERBOSE,
-#endif
 	 ARGS,
-#ifndef DMRAID_MINI
 	 check_identifiers,
-#else
-	 NULL,
-#endif
 	 LC_REBUILD_SET,
 	 },
 
-	/* Media/drive option */
-	{'M',
-	 MEDIA,
+	/* Spare disk creation. */
+	{'S',
+	 SPARE,
 	 UNDEF,
-#ifdef DMRAID_MINI
-	 HELP, IGNORELOCKING,
-#else
-	 DBG | HELP | IGNORELOCKING | VERBOSE | REBUILD,
-#endif
-	 ARGS,
-#ifndef DMRAID_MINI
-	 check_identifiers,
-#else
-	 NULL,
-#endif
-	 LC_REBUILD_DISK,
+	 DBG | HELP | IGNORELOCKING | VERBOSE,
+	 NO_ARGS,
+	 check_spare_argument,
+	 LC_HOT_SPARE_SET,
 	 },
 
 	/* Display RAID sets option. */
@@ -536,7 +501,7 @@
 	 0,
 	 },
 
-	/* Display RAID sets option. */
+	/* Seperator for identifiers (eg. ':' to seperate like "sil:isw"). */
 	{SEPARATOR,
 	 SEPARATOR,
 	 COLUMN | FORMAT,
@@ -546,13 +511,12 @@
 	 0,
 	 },
 
-
 	/* Test run option. */
 	{'t',
 	 TEST,
 	 ACTIVATE | DEACTIVATE,
 	 ACTIVATE | DEACTIVATE | DBG | FORMAT | HELP | IGNORELOCKING |
-	 NOPARTITIONS | VERBOSE,
+	 IGNOREMONITORING | NOPARTITIONS | VERBOSE,
 	 ARGS,
 	 _lc_inc_opt,
 	 LC_TEST,
@@ -567,61 +531,37 @@
 	 _lc_inc_opt,
 	 LC_VERBOSE,
 	 },
-#endif /* #ifndef DMRAID_MINI */
 
 	/* Version option. */
 	{'V',
 	 VERSION,
 	 UNDEF,
-#ifdef DMRAID_MINI
-	 HELP, IGNORELOCKING,
-#else
 	 DBG | HELP | IGNORELOCKING | VERBOSE,
-#endif
 	 NO_ARGS,
 	 NULL,
 	 0,
 	 },
 
-	/* RAID set creation. */
-	{'C',
-	 CREATE,
-	 UNDEF,
-	 DBG | HELP | IGNORELOCKING | VERBOSE,
-	 NO_ARGS,
-	 check_create_argument,
-	 LC_CREATE,
-	 },
-	/* Spare disk creation. */
-	{'S',
-	 SPARE,
-	 UNDEF,
-	 DBG | HELP | IGNORELOCKING | VERBOSE,
-	 NO_ARGS,
-	 check_spare_argument,
-	 LC_HOT_SPARE_SET,
+	/* Delete a RAID set option. */
+	{'x',
+	 DEL_SETS,
+	 UNDEF,			//RAID_SETS,
+	 RAID_SETS | INACTIVE | COLUMN | DBG | FORMAT | GROUP | HELP |
+	 IGNORELOCKING | SEPARATOR | VERBOSE,
+	 ARGS,
+	 NULL,
+	 0,
 	 },
+
 	{'Z',
 	 RMPARTITIONS,
 	 ACTIVATE, /* We cannot undo this on DEACTIVATE ! */
-	 DBG | FORMAT | HELP | IGNORELOCKING | NOPARTITIONS | VERBOSE |
-	 SEPARATOR,
+	 DBG | FORMAT | HELP | IGNORELOCKING | IGNOREMONITORING |
+	 NOPARTITIONS | VERBOSE | SEPARATOR,
 	 ARGS,
 	 NULL,
 	 0,
 	 },
-#ifndef DMRAID_MINI
-	/* ignoremonitoring option. */
-	{'I',
-	 IGNOREMONITORING,
-	 ACTIVATE | DEACTIVATE,
-	 DBG | FORMAT | HELP | IGNORELOCKING | NOPARTITIONS | VERBOSE |
-	 SEPARATOR,
-	 ARGS,
-	 _lc_inc_opt,
-	 LC_IGNOREMONITORING,
-	 },
-#endif
 };
 
 /*
@@ -675,7 +615,6 @@
 	if (!action)
 		LOG_ERR(lc, 0, "options missing\n");
 
-#ifndef DMRAID_MINI
 	if ((action & (DBG | VERBOSE)) == action)
 		LOG_ERR(lc, 0, "more options needed with -d/-v");
 
@@ -683,7 +622,6 @@
 		action |= DUMP;
 		lc_inc_opt(lc, LC_DUMP);
 	}
-#endif
 
 	return 1;
 }
@@ -813,7 +751,6 @@
  * Perform pre/post functions for requested actions.
  */
 /* Post Activate/Deactivate RAID set. */
-#ifndef DMRAID_MINI
 /* Pre and post display_set() functions. */
 static int
 _display_sets_arg(int arg)
@@ -876,9 +813,6 @@
 	return 1;
 }
 
-#endif
-
-
 /*
  * Function abstraction which takes pre- and post-function calls
  * to prepare an argument in pre() to be used by post().
@@ -909,7 +843,6 @@
 	 activate_or_deactivate_sets,
 	 },
 
-#ifndef DMRAID_MINI
 	/* Display block devices. */
 	{BLOCK_DEVICES,
 	 M_DEVICE,
@@ -982,8 +915,6 @@
 	 _display_sets,
 	 },
 
-#endif
-
 	/* Display version. */
 	{VERSION,
 	 M_NONE,

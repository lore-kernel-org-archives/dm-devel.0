From: heinzm@sourceware.org
Subject: dmraid include/dmraid/lib_context.h lib/metada ...
Date: 19 Mar 2010 13:56:50 -0000
Message-ID: <20100319135650.22115.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-03-19 13:56:49

Modified files:
	include/dmraid : lib_context.h 
	lib/metadata   : metadata.c 
	tools          : commands.c 

Log message:
	A bit more option character sorting and comments

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/dmraid/lib_context.h.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.8&r2=1.9

--- dmraid/include/dmraid/lib_context.h	2010/03/19 12:07:47	1.6
+++ dmraid/include/dmraid/lib_context.h	2010/03/19 13:56:49	1.7
@@ -54,21 +54,21 @@
 /* Options access macros. */
 /* Return option counter. */
 #define	OPT_COLUMN(lc)		(lc_opt(lc, LC_COLUMN))
+#define	OPT_CREATE(lc)		(lc_opt(lc, LC_CREATE))
 #define	OPT_DEBUG(lc)		(lc_opt(lc, LC_DEBUG))
 #define	OPT_DEVICES(lc)		(lc_opt(lc, LC_DEVICES))
 #define	OPT_DUMP(lc)		(lc_opt(lc, LC_DUMP))
-#define	OPT_GROUP(lc)		(lc_opt(lc, LC_GROUP))
 #define	OPT_FORMAT(lc)		(lc_opt(lc, LC_FORMAT))
+#define	OPT_GROUP(lc)		(lc_opt(lc, LC_GROUP))
+#define OPT_HOT_SPARE_SET(lc)	(lc_opt(lc, LC_HOT_SPARE_SET))
 #define	OPT_IGNORELOCKING(lc)	(lc_opt(lc, LC_IGNORELOCKING))
+#define OPT_IGNOREMONITORING(lc) (lc_opt(lc, LC_IGNOREMONITORING))
+#define	OPT_PARTCHAR(lc)	(lc_opt(lc, LC_PARTCHAR))
+#define OPT_REBUILD_DISK(lc)	(lc_opt(lc, LC_REBUILD_DISK))
 #define	OPT_SEPARATOR(lc)	(lc_opt(lc, LC_SEPARATOR))
 #define	OPT_SETS(lc)		(lc_opt(lc, LC_SETS))
 #define	OPT_TEST(lc)		(lc_opt(lc, LC_TEST))
 #define	OPT_VERBOSE(lc)		(lc_opt(lc, LC_VERBOSE))
-#define	OPT_PARTCHAR(lc)	(lc_opt(lc, LC_PARTCHAR))
-#define	OPT_CREATE(lc)		(lc_opt(lc, LC_CREATE))
-#define OPT_REBUILD_DISK(lc)	(lc_opt(lc, LC_REBUILD_DISK))
-#define OPT_HOT_SPARE_SET(lc)	(lc_opt(lc, LC_HOT_SPARE_SET))
-#define OPT_IGNOREMONITORING(lc) (lc_opt(lc, LC_IGNOREMONITORING))
 
 /* Return option value. */
 #define	OPT_STR(lc, o)		(lc->options[o].arg.str)
--- dmraid/lib/metadata/metadata.c	2010/03/19 12:07:48	1.11
+++ dmraid/lib/metadata/metadata.c	2010/03/19 13:56:49	1.12
@@ -1901,23 +1901,21 @@
 
 				n++;
 			}
+
 			if (n > 1) {
 				printf("\nAbout to delete the raid super-set "
 				       "\"%s\" with the following RAID sets\n",
 				       rs->name);
 				list_for_each_entry(rs1, &rs->sets, list)
 					printf("%s\n", rs1->name);
-			}
-			else if (n == 1) {
+			} else if (n == 1) {
 				rs1 = list_entry(rs->sets.next,
 						 struct raid_set, list);
 				printf("\nAbout to delete RAID set %s\n",
 				       rs1->name);
-			}
-			else
+			} else
 				LOG_ERR(lc, 0, "coding error");
-		}
-		else
+		} else
 			printf("\nAbout to delete RAID set %s\n", rs->name);
 
 		printf("\nWARNING: The metadata stored on the raidset(s) "
@@ -1932,7 +1930,6 @@
 				rd->fmt->name);
 
 		rd->fmt->delete(lc, rs);
-
 	}
 
 	return 1;
--- dmraid/tools/commands.c	2010/03/19 12:07:48	1.8
+++ dmraid/tools/commands.c	2010/03/19 13:56:49	1.9
@@ -30,12 +30,11 @@
 /*
  * Command line options.
  */
-static char const *short_opts = "a:hipP:"
-	"bc::dDEf:gIlxM:"
+static char const *short_opts = "a:bc::C:dDEf:ghiIlM:"
 #ifdef	DMRAID_NATIVE_LOG
 	"n"
 #endif
-	"rR:s::tvVC:S::Z";
+	"pP:rR:s::S::tvVxZ";
 
 #ifdef HAVE_GETOPTLONG
 static struct option long_opts[] = {
@@ -46,8 +45,8 @@
 	{"display_columns", optional_argument, NULL, 'c'},
 	{"display_group", no_argument, NULL, 'g'},
 	{"dump_metadata", no_argument, NULL, 'D'},
-	{"format", required_argument, NULL, 'f'},
 	{"erase_metadata", no_argument, NULL, 'E'},
+	{"format", required_argument, NULL, 'f'},
 	{"help", no_argument, NULL, 'h'},
 	{"ignorelocking", no_argument, NULL, 'i'},
 	{"ignoremonitoring", no_argument, NULL, 'I'},
@@ -618,6 +617,7 @@
 	if ((action & (DBG | VERBOSE)) == action)
 		LOG_ERR(lc, 0, "more options needed with -d/-v");
 
+	/* Enforce metadata dump on (mistaken) erase. */
 	if (action & DMERASE) {
 		action |= DUMP;
 		lc_inc_opt(lc, LC_DUMP);
@@ -636,6 +636,7 @@
 	LOG_ERR(lc, 0, "invalid format for -f at (see -l)");
 }
 
+/* Save name of rebuild disk. */
 int
 save_drive_name(struct lib_context *lc, char *drive)
 {
@@ -643,6 +644,7 @@
 	return lc_strcat_opt(lc, LC_REBUILD_DISK, drive, ',') ? 1 : 0;
 }
 
+/* Save name of hot spare disk. */
 static int
 save_spare_name(struct lib_context *lc, char **argv)
 {

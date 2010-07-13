From: zkabelac@sourceware.org
Subject: dmraid/lib/metadata metadata.c
Date: 13 Jul 2010 20:13:13 -0000
Message-ID: <20100713201313.21680.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:13:13

Modified files:
	lib/metadata   : metadata.c 

Log message:
	Use static for localy some used functions.
	Use const char *dp  for find_disk()

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.12&r2=1.13

--- dmraid/lib/metadata/metadata.c	2010/03/19 13:56:49	1.12
+++ dmraid/lib/metadata/metadata.c	2010/07/13 20:13:13	1.13
@@ -761,7 +761,7 @@
 }
 
 /* Discover RAID devices that are spares */
-void
+static void
 discover_raid_devices_spares(struct lib_context *lc, const char *format)
 {
 	struct dev_info *di;
@@ -1146,7 +1146,7 @@
 }
 
 /* Parse RAID set creation arguments. */
-int
+static int
 parse_rs_args(struct lib_context *lc, char **argv, struct raid_set_descr *rsd)
 {
 	int o, n, opt_idx;
@@ -1215,7 +1215,7 @@
 }
 
 struct dev_info *
-find_disk(struct lib_context *lc, char *dp)
+find_disk(struct lib_context *lc, const char *dp)
 {
 	struct dev_info *di;
 
@@ -1337,7 +1337,7 @@
 		_free_raid_set(lc, rs);
 }
 
-struct raid_dev *
+static struct raid_dev *
 find_raiddev(struct lib_context *lc, struct raid_set *rs, struct dev_info *di)
 {
 	struct raid_dev *rd;
@@ -1353,7 +1353,7 @@
 	return NULL;
 }
 
-struct raid_set *
+static struct raid_set *
 create_raidset(struct lib_context *lc, struct raid_set_descr *rsd)
 {
 	struct raid_set *rs, *rs_sub, *rs_tmp;
@@ -1459,7 +1459,7 @@
 	return NULL;
 }
 
-int
+static int
 rebuild_config_raidset(struct lib_context *lc, struct raid_set *rs)
 {
 
@@ -2056,7 +2056,7 @@
 }
 
 
-void
+static void
 format_error(struct lib_context *lc, const char *error, char **argv)
 {
 	log_print_nnl(lc, "no raid %s", error);

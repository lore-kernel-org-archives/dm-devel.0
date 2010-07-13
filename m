From: zkabelac@sourceware.org
Subject: dmraid/lib/metadata reconfig.c
Date: 13 Jul 2010 20:19:40 -0000
Message-ID: <20100713201940.23942.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:19:40

Modified files:
	lib/metadata   : reconfig.c 

Log message:
	Add static to local functions

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/reconfig.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/lib/metadata/reconfig.c	2009/09/16 11:45:16	1.3
+++ dmraid/lib/metadata/reconfig.c	2010/07/13 20:19:40	1.4
@@ -87,7 +87,7 @@
 
 int rebuild_config_raidset(struct lib_context *lc, struct raid_set *rs);
 
-void
+static void
 show_raid_stack(struct lib_context *lc)
 {
 	struct raid_set *_rs;
@@ -268,10 +268,8 @@
 	return ret;
 }
 
-struct dev_info *find_disk(struct lib_context *lc, char *dp);
-
 /* check if disk is under a raid set */
-int
+static int
 check_busy_disk(struct lib_context *lc, struct raid_dev *check_rd)
 {
 	struct raid_dev *rd;
@@ -290,7 +288,7 @@
 	return 1;
 }
 
-int
+static int
 add_dev_to_array(struct lib_context *lc, struct raid_set *rs,
 		 uint build_metadata, struct raid_dev *hot_spare_rd)
 {
@@ -543,7 +541,7 @@
 struct raid_dev *find_spare(struct lib_context *lc, struct raid_set *sub_rs,
 			    struct raid_set **spare_set);
 
-int
+static int
 _rebuild_raidset(struct lib_context *lc, struct raid_set *sub_rs,
 		 char *set_name)
 {
@@ -704,7 +702,7 @@
 }
 
 
-int
+static int
 write_set_spare(struct lib_context *lc, void *v)
 {
 	int ret = 1;

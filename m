From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: Fix dry-run output
Date: Mon, 28 Sep 2009 12:19:00 -0500
Message-ID: <20090928171900.GC20896@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

When multipath checks whether or not the multipath device needs to be renamed,
it only does the check if dry-run isn't selected.  This means that you will
instead see all your renames as creates during a dry-run.  The attached patch
fixes this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-090902/libmultipath/configure.c
===================================================================
--- multipath-tools-090902.orig/libmultipath/configure.c
+++ multipath-tools-090902/libmultipath/configure.c
@@ -151,7 +151,7 @@ select_action (struct multipath * mpp, v
 	if (!cmpp) {
 		cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 
-		if (cmpp && !conf->dry_run) {
+		if (cmpp) {
 			condlog(2, "%s: rename %s to %s", mpp->wwid,
 				cmpp->alias, mpp->alias);
 			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE);

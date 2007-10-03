From: Dave Wysochanski <dwysocha@redhat.com>
Subject: [PATCH] [libmultipath] Update HP hardware handler name
	from "dm_hp" to "dm-hp"
Date: Wed,  3 Oct 2007 17:18:02 -0400
Message-ID: <11914462821708-git-send-email-dwysocha@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

HP storageworks handler has been submitted upstream.  During the review, 
the name of the handler was changed from "dm_hp" to "dm-hp" for consistency
with kernel code.  This patch  updates the hwtable for these HP arrays.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
---
 libmultipath/hwtable.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ef761d7..940dc0e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -65,7 +65,7 @@ static struct hwentry default_hw[] = {
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = "1 hp_sw",
+		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
@@ -96,7 +96,7 @@ static struct hwentry default_hw[] = {
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = "1 hp_sw",
+		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
-- 
1.5.2.2

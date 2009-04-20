From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 17/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 04:03:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200403290.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200401280.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200402010.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200402400.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200403070.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200403070.6097@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-snapshot-sync-exception-store.patch

Send barrier requests when updating the exception area.

Exception area updates need to be ordered w.r.t. data writes, so that
the writes are not reordered in hardware disk cache.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-snap-persistent.c	2009-04-10 06:16:42.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-snap-persistent.c	2009-04-20 08:41:18.000000000 +0200
@@ -636,7 +636,7 @@ static void persistent_commit_exception(
 	/*
 	 * Commit exceptions to disk.
 	 */
-	if (ps->valid && area_io(ps, WRITE))
+	if (ps->valid && area_io(ps, WRITE_BARRIER))
 		ps->valid = 0;
 
 	/*

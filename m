From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 03:54:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200351040.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200348180.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200349181.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200349560.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200350370.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200350370.6097@hs20-bc2-1.build.redhat.com>
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

dm-dont-report-eopnotsupp.patch

Don't report -EOPNOTSUPP.

If the underlying device doesn't support barriers and dm receives a barrier,
it waits until all requests on that device drain --- so it doesn't have to
report EOPNOTSUPP to the caller.

This patch fixes the confusing situation when moving volume from one physical
device to another triggers an EOPNOTSUPP on a volume that didn't report it
before.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm.c	2009-04-20 08:46:05.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm.c	2009-04-20 08:46:16.000000000 +0200
@@ -565,7 +565,7 @@ static void dec_pending(struct dm_io *io
 			 * a per-device variable for error reporting.
 			 * Note that you can't touch the bio after end_io_acct
 			 */
-			if (!md->barrier_error)
+			if (!md->barrier_error && io_error != -EOPNOTSUPP)
 				md->barrier_error = io_error;
 			end_io_acct(io);
 		} else {

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-thin: Fix deadlock with unknown device id
Date: Thu, 4 Aug 2011 11:35:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108041134590.29961@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-thin: Fix deadlock with unknown device id

If dm-thin device is created with unknown device id, the code calls
dm_put(pool_md) twice. As a consequence, the reference count underflows
and causes deadlock on device removal.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.0-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.0-fast.orig/drivers/md/dm-thin.c	2011-08-04 17:31:16.000000000 +0200
+++ linux-3.0-fast/drivers/md/dm-thin.c	2011-08-04 17:31:26.000000000 +0200
@@ -2031,7 +2031,6 @@ static int thin_ctr(struct dm_target *ti
 		goto bad_pool_lookup;
 	}
 	pool_inc(tc->pool);
-	dm_put(pool_md);
 
 	r = dm_pool_open_thin_device(tc->pool->pmd, tc->dev_id, &tc->td);
 	if (r) {
@@ -2044,6 +2043,8 @@ static int thin_ctr(struct dm_target *ti
 	ti->num_discard_requests = 0;
 	ti->discards_supported = 0;
 
+	dm_put(pool_md);
+
 	return 0;
 
 bad_thin_open:

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-thin: don't send discards to shared blocks
Date: Mon, 16 Jul 2012 18:39:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207161837500.10793@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch prevents dm-thin from sending discards to shared blocks. It is 
an upstream bug, so it should be sent upstream now (preferably before 3.5 
comes out).

Mikulas

---

dm-thin: don't send discards to shared blocks

When process_discard receives a partial discard that doesn't cover full
block, it sends this discard down to that block. Unfortunatelly, the
block can be shared and the discard would corrupt the other snapshots
sharing this block.

This patch detects block sharing and ends the discard with sucess when
sending it to the shared block.

The above change causes that if the device supports discard it can't be
guaranteed that a discard request zeroes data. Therefore, we set
ti->discard_zeroes_data_unsupported.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-thin.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-3.5-rc6-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.5-rc6-fast.orig/drivers/md/dm-thin.c	2012-07-16 21:47:46.000000000 +0200
+++ linux-3.5-rc6-fast/drivers/md/dm-thin.c	2012-07-17 00:35:25.000000000 +0200
@@ -1259,7 +1259,10 @@ static void process_discard(struct thin_
 
 			cell_release_singleton(cell, bio);
 			cell_release_singleton(cell2, bio);
-			remap_and_issue(tc, bio, lookup_result.block);
+			if ((!lookup_result.shared) & pool->pf.discard_passdown)
+				remap_and_issue(tc, bio, lookup_result.block);
+			else
+				bio_endio(bio, 0);
 		}
 		break;
 
@@ -2648,6 +2651,7 @@ static int thin_ctr(struct dm_target *ti
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = 1;
 		ti->num_discard_requests = 1;
+		ti->discard_zeroes_data_unsupported = 1;
 	}
 
 	dm_put(pool_md);

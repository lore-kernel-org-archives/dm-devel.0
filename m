From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-raid: stack limits instead of overwriting
	them.
Date: Thu, 24 Sep 2020 12:26:18 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch fixes a warning WARN_ON_ONCE(!q->limits.discard_granularity).
The reason is that the function raid_io_hints overwrote
limits->discard_granularity with zero. We need to properly stack the
limits instead of overwriting them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-raid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c	2020-09-24 18:16:45.000000000 +0200
+++ linux-2.6/drivers/md/dm-raid.c	2020-09-24 18:16:45.000000000 +0200
@@ -3734,8 +3734,8 @@ static void raid_io_hints(struct dm_targ
 	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
 	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
-		limits->discard_granularity = chunk_size_bytes;
-		limits->max_discard_sectors = rs->md.chunk_sectors;
+		limits->discard_granularity = max(limits->discard_granularity, chunk_size_bytes);
+		limits->max_discard_sectors = min_not_zero(limits->max_discard_sectors, (unsigned)rs->md.chunk_sectors);
 	}
 }
 

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/7] dm writecache: do direct write if the cache
	is full
Date: Mon, 24 Feb 2020 10:20:31 +0100
Message-ID: <20200224092050.670786680@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-writecache-direct-write.patch
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Alasdair Kergon <agk@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

If the cache device is full, we do a direct write to the origin device.
Note that we must not do it if the written block is already in the cache.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-02-23 18:15:56.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-02-23 18:15:56.000000000 +0100
@@ -1194,6 +1194,7 @@ read_next_block:
 		}
 	} else {
 		do {
+			bool found_entry = false;
 			if (writecache_has_error(wc))
 				goto unlock_error;
 			e = writecache_find_entry(wc, bio->bi_iter.bi_sector, 0);
@@ -1204,9 +1205,21 @@ read_next_block:
 					wc->overwrote_committed = true;
 					goto bio_copy;
 				}
+				found_entry = true;
 			}
 			e = writecache_pop_from_freelist(wc, (sector_t)-1);
 			if (unlikely(!e)) {
+				if (!found_entry) {
+					e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
+					if (e) {
+						sector_t next_boundary = read_original_sector(wc, e) - bio->bi_iter.bi_sector;
+						BUG_ON(!next_boundary);
+						if (next_boundary < bio->bi_iter.bi_size >> SECTOR_SHIFT) {
+							dm_accept_partial_bio(bio, next_boundary);
+						}
+					}
+					goto unlock_remap_origin;
+				}
 				writecache_wait_on_freelist(wc);
 				continue;
 			}

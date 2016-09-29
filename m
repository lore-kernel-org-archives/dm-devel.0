From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/10] dm snapshot: Delete five unwanted spaces behind
 "list_for_each_entry"
Date: Thu, 29 Sep 2016 11:18:34 +0200
Message-ID: <c38479bc-8a5d-587a-a244-058c44ced386@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 29 Sep 2016 10:14:32 +0200

The script "checkpatch.pl" can point information out like the following.

WARNING: space prohibited between function name and open parenthesis '('

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-snap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7593986..1310652 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -366,7 +366,7 @@ static struct origin *__lookup_origin(struct block_device *origin)
 	struct origin *o;
 
 	ol = &_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->bdev, origin))
 			return o;
 
@@ -385,7 +385,7 @@ static struct dm_origin *__lookup_dm_origin(struct block_device *origin)
 	struct dm_origin *o;
 
 	ol = &_dm_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->dev->bdev, origin))
 			return o;
 
@@ -625,7 +625,7 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		list_for_each_entry_safe (ex, next, slot, hash_list)
+		list_for_each_entry_safe(ex, next, slot, hash_list)
 			kmem_cache_free(mem, ex);
 	}
 
@@ -653,7 +653,7 @@ static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
 	struct dm_exception *e;
 
 	slot = &et->table[exception_hash(et, chunk)];
-	list_for_each_entry (e, slot, hash_list)
+	list_for_each_entry(e, slot, hash_list)
 		if (chunk >= e->old_chunk &&
 		    chunk <= e->old_chunk + dm_consecutive_chunk_count(e))
 			return e;
@@ -2068,7 +2068,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 	chunk_t chunk;
 
 	/* Do all the snapshots on this origin */
-	list_for_each_entry (snap, snapshots, list) {
+	list_for_each_entry(snap, snapshots, list) {
 		/*
 		 * Don't make new exceptions in a merging snapshot
 		 * because it has effectively been deleted
-- 
2.10.0


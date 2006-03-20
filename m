From: Alasdair G Kergon <agk@redhat.com>
Subject: dm: bio split bvec fix
Date: Mon, 20 Mar 2006 19:21:55 +0000
Message-ID: <20060320192155.GU4724@agk.surrey.redhat.com>
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
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The code that handles bios that span table target boundaries by breaking
them up into smaller bios will not split an individual struct bio_vec
into more than two pieces.  Sometimes more than that are required.

This patch adds a loop to break the second piece up into as many
pieces as are necessary.

Cc: "Abhishek Gupta" <abhishekgupt@gmail.com>
Cc: Dan Smith <danms@us.ibm.com>
Signed-Off-By: Alasdair G Kergon <agk@redhat.com>

Index: linux-2.6.16-rc5/drivers/md/dm.c
===================================================================
--- linux-2.6.16-rc5.orig/drivers/md/dm.c	2006-03-20 16:00:11.000000000 +0000
+++ linux-2.6.16-rc5/drivers/md/dm.c	2006-03-20 18:38:19.000000000 +0000
@@ -573,30 +573,35 @@ static void __clone_and_map(struct clone
 
 	} else {
 		/*
-		 * Create two copy bios to deal with io that has
-		 * been split across a target.
+		 * Handle a bvec that must be split between two or more targets.
 		 */
 		struct bio_vec *bv = bio->bi_io_vec + ci->idx;
+		sector_t remaining = to_sector(bv->bv_len);
+		unsigned int offset = 0;
 
-		clone = split_bvec(bio, ci->sector, ci->idx,
-				   bv->bv_offset, max);
-		__map_bio(ti, clone, tio);
-
-		ci->sector += max;
-		ci->sector_count -= max;
-		ti = dm_table_find_target(ci->map, ci->sector);
-
-		len = to_sector(bv->bv_len) - max;
-		clone = split_bvec(bio, ci->sector, ci->idx,
-				   bv->bv_offset + to_bytes(max), len);
-		tio = alloc_tio(ci->md);
-		tio->io = ci->io;
-		tio->ti = ti;
-		memset(&tio->info, 0, sizeof(tio->info));
-		__map_bio(ti, clone, tio);
+		do {
+			if (offset) {
+				ti = dm_table_find_target(ci->map, ci->sector);
+				max = max_io_len(ci->md, ci->sector, ti);
+
+				tio = alloc_tio(ci->md);
+				tio->io = ci->io;
+				tio->ti = ti;
+				memset(&tio->info, 0, sizeof(tio->info));
+			}
+
+			len = (max > remaining) ? remaining : max;
+
+			clone = split_bvec(bio, ci->sector, ci->idx,
+					   bv->bv_offset + offset, len);
+
+			__map_bio(ti, clone, tio);
+
+			ci->sector += len;
+			ci->sector_count -= len;
+			offset += to_bytes(len);
+		} while (remaining -= len);
 
-		ci->sector += len;
-		ci->sector_count -= len;
 		ci->idx++;
 	}
 }

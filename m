From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] dm space map metadata: constify dm_space_map structures
Date: Wed, 15 Feb 2017 23:43:28 +0530
Message-ID: <1487182408-19220-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: dm-devel.ids

Declare dm_space_map structures as const as they are only passed as an
argument to the function memcpy. This argument is of type const void *,
so dm_space_map structures having this property can be declared as
const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   4889	    240	      0	   5129	   1409 dm-space-map-metadata.o

File size after:
   text	   data	    bss	    dec	    hex	filename
   5139	      0	      0	   5139	   1413 dm-space-map-metadata.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/md/persistent-data/dm-space-map-metadata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 20557e2..4aed69d 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -544,7 +544,7 @@ static int sm_metadata_copy_root(struct dm_space_map *sm, void *where_le, size_t
 
 static int sm_metadata_extend(struct dm_space_map *sm, dm_block_t extra_blocks);
 
-static struct dm_space_map ops = {
+static const struct dm_space_map ops = {
 	.destroy = sm_metadata_destroy,
 	.extend = sm_metadata_extend,
 	.get_nr_blocks = sm_metadata_get_nr_blocks,
@@ -671,7 +671,7 @@ static int sm_bootstrap_copy_root(struct dm_space_map *sm, void *where,
 	return -EINVAL;
 }
 
-static struct dm_space_map bootstrap_ops = {
+static const struct dm_space_map bootstrap_ops = {
 	.destroy = sm_bootstrap_destroy,
 	.extend = sm_bootstrap_extend,
 	.get_nr_blocks = sm_bootstrap_get_nr_blocks,
-- 
1.9.1

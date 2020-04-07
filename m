From: Sunwook Eom <speed.eom@samsung.com>
Subject: [PATCH] dm verity fec: Don't add data_blocks to block
Date: Tue, 7 Apr 2020 15:53:35 +0900
Message-ID: <317e0073-a6f7-4232-3b95-a4bc3ddbcdec@samsung.com>
References: <CGME20200407065340epcas1p13e6e5ad6131f0a94d3ed1e8360353a82@epcas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, sunwook5492@gmail.com
List-Id: dm-devel.ids

Even if block type is metadata,
block in verity_fec_decode() has already the right block number.
So there is no need to add data_blocks to block.

Signed-off-by: Sunwook Eom <speed.eom@samsung.com>
---
  drivers/md/dm-verity-fec.c    | 6 +-----
  drivers/md/dm-verity-fec.h    | 4 +---
  drivers/md/dm-verity-target.c | 4 +---
  3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 49147e634046..55f353cae6ec 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -417,8 +417,7 @@ static int fec_bv_copy(struct dm_verity *v, struct 
dm_verity_io *io, u8 *data,
   * otherwise to a bio_vec starting from iter.
   */
  int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
-              enum verity_block_type type, sector_t block, u8 *dest,
-              struct bvec_iter *iter)
+              sector_t block, u8 *dest, struct bvec_iter *iter)
  {
      int r;
      struct dm_verity_fec_io *fio = fec_io(io);
@@ -434,9 +433,6 @@ int verity_fec_decode(struct dm_verity *v, struct 
dm_verity_io *io,

      fio->level++;

-    if (type == DM_VERITY_BLOCK_TYPE_METADATA)
-        block += v->data_blocks;
-
      /*
       * For RS(M, N), the continuous FEC data is divided into blocks of N
       * bytes. Since block size may not be divisible by N, the last block
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 42fbd3a7fc9f..7e2fea0f8cbf 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -68,8 +68,7 @@ struct dm_verity_fec_io {
  extern bool verity_fec_is_enabled(struct dm_verity *v);

  extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
-                 enum verity_block_type type, sector_t block,
-                 u8 *dest, struct bvec_iter *iter);
+                 sector_t block, u8 *dest, struct bvec_iter *iter);

  extern unsigned verity_fec_status_table(struct dm_verity *v, unsigned sz,
                      char *result, unsigned maxlen);
@@ -98,7 +97,6 @@ static inline bool verity_fec_is_enabled(struct 
dm_verity *v)

  static inline int verity_fec_decode(struct dm_verity *v,
                      struct dm_verity_io *io,
-                    enum verity_block_type type,
                      sector_t block, u8 *dest,
                      struct bvec_iter *iter)
  {
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index eec9f252e935..a91b4cb2bf54 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -303,7 +303,6 @@ static int verity_verify_level(struct dm_verity *v, 
struct dm_verity_io *io,
                    v->digest_size) == 0))
              aux->hash_verified = 1;
          else if (verity_fec_decode(v, io,
-                       DM_VERITY_BLOCK_TYPE_METADATA,
                         hash_block, data, NULL) == 0)
              aux->hash_verified = 1;
          else if (verity_handle_err(v,
@@ -521,8 +520,7 @@ static int verity_verify_io(struct dm_verity_io *io)
              if (v->validated_blocks)
                  set_bit(cur_block, v->validated_blocks);
              continue;
-        }
-        else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
+        } else if (verity_fec_decode(v, io,
                         cur_block, NULL, &start) == 0)
              continue;
          else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-- 
2.17.1

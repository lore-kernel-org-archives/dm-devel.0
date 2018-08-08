From: xiao jin <jin.xiao@intel.com>
Subject: [PATCH] dm-bufio: adjust the reserved buffer for dm-verify-target.
Date: Wed,  8 Aug 2018 13:07:03 +0800
Message-ID: <1533704823-5448-1-git-send-email-jin.xiao@intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, yanmin.zhang@intel.com, jin.xiao@intel.com
List-Id: dm-devel.ids

We hit the BUG() report at include/linux/scatterlist.h:144!
The callback is as bellow:
  => verity_work
  => verity_hash_for_block
  => verity_verify_level
  => verity_hash
  => verity_hash_update
  => sg_init_one
  => sg_set_buf

More debug shows the root cause. When creating dufio client it
uses the __vmalloc() to allocate the buffer data for the reserved
dm_buffer. The buffer that allocated by the __vmalloc() is invalid
according to the __virt_addr_valid().

Mostly the reserved dm_buffer is not touched. But occasionally
it might fail to allocate the dm_buffer data when we try to
allocate in the __alloc_buffer_wait_no_callback(). Then it has
to take the reserved dm_buffer for usage. Finally it reports the
BUG() as virt_addr_valid() detects the buffer data address is invalid.

The patch is to adjust the reserved buffer for dm-verity-target. We
allocated two dm_buffers into the reserved buffers list when creating
the buffer interface. The first dm_buffer in the reserved buffer list
is allocated by the __vmalloc(), it's not used after that. The second
dm_buffer in the reserved buffer list is allocated by the
__get_free_pages() which can be consumed after that.

Signed-off-by: xiao jin <jin.xiao@intel.com>
---
 drivers/md/dm-bufio.c         | 4 ++--
 drivers/md/dm-verity-target.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index dc385b7..3b7ca5e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -841,7 +841,7 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 			tried_noio_alloc = true;
 		}
 
-		if (!list_empty(&c->reserved_buffers)) {
+		if (!c->need_reserved_buffers) {
 			b = list_entry(c->reserved_buffers.next,
 				       struct dm_buffer, lru_list);
 			list_del(&b->lru_list);
@@ -1701,7 +1701,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		goto bad;
 	}
 
-	while (c->need_reserved_buffers) {
+	if (list_empty(&c->reserved_buffers)) {
 		struct dm_buffer *b = alloc_buffer(c, GFP_KERNEL);
 
 		if (!b) {
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 12decdbd7..40c66fc 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1107,7 +1107,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	v->hash_blocks = hash_position;
 
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
-		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
+		1 << v->hash_dev_block_bits, 2, sizeof(struct buffer_aux),
 		dm_bufio_alloc_callback, NULL);
 	if (IS_ERR(v->bufio)) {
 		ti->error = "Cannot initialize dm-bufio";
-- 
2.7.4

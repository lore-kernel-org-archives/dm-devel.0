From: Maged Mokhtar <mmokhtar@petasan.org>
Subject: [PATCH] dm writecache: SB remove seq_count
Date: Fri, 6 Dec 2019 21:03:25 +0200
Message-ID: <598c7c64-9b11-3407-2060-8d43b1ef1241@petasan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Removes seq_count from super block. Currently the super block gets 
written in each commit to update the seq_count which is just used when 
the target is restarted/resumed. This extra iop has a performance impact 
on small block size writes which do FUA/sync on every request. A 4k sync 
write currently requires 3 write ops: submitted data, metadata + super 
block seq_count update, removal of seq_count update reduces required 
write ops to 2.

Rebuild of seq_count at start/resumption can be done quickly by looping 
through memory entry metadata within the resume() function.

Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
---
  drivers/md/dm-writecache.c |   56 ++++++++++++++++++++++++++---------
  1 file changed, 42 insertions(+), 14 deletions(-)

--- a/drivers/md/dm-writecache.c	2019-12-06 03:07:53.000000000 -0800
+++ b/drivers/md/dm-writecache.c	2019-12-06 09:25:45.000000000 -0800
@@ -52,7 +52,8 @@ do {								\
  #endif

  #define MEMORY_SUPERBLOCK_MAGIC		0x23489321
-#define MEMORY_SUPERBLOCK_VERSION	1
+#define MEMORY_SUPERBLOCK_VERSION_1	1
+#define MEMORY_SUPERBLOCK_VERSION_2	2

  struct wc_memory_entry {
  	__le64 original_sector;
@@ -67,7 +68,6 @@ struct wc_memory_superblock {
  			__le32 block_size;
  			__le32 pad;
  			__le64 n_blocks;
-			__le64 seq_count;
  		};
  		__le64 padding[8];
  	};
@@ -380,6 +380,41 @@ static uint64_t read_seq_count(struct dm
  #endif
  }

+static uint64_t read_last_seq_count(struct dm_writecache *wc)
+{
+	size_t b;
+	uint64_t last_seq_count = 0;
+	uint64_t seq_count;
+	__le64 empty = cpu_to_le64(-1);
+
+	if (WC_MODE_PMEM(wc)) {
+		struct wc_memory_entry wme;
+		for (b = 0; b < wc->n_blocks; b++) {
+			BUG_ON(memcpy_mcsafe(&wme, &sb(wc)->entries[b],
+				sizeof(struct wc_memory_entry)));
+			if (wme.seq_count != empty) {
+				seq_count = le64_to_cpu(wme.seq_count);
+				if (last_seq_count < seq_count)
+					last_seq_count = seq_count;
+			}
+		}
+	}
+	else {
+		struct wc_memory_entry *p = &sb(wc)->entries[0];
+		b = wc->n_blocks;
+		while (0 < b) {
+			if (p->seq_count != empty) {	
+				seq_count = le64_to_cpu(p->seq_count);
+				if (last_seq_count < seq_count)
+					last_seq_count = seq_count;
+			}
+			p++;		
+			b--;
+		}
+	}
+	return last_seq_count;
+}
+
  static void clear_seq_count(struct dm_writecache *wc, struct wc_entry *e)
  {
  #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
@@ -730,8 +765,6 @@ static void writecache_flush(struct dm_w
  		writecache_wait_for_ios(wc, WRITE);

  	wc->seq_count++;
-	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
-	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
  	writecache_commit_flushed(wc);

  	wc->overwrote_committed = false;
@@ -876,7 +909,6 @@ static void writecache_resume(struct dm_
  	struct dm_writecache *wc = ti->private;
  	size_t b;
  	bool need_flush = false;
-	__le64 sb_seq_count;
  	int r;

  	wc_lock(wc);
@@ -894,12 +926,7 @@ static void writecache_resume(struct dm_
  	}
  	wc->freelist_size = 0;

-	r = memcpy_mcsafe(&sb_seq_count, &sb(wc)->seq_count, sizeof(uint64_t));
-	if (r) {
-		writecache_error(wc, r, "hardware memory error when reading 
superblock: %d", r);
-		sb_seq_count = cpu_to_le64(0);
-	}
-	wc->seq_count = le64_to_cpu(sb_seq_count);
+	wc->seq_count = read_last_seq_count(wc) + 1;

  #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
  	for (b = 0; b < wc->n_blocks; b++) {
@@ -1757,10 +1784,9 @@ static int init_memory(struct dm_writeca

  	for (b = 0; b < ARRAY_SIZE(sb(wc)->padding); b++)
  		pmem_assign(sb(wc)->padding[b], cpu_to_le64(0));
-	pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_VERSION));
+	pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_VERSION_2));
  	pmem_assign(sb(wc)->block_size, cpu_to_le32(wc->block_size));
  	pmem_assign(sb(wc)->n_blocks, cpu_to_le64(wc->n_blocks));
-	pmem_assign(sb(wc)->seq_count, cpu_to_le64(0));

  	for (b = 0; b < wc->n_blocks; b++)
  		write_original_sector_seq_count(wc, &wc->entries[b], -1, -1);
@@ -2159,11 +2185,13 @@ invalid_optional:
  		goto bad;
  	}

-	if (le32_to_cpu(s.version) != MEMORY_SUPERBLOCK_VERSION) {
+	if (le32_to_cpu(s.version) != MEMORY_SUPERBLOCK_VERSION_1 &&
+		le32_to_cpu(s.version) != MEMORY_SUPERBLOCK_VERSION_2) {
  		ti->error = "Invalid version in the superblock";
  		r = -EINVAL;
  		goto bad;
  	}
+	pmem_assign(sb(wc)->version, cpu_to_le32(MEMORY_SUPERBLOCK_VERSION_2));

  	if (le32_to_cpu(s.block_size) != wc->block_size) {
  		ti->error = "Block size does not match superblock";

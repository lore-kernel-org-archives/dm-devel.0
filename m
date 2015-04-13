From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/7] fs: use block_device name vsprintf helper
Date: Mon, 13 Apr 2015 16:31:37 +0400
Message-ID: <1428928300-9132-5-git-send-email-dmonakhov@openvz.org>
References: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/btrfs/super.c      |    4 +---
 fs/buffer.c           |   21 ++++++---------------
 fs/ext2/xattr.c       |    6 ++----
 fs/ext3/super.c       |    5 ++---
 fs/ext3/xattr.c       |    5 ++---
 fs/ext4/page-io.c     |    5 ++---
 fs/ext4/xattr.c       |    6 ++----
 fs/f2fs/debug.c       |    6 ++----
 fs/gfs2/ops_fstype.c  |    4 +---
 fs/jbd/commit.c       |    4 +---
 fs/jbd/journal.c      |   34 ++++++++++++----------------------
 fs/jbd/transaction.c  |    6 ++----
 fs/jbd2/transaction.c |    6 ++----
 fs/minix/itree_v1.c   |    9 ++++-----
 fs/minix/itree_v2.c   |    9 ++++-----
 fs/nilfs2/super.c     |    6 ++----
 fs/reiserfs/journal.c |   24 ++++++++++--------------
 fs/reiserfs/prints.c  |    9 +++------
 fs/reiserfs/procfs.c  |    5 ++---
 fs/squashfs/super.c   |    7 +++----
 fs/super.c            |    4 +---
 fs/xfs/xfs_buf.c      |    8 ++------
 22 files changed, 68 insertions(+), 125 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 68ee619..0405a2f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1376,9 +1376,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		if ((flags ^ s->s_flags) & MS_RDONLY)
 			error = -EBUSY;
 	} else {
-		char b[BDEVNAME_SIZE];
-
-		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
+		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		btrfs_sb(s)->bdev_holder = fs_type;
 		error = btrfs_fill_super(s, fs_devices, data,
 					 flags & MS_SILENT ? 1 : 0);
diff --git a/fs/buffer.c b/fs/buffer.c
index 20805db..6697cc8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -130,13 +130,10 @@ __clear_page_buffers(struct page *page)
 
 static void buffer_io_error(struct buffer_head *bh, char *msg)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (!test_bit(BH_Quiet, &bh->b_state))
 		printk_ratelimited(KERN_ERR
-			"Buffer I/O error on dev %s, logical block %llu%s\n",
-			bdevname(bh->b_bdev, b),
-			(unsigned long long)bh->b_blocknr, msg);
+			"Buffer I/O error on dev %pg, logical block %llu%s\n",
+			bh->b_bdev, (unsigned long long)bh->b_blocknr, msg);
 }
 
 /*
@@ -233,15 +230,13 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	 * elsewhere, don't buffer_error if we had some unmapped buffers
 	 */
 	if (all_mapped) {
-		char b[BDEVNAME_SIZE];
-
 		printk("__find_get_block_slow() failed. "
 			"block=%llu, b_blocknr=%llu\n",
 			(unsigned long long)block,
 			(unsigned long long)bh->b_blocknr);
 		printk("b_state=0x%08lx, b_size=%zu\n",
 			bh->b_state, bh->b_size);
-		printk("device %s blocksize: %d\n", bdevname(bdev, b),
+		printk("device %pg blocksize: %d\n", bdev,
 			1 << bd_inode->i_blkbits);
 	}
 out_unlock:
@@ -527,10 +522,8 @@ repeat:
 
 static void do_thaw_one(struct super_block *sb, void *unused)
 {
-	char b[BDEVNAME_SIZE];
 	while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
-		printk(KERN_WARNING "Emergency Thaw on %s\n",
-		       bdevname(sb->s_bdev, b));
+		printk(KERN_WARNING "Emergency Thaw on %pg\n", sb->s_bdev);
 }
 
 static void do_thaw_all(struct work_struct *work)
@@ -1057,12 +1050,10 @@ grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_t gfp)
 	 * pagecache index.  (this comparison is done using sector_t types).
 	 */
 	if (unlikely(index != block >> sizebits)) {
-		char b[BDEVNAME_SIZE];
-
 		printk(KERN_ERR "%s: requested out-of-range block %llu for "
-			"device %s\n",
+			"device %pg\n",
 			__func__, (unsigned long long)block,
-			bdevname(bdev, b));
+			bdev);
 		return -EIO;
 	}
 
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 0b6bfd3..192679e 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -77,10 +77,8 @@
 		printk("\n"); \
 	} while (0)
 # define ea_bdebug(bh, f...) do { \
-		char b[BDEVNAME_SIZE]; \
-		printk(KERN_DEBUG "block %s:%lu: ", \
-			bdevname(bh->b_bdev, b), \
-			(unsigned long) bh->b_blocknr); \
+		printk(KERN_DEBUG "block %pg:%lu: ", \
+			bh->b_bdev, (unsigned long) bh->b_blocknr); \
 		printk(f); \
 		printk("\n"); \
 	} while (0)
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 30abbab..bd184e8 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1429,9 +1429,8 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
 			sbi->s_mount_opt);
 
 	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
-		char b[BDEVNAME_SIZE];
-		ext3_msg(sb, KERN_INFO, "using external journal on %s",
-			bdevname(EXT3_SB(sb)->s_journal->j_dev, b));
+		ext3_msg(sb, KERN_INFO, "using external journal on %pg",
+			 EXT3_SB(sb)->s_journal->j_dev);
 	} else {
 		ext3_msg(sb, KERN_INFO, "using internal journal");
 	}
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index a5591d7..9e9ea20 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -76,9 +76,8 @@
 		printk("\n"); \
 	} while (0)
 # define ea_bdebug(bh, f...) do { \
-		char b[BDEVNAME_SIZE]; \
-		printk(KERN_DEBUG "block %s:%lu: ", \
-			bdevname(bh->b_bdev, b), \
+		printk(KERN_DEBUG "block %pg:%lu: ", \
+			bh->b_bdev,
 			(unsigned long) bh->b_blocknr); \
 		printk(f); \
 		printk("\n"); \
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4649842..c1ead0a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -54,9 +54,8 @@ void ext4_exit_pageio(void)
  */
 static void buffer_io_error(struct buffer_head *bh)
 {
-	char b[BDEVNAME_SIZE];
-	printk_ratelimited(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
-			bdevname(bh->b_bdev, b),
+	printk_ratelimited(KERN_ERR "Buffer I/O error on device %pg, logical block %llu\n",
+		       bh->b_bdev,
 			(unsigned long long)bh->b_blocknr);
 }
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1993532..821fe3d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -69,10 +69,8 @@
 		printk("\n"); \
 	} while (0)
 # define ea_bdebug(bh, f...) do { \
-		char b[BDEVNAME_SIZE]; \
-		printk(KERN_DEBUG "block %s:%lu: ", \
-			bdevname(bh->b_bdev, b), \
-			(unsigned long) bh->b_blocknr); \
+		printk(KERN_DEBUG "block %pg:%lu: ",		   \
+		       bh->b_bdev, (unsigned long) bh->b_blocknr); \
 		printk(f); \
 		printk("\n"); \
 	} while (0)
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index e671373..57beaa3 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -201,12 +201,10 @@ static int stat_show(struct seq_file *s, void *v)
 
 	mutex_lock(&f2fs_stat_mutex);
 	list_for_each_entry(si, &f2fs_stat_list, stat_list) {
-		char devname[BDEVNAME_SIZE];
-
 		update_general_status(si->sbi);
 
-		seq_printf(s, "\n=====[ partition info(%s). #%d ]=====\n",
-			bdevname(si->sbi->sb->s_bdev, devname), i++);
+		seq_printf(s, "\n=====[ partition info(%pg). #%d ]=====\n",
+			si->sbi->sb->s_bdev, i++);
 		seq_printf(s, "[SB: 1] [CP: 2] [SIT: %d] [NAT: %d] ",
 			   si->sit_area_segs, si->nat_area_segs);
 		seq_printf(s, "[SSA: %d] [MAIN: %d",
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 35b49f4..b597edf 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1311,10 +1311,8 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 		if ((flags ^ s->s_flags) & MS_RDONLY)
 			goto error_super;
 	} else {
-		char b[BDEVNAME_SIZE];
-
 		s->s_mode = mode;
-		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
+		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		sb_set_blocksize(s, block_size(bdev));
 		error = fill_super(s, &args, flags & MS_SILENT ? 1 : 0);
 		if (error)
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index bb217dc..77b6045 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -493,11 +493,9 @@ void journal_commit_transaction(journal_t *journal)
 	spin_unlock(&journal->j_list_lock);
 
 	if (err) {
-		char b[BDEVNAME_SIZE];
-
 		printk(KERN_WARNING
 			"JBD: Detected IO errors while flushing file data "
-			"on %s\n", bdevname(journal->j_fs_dev, b));
+			"on %pg\n", journal->j_fs_dev);
 		if (journal->j_flags & JFS_ABORT_ON_SYNCDATA_ERR)
 			journal_abort(journal, err);
 		err = 0;
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index c46a79a..2279101 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -88,7 +88,7 @@ EXPORT_SYMBOL(journal_force_commit);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
-static const char *journal_dev_name(journal_t *journal, char *buffer);
+static struct block_device *journal_dev(journal_t *journal);
 
 #ifdef CONFIG_JBD_DEBUG
 void __jbd_debug(int level, const char *file, const char *func,
@@ -679,13 +679,10 @@ int journal_bmap(journal_t *journal, unsigned int blocknr,
 		if (ret)
 			*retp = ret;
 		else {
-			char b[BDEVNAME_SIZE];
-
 			printk(KERN_ALERT "%s: journal block not found "
-					"at offset %u on %s\n",
+					"at offset %u on %pg\n",
 				__func__,
-				blocknr,
-				bdevname(journal->j_dev, b));
+				blocknr, journal->j_dev);
 			err = -EIO;
 			__journal_abort_soft(journal, err);
 		}
@@ -1062,7 +1059,6 @@ static void journal_write_superblock(journal_t *journal, int write_op)
 		write_op &= ~(REQ_FUA | REQ_FLUSH);
 	lock_buffer(bh);
 	if (buffer_write_io_error(bh)) {
-		char b[BDEVNAME_SIZE];
 		/*
 		 * Oh, dear.  A previous attempt to write the journal
 		 * superblock failed.  This could happen because the
@@ -1072,8 +1068,8 @@ static void journal_write_superblock(journal_t *journal, int write_op)
 		 * write and hope for the best.
 		 */
 		printk(KERN_ERR "JBD: previous I/O error detected "
-		       "for journal superblock update for %s.\n",
-		       journal_dev_name(journal, b));
+		       "for journal superblock update for %pg.\n",
+		       journal_dev(journal));
 		clear_buffer_write_io_error(bh);
 		set_buffer_uptodate(bh);
 	}
@@ -1088,10 +1084,9 @@ static void journal_write_superblock(journal_t *journal, int write_op)
 		ret = -EIO;
 	}
 	if (ret) {
-		char b[BDEVNAME_SIZE];
 		printk(KERN_ERR "JBD: Error %d detected "
-		       "when updating journal superblock for %s.\n",
-		       ret, journal_dev_name(journal, b));
+		       "when updating journal superblock for %pg.\n",
+		       ret, journal_dev(journal));
 	}
 }
 
@@ -1650,16 +1645,12 @@ int journal_wipe(journal_t *journal, int write)
  * device this journal is present.
  */
 
-static const char *journal_dev_name(journal_t *journal, char *buffer)
+static struct block_device *journal_dev(journal_t *journal)
 {
-	struct block_device *bdev;
-
 	if (journal->j_inode)
-		bdev = journal->j_inode->i_sb->s_bdev;
-	else
-		bdev = journal->j_dev;
+		return journal->j_inode->i_sb->s_bdev;
+	return journal->j_dev;
 
-	return bdevname(bdev, buffer);
 }
 
 /*
@@ -1678,13 +1669,12 @@ static const char *journal_dev_name(journal_t *journal, char *buffer)
 static void __journal_abort_hard(journal_t *journal)
 {
 	transaction_t *transaction;
-	char b[BDEVNAME_SIZE];
 
 	if (journal->j_flags & JFS_ABORT)
 		return;
 
-	printk(KERN_ERR "Aborting journal on device %s.\n",
-		journal_dev_name(journal, b));
+	printk(KERN_ERR "Aborting journal on device %pg.\n",
+	       journal_dev(journal));
 
 	spin_lock(&journal->j_state_lock);
 	journal->j_flags |= JFS_ABORT;
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 1695ba8..1e268df 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -496,13 +496,11 @@ void journal_unlock_updates (journal_t *journal)
 
 static void warn_dirty_buffer(struct buffer_head *bh)
 {
-	char b[BDEVNAME_SIZE];
-
 	printk(KERN_WARNING
-	       "JBD: Spotted dirty metadata buffer (dev = %s, blocknr = %llu). "
+	       "JBD: Spotted dirty metadata buffer (dev = %pg, blocknr = %llu). "
 	       "There's a risk of filesystem corruption in case of system "
 	       "crash.\n",
-	       bdevname(bh->b_bdev, b), (unsigned long long)bh->b_blocknr);
+	       bh->b_bdev, (unsigned long long)bh->b_blocknr);
 }
 
 /*
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5f09370..0052807 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -754,13 +754,11 @@ void jbd2_journal_unlock_updates (journal_t *journal)
 
 static void warn_dirty_buffer(struct buffer_head *bh)
 {
-	char b[BDEVNAME_SIZE];
-
 	printk(KERN_WARNING
-	       "JBD2: Spotted dirty metadata buffer (dev = %s, blocknr = %llu). "
+	       "JBD2: Spotted dirty metadata buffer (dev = %pg, blocknr = %llu). "
 	       "There's a risk of filesystem corruption in case of system "
 	       "crash.\n",
-	       bdevname(bh->b_bdev, b), (unsigned long long)bh->b_blocknr);
+	       bh->b_bdev, (unsigned long long)bh->b_blocknr);
 }
 
 /*
diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 282e15a..46ca39d 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -24,16 +24,15 @@ static inline block_t *i_data(struct inode *inode)
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
-	char b[BDEVNAME_SIZE];
 
 	if (block < 0) {
-		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
-			block, bdevname(inode->i_sb->s_bdev, b));
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
+			block, inode->i_sb->s_bdev);
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
-			       "block %ld too big on dev %s\n",
-				block, bdevname(inode->i_sb->s_bdev, b));
+			       "block %ld too big on dev %pg\n",
+				block, inode->i_sb->s_bdev);
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index 78e2d93..1ee1013 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -26,18 +26,17 @@ static inline block_t *i_data(struct inode *inode)
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
-	char b[BDEVNAME_SIZE];
 	struct super_block *sb = inode->i_sb;
 
 	if (block < 0) {
-		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
-			block, bdevname(sb->s_bdev, b));
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
+			block, sb->s_bdev);
 	} else if ((u64)block * (u64)sb->s_blocksize >=
 			minix_sb(sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
-			       "block %ld too big on dev %s\n",
-				block, bdevname(sb->s_bdev, b));
+			       "block %ld too big on dev %pg\n",
+				block, sb->s_bdev);
 	} else if (block < DIRCOUNT) {
 		offsets[n++] = block;
 	} else if ((block -= DIRCOUNT) < INDIRCOUNT(sb)) {
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 282fb10..b893b73 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1313,13 +1313,11 @@ nilfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	if (!s->s_root) {
-		char b[BDEVNAME_SIZE];
-
-		s_new = true;
+ 		s_new = true;
 
 		/* New superblock instance created */
 		s->s_mode = mode;
-		strlcpy(s->s_id, bdevname(sd.bdev, b), sizeof(s->s_id));
+		snprintf(s->s_id, sizeof(s->s_id), "%pg", sd.bdev);
 		sb_set_blocksize(s, block_size(sd.bdev));
 
 		err = nilfs_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 9d6486d..44c2bdc 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -618,12 +618,10 @@ static void release_buffer_page(struct buffer_head *bh)
 
 static void reiserfs_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (buffer_journaled(bh)) {
 		reiserfs_warning(NULL, "clm-2084",
-				 "pinned buffer %lu:%s sent to disk",
-				 bh->b_blocknr, bdevname(bh->b_bdev, b));
+				 "pinned buffer %lu:%pg sent to disk",
+				 bh->b_blocknr, bh->b_bdev);
 	}
 	if (uptodate)
 		set_buffer_uptodate(bh);
@@ -2387,11 +2385,10 @@ static int journal_read(struct super_block *sb)
 	int replay_count = 0;
 	int continue_replay = 1;
 	int ret;
-	char b[BDEVNAME_SIZE];
 
 	cur_dblock = SB_ONDISK_JOURNAL_1st_BLOCK(sb);
-	reiserfs_info(sb, "checking transaction log (%s)\n",
-		      bdevname(journal->j_dev_bd, b));
+	reiserfs_info(sb, "checking transaction log (%pg)\n",
+		      journal->j_dev_bd);
 	start = get_seconds();
 
 	/*
@@ -2651,8 +2648,8 @@ static int journal_init_dev(struct super_block *super,
 
 	set_blocksize(journal->j_dev_bd, super->s_blocksize);
 	reiserfs_info(super,
-		      "journal_init_dev: journal device: %s\n",
-		      bdevname(journal->j_dev_bd, b));
+		      "journal_init_dev: journal device: %pg\n",
+		      journal->j_dev_bd);
 	return 0;
 }
 
@@ -2724,7 +2721,6 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	struct reiserfs_journal_header *jh;
 	struct reiserfs_journal *journal;
 	struct reiserfs_journal_list *jl;
-	char b[BDEVNAME_SIZE];
 	int ret;
 
 	journal = SB_JOURNAL(sb) = vzalloc(sizeof(struct reiserfs_journal));
@@ -2794,10 +2790,10 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	    && (le32_to_cpu(jh->jh_journal.jp_journal_magic) !=
 		sb_jp_journal_magic(rs))) {
 		reiserfs_warning(sb, "sh-460",
-				 "journal header magic %x (device %s) does "
+				 "journal header magic %x (device %pg) does "
 				 "not match to magic found in super block %x",
 				 jh->jh_journal.jp_journal_magic,
-				 bdevname(journal->j_dev_bd, b),
+				 journal->j_dev_bd,
 				 sb_jp_journal_magic(rs));
 		brelse(bhjh);
 		goto free_and_return;
@@ -2818,10 +2814,10 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 		journal->j_max_trans_age = commit_max_age;
 	}
 
-	reiserfs_info(sb, "journal params: device %s, size %u, "
+	reiserfs_info(sb, "journal params: device %pg, size %u, "
 		      "journal first block %u, max trans len %u, max batch %u, "
 		      "max commit age %u, max trans age %u\n",
-		      bdevname(journal->j_dev_bd, b),
+		      journal->j_dev_bd,
 		      SB_ONDISK_JOURNAL_SIZE(sb),
 		      SB_ONDISK_JOURNAL_1st_BLOCK(sb),
 		      journal->j_trans_max,
diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
index ae1dc84..4f3f928 100644
--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -139,11 +139,9 @@ static void sprintf_block_head(char *buf, struct buffer_head *bh)
 
 static void sprintf_buffer_head(char *buf, struct buffer_head *bh)
 {
-	char b[BDEVNAME_SIZE];
-
 	sprintf(buf,
-		"dev %s, size %zd, blocknr %llu, count %d, state 0x%lx, page %p, (%s, %s, %s)",
-		bdevname(bh->b_bdev, b), bh->b_size,
+		"dev %pg, size %zd, blocknr %llu, count %d, state 0x%lx, page %p, (%s, %s, %s)",
+		bh->b_bdev, bh->b_size,
 		(unsigned long long)bh->b_blocknr, atomic_read(&(bh->b_count)),
 		bh->b_state, bh->b_page,
 		buffer_uptodate(bh) ? "UPTODATE" : "!UPTODATE",
@@ -530,7 +528,6 @@ static int print_super_block(struct buffer_head *bh)
 	    (struct reiserfs_super_block *)(bh->b_data);
 	int skipped, data_blocks;
 	char *version;
-	char b[BDEVNAME_SIZE];
 
 	if (is_reiserfs_3_5(rs)) {
 		version = "3.5";
@@ -543,7 +540,7 @@ static int print_super_block(struct buffer_head *bh)
 		return 1;
 	}
 
-	printk("%s\'s super block is in block %llu\n", bdevname(bh->b_bdev, b),
+	printk("%pg\'s super block is in block %llu\n", bh->b_bdev,
 	       (unsigned long long)bh->b_blocknr);
 	printk("Reiserfs version %s\n", version);
 	printk("Block count %u\n", sb_block_count(rs));
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 621b9f3..fe99915 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -303,11 +303,10 @@ static int show_journal(struct seq_file *m, void *unused)
 	struct reiserfs_sb_info *r = REISERFS_SB(sb);
 	struct reiserfs_super_block *rs = r->s_rs;
 	struct journal_params *jp = &rs->s_v1.s_journal;
-	char b[BDEVNAME_SIZE];
 
 	seq_printf(m,		/* on-disk fields */
 		   "jp_journal_1st_block: \t%i\n"
-		   "jp_journal_dev: \t%s[%x]\n"
+		   "jp_journal_dev: \t%pg[%x]\n"
 		   "jp_journal_size: \t%i\n"
 		   "jp_journal_trans_max: \t%i\n"
 		   "jp_journal_magic: \t%i\n"
@@ -348,7 +347,7 @@ static int show_journal(struct seq_file *m, void *unused)
 		   "prepare: \t%12lu\n"
 		   "prepare_retry: \t%12lu\n",
 		   DJP(jp_journal_1st_block),
-		   bdevname(SB_JOURNAL(sb)->j_dev_bd, b),
+		   SB_JOURNAL(sb)->j_dev_bd,
 		   DJP(jp_journal_dev),
 		   DJP(jp_journal_size),
 		   DJP(jp_journal_trans_max),
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 5056bab..dded920 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -80,7 +80,6 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct squashfs_sb_info *msblk;
 	struct squashfs_super_block *sblk = NULL;
-	char b[BDEVNAME_SIZE];
 	struct inode *root;
 	long long root_inode;
 	unsigned short flags;
@@ -124,8 +123,8 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = le32_to_cpu(sblk->s_magic);
 	if (sb->s_magic != SQUASHFS_MAGIC) {
 		if (!silent)
-			ERROR("Can't find a SQUASHFS superblock on %s\n",
-						bdevname(sb->s_bdev, b));
+			ERROR("Can't find a SQUASHFS superblock on %pg\n",
+						sb->s_bdev);
 		goto failed_mount;
 	}
 
@@ -178,7 +177,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	flags = le16_to_cpu(sblk->flags);
 
-	TRACE("Found valid superblock on %s\n", bdevname(sb->s_bdev, b));
+	TRACE("Found valid superblock on %pg\n", sb->s_bdev);
 	TRACE("Inodes are %scompressed\n", SQUASHFS_UNCOMPRESSED_INODES(flags)
 				? "un" : "");
 	TRACE("Data is %scompressed\n", SQUASHFS_UNCOMPRESSED_DATA(flags)
diff --git a/fs/super.c b/fs/super.c
index 2b7dc90..581e0ad 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -997,10 +997,8 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 		blkdev_put(bdev, mode);
 		down_write(&s->s_umount);
 	} else {
-		char b[BDEVNAME_SIZE];
-
 		s->s_mode = mode;
-		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
+		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		sb_set_blocksize(s, block_size(bdev));
 		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
 		if (error) {
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1790b00..cd5f060 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1633,13 +1633,9 @@ xfs_setsize_buftarg(
 	btp->bt_meta_sectormask = sectorsize - 1;
 
 	if (set_blocksize(btp->bt_bdev, sectorsize)) {
-		char name[BDEVNAME_SIZE];
-
-		bdevname(btp->bt_bdev, name);
-
 		xfs_warn(btp->bt_mount,
-			"Cannot set_blocksize to %u on device %s",
-			sectorsize, name);
+			"Cannot set_blocksize to %u on device %pg",
+			sectorsize, btp->bt_bdev);
 		return -EINVAL;
 	}
 
-- 
1.7.1

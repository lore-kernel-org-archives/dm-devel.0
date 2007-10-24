From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm: noflush resizing (1/3) Add bdlookup()
Date: Wed, 24 Oct 2007 17:25:38 -0400
Message-ID: <471FB852.8090802@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch adds bdlookup() and bdlookup_disk().
They are lookup-only variant of bdget()/bdget_disk().

The function can be used when
  - the caller wants to get bdev only if somebody already got it
    (i.e. there is already bd_inode allocated in memory)
  - the race between bdlookup() and bdget() is acceptable

The patch is a preparation for the 2nd part of this patchset.

Background:
  inode is initialized with I_LOCK and I_NEW turned on.
  After initialization, both flags are turned off.

  bdget() uses iget5_locked(), which waits until I_LOCK is removed.
  It could take so long or forever.


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
 fs/block_dev.c        |   27 +++++++++++++++++++++++++++
 include/linux/fs.h    |    4 +++-
 include/linux/genhd.h |    6 ++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6.23.work/fs/block_dev.c
===================================================================
--- linux-2.6.23.work.orig/fs/block_dev.c
+++ linux-2.6.23.work/fs/block_dev.c
@@ -586,6 +586,33 @@ struct block_device *bdget(dev_t dev)
 
 EXPORT_SYMBOL(bdget);
 
+/*
+ * Variant of bdget(), which returns bdev only when it is already gotten.
+ *
+ * The function can be used when:
+ *   - the caller wants to get bdev only if somebody already got it
+ *     (i.e. there is already bd_inode allocated in memory)
+ * and
+ *   - the race between bdlookup() and bdget() is acceptable
+ */
+struct block_device *bdlookup(dev_t dev)
+{
+	struct inode *inode;
+
+	might_sleep();
+
+	/* Use _nowait because we don't want to wait for I_LOCK */
+	inode = ilookup5_nowait(bd_mnt->mnt_sb, hash(dev), bdev_test, &dev);
+
+	if (!inode)
+		return NULL;
+
+	wait_on_bit(&inode->i_state, __I_NEW, inode_wait, TASK_UNINTERRUPTIBLE);
+
+	return &BDEV_I(inode)->bdev;
+}
+EXPORT_SYMBOL(bdlookup);
+
 long nr_blockdev_pages(void)
 {
 	struct block_device *bdev;
Index: linux-2.6.23.work/include/linux/fs.h
===================================================================
--- linux-2.6.23.work.orig/include/linux/fs.h
+++ linux-2.6.23.work/include/linux/fs.h
@@ -1211,10 +1211,11 @@ struct super_operations {
 #define I_DIRTY_DATASYNC	2 /* Data-related inode changes pending */
 #define I_DIRTY_PAGES		4 /* Data-related inode changes pending */
 #define __I_LOCK		3
+#define __I_NEW			6
 #define I_LOCK			(1 << __I_LOCK)
 #define I_FREEING		16
 #define I_CLEAR			32
-#define I_NEW			64
+#define I_NEW			(1 << __I_NEW)
 #define I_WILL_FREE		128
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
@@ -1431,6 +1432,7 @@ extern void putname(const char *name);
 extern int register_blkdev(unsigned int, const char *);
 extern void unregister_blkdev(unsigned int, const char *);
 extern struct block_device *bdget(dev_t);
+extern struct block_device *bdlookup(dev_t);
 extern void bd_set_size(struct block_device *, loff_t size);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
Index: linux-2.6.23.work/include/linux/genhd.h
===================================================================
--- linux-2.6.23.work.orig/include/linux/genhd.h
+++ linux-2.6.23.work/include/linux/genhd.h
@@ -435,6 +435,12 @@ static inline struct block_device *bdget
 	return bdget(MKDEV(disk->major, disk->first_minor) + index);
 }
 
+static inline struct block_device *bdlookup_disk(struct gendisk *disk,
+						 int index)
+{
+	return bdlookup(MKDEV(disk->major, disk->first_minor) + index);
+}
+
 #endif
 
 #else /* CONFIG_BLOCK */

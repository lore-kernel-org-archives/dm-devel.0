From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not
	mutex
Date: Tue, 7 Nov 2006 18:34:59 +0000
Message-ID: <20061107183459.GG6993@agk.surrey.redhat.com>
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
Cc: Srinivasa DS <srinivasa@in.ibm.com>, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Srinivasa Ds <srinivasa@in.ibm.com>

On debugging I found out that,"dmsetup suspend <device name>" calls
"freeze_bdev()",which locks "bd_mount_mutex" to make sure that no new mounts
happen on bdev until thaw_bdev() is called.  This "thaw_bdev()" is getting
called when we resume the device through "dmsetup resume <device-name>".
Hence we have 2 processes,one of which locks "bd_mount_mutex"(dmsetup
suspend) and another(dmsetup resume) unlocks it.                                               

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc4/fs/block_dev.c
===================================================================
--- linux-2.6.19-rc4.orig/fs/block_dev.c	2006-11-07 17:06:20.000000000 +0000
+++ linux-2.6.19-rc4/fs/block_dev.c	2006-11-07 17:26:04.000000000 +0000
@@ -263,7 +263,7 @@ static void init_once(void * foo, kmem_c
 	{
 		memset(bdev, 0, sizeof(*bdev));
 		mutex_init(&bdev->bd_mutex);
-		mutex_init(&bdev->bd_mount_mutex);
+		sema_init(&bdev->bd_mount_sem, 1);
 		INIT_LIST_HEAD(&bdev->bd_inodes);
 		INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
Index: linux-2.6.19-rc4/fs/buffer.c
===================================================================
--- linux-2.6.19-rc4.orig/fs/buffer.c	2006-11-07 17:06:20.000000000 +0000
+++ linux-2.6.19-rc4/fs/buffer.c	2006-11-07 17:26:04.000000000 +0000
@@ -188,7 +188,9 @@ struct super_block *freeze_bdev(struct b
 {
 	struct super_block *sb;
 
-	mutex_lock(&bdev->bd_mount_mutex);
+	if (down_trylock(&bdev->bd_mount_sem))
+		return -EBUSY;
+
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
 		sb->s_frozen = SB_FREEZE_WRITE;
@@ -230,7 +232,7 @@ void thaw_bdev(struct block_device *bdev
 		drop_super(sb);
 	}
 
-	mutex_unlock(&bdev->bd_mount_mutex);
+	up(&bdev->bd_mount_sem);
 }
 EXPORT_SYMBOL(thaw_bdev);
 
Index: linux-2.6.19-rc4/fs/super.c
===================================================================
--- linux-2.6.19-rc4.orig/fs/super.c	2006-11-07 17:06:20.000000000 +0000
+++ linux-2.6.19-rc4/fs/super.c	2006-11-07 17:26:04.000000000 +0000
@@ -735,9 +735,9 @@ int get_sb_bdev(struct file_system_type 
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	mutex_lock(&bdev->bd_mount_mutex);
+	down(&bdev->bd_mount_sem);
 	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
-	mutex_unlock(&bdev->bd_mount_mutex);
+	up(&bdev->bd_mount_sem);
 	if (IS_ERR(s))
 		goto error_s;
 
Index: linux-2.6.19-rc4/include/linux/fs.h
===================================================================
--- linux-2.6.19-rc4.orig/include/linux/fs.h	2006-11-07 17:06:20.000000000 +0000
+++ linux-2.6.19-rc4/include/linux/fs.h	2006-11-07 17:26:04.000000000 +0000
@@ -456,7 +456,7 @@ struct block_device {
 	struct inode *		bd_inode;	/* will die */
 	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
-	struct mutex		bd_mount_mutex;	/* mount mutex */
+	struct semaphore        bd_mount_sem;
 	struct list_head	bd_inodes;
 	void *			bd_holder;
 	int			bd_holders;

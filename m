From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 4/10] xfs: Fix error handling in
	write_super_lockfs/unlockfs
Date: Fri, 26 Sep 2008 17:58:06 +0900
Message-ID: <20080926175807t-sato@mail.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redh>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Changed write_super_lockfs so that it returns an error in case of an failure.
unlockfs always returns 0.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 linux-2.6/xfs_super.c |    8 ++++----
 xfs_fsops.c           |   11 +++++++----
 xfs_fsops.h           |    2 +-
 3 files changed, 12 insertions(+), 9 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-ext4/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext4/fs/xfs/linux-2.6/xfs_supe
r.c linux-2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c
--- linux-2.6.27-rc7-lockfs-ext4/fs/xfs/linux-2.6/xfs_super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-09-26 20:43:42.000000000 +0900
@@ -1351,14 +1351,14 @@ xfs_fs_remount(
  * need to take care of themetadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
-STATIC void
-xfs_fs_lockfs(
+STATIC int
+xfs_fs_freeze(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_attr_quiesce(mp);
-	xfs_fs_log_dummy(mp);
+	return -xfs_fs_log_dummy(mp);
 }
 
 STATIC int
@@ -1847,7 +1847,7 @@ static struct super_operations xfs_super
 	.put_super		= xfs_fs_put_super,
 	.write_super		= xfs_fs_write_super,
 	.sync_fs		= xfs_fs_sync_super,
-	.write_super_lockfs	= xfs_fs_lockfs,
+	.freeze_fs		= xfs_fs_freeze,
 	.statfs			= xfs_fs_statfs,
 	.remount_fs		= xfs_fs_remount,
 	.show_options		= xfs_fs_show_options,
diff -uprN -X linux-2.6.27-rc7-lockfs-ext4/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext4/fs/xfs/xfs_fsops.c linux-
2.6.27-rc7-lockfs-xfs/fs/xfs/xfs_fsops.c
--- linux-2.6.27-rc7-lockfs-ext4/fs/xfs/xfs_fsops.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-xfs/fs/xfs/xfs_fsops.c	2008-09-26 20:39:14.000000000 +0900
@@ -589,17 +589,19 @@ out:
 	return 0;
 }
 
-void
+int
 xfs_fs_log_dummy(
 	xfs_mount_t	*mp)
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
+	int		error;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
-	if (xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0)) {
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
-		return;
+		return error;
 	}
 
 	ip = mp->m_rootip;
@@ -609,9 +611,10 @@ xfs_fs_log_dummy(
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_set_sync(tp);
-	xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp, 0);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 int
diff -uprN -X linux-2.6.27-rc7-lockfs-ext4/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext4/fs/xfs/xfs_fsops.h linux-
2.6.27-rc7-lockfs-xfs/fs/xfs/xfs_fsops.h
--- linux-2.6.27-rc7-lockfs-ext4/fs/xfs/xfs_fsops.h	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-xfs/fs/xfs/xfs_fsops.h	2008-09-26 20:39:14.000000000 +0900
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern void xfs_fs_log_dummy(xfs_mount_t *mp);
+extern int xfs_fs_log_dummy(xfs_mount_t *mp);
 
 #endif	/* __XFS_FSOPS_H__ */

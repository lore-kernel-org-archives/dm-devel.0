From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 5/10] gfs2: Fix error handling in
	write_super_lockfs/unlockfs
Date: Fri, 26 Sep 2008 17:58:21 +0900
Message-ID: <20080926175821t-sato@mail.jp.nec.com>
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

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 ops_super.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-reiserfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-reiserfs/fs/gfs2/ops_super
.c linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c
--- linux-2.6.27-rc7-lockfs-reiserfs/fs/gfs2/ops_super.c	2008-09-26 12:24:01.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c	2008-09-26 17:02:06.000000000 +0900
@@ -161,18 +161,18 @@ static int gfs2_sync_fs(struct super_blo
 }
 
 /**
- * gfs2_write_super_lockfs - prevent further writes to the filesystem
+ * gfs2_freeze - prevent further writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_write_super_lockfs(struct super_block *sb)
+static int gfs2_freeze(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return;
+		return -EINVAL;
 
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
@@ -192,17 +192,19 @@ static void gfs2_write_super_lockfs(stru
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
+	return 0;
 }
 
 /**
- * gfs2_unlockfs - reallow writes to the filesystem
+ * gfs2_unfreeze - reallow writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_unlockfs(struct super_block *sb)
+static int gfs2_unfreeze(struct super_block *sb)
 {
 	gfs2_unfreeze_fs(sb->s_fs_info);
+	return 0;
 }
 
 /**
@@ -505,8 +507,8 @@ const struct super_operations gfs2_super
 	.put_super		= gfs2_put_super,
 	.write_super		= gfs2_write_super,
 	.sync_fs		= gfs2_sync_fs,
-	.write_super_lockfs 	= gfs2_write_super_lockfs,
-	.unlockfs		= gfs2_unlockfs,
+	.freeze_fs 		= gfs2_freeze,
+	.unfreeze_fs		= gfs2_unfreeze,
 	.statfs			= gfs2_statfs,
 	.remount_fs		= gfs2_remount_fs,
 	.clear_inode		= gfs2_clear_inode,

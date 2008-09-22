From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 6/10] gfs2: Fix error handling in
	write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 19:57:18 +0900
Message-ID: <20080922195718t-sato@mail.jp.nec.com>
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

I've changed write_super_lockfs/unlockfs so that they always return
0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 ops_super.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-ext4/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c linux
-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c
--- linux-2.6.27-rc7-lockfs-ext4/fs/gfs2/ops_super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c	2008-09-22 10:52:16.000000000 +0900
@@ -166,13 +166,13 @@ static int gfs2_sync_fs(struct super_blo
  *
  */
 
-static void gfs2_write_super_lockfs(struct super_block *sb)
+static int gfs2_write_super_lockfs(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return;
+		return 0;
 
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
@@ -192,6 +192,7 @@ static void gfs2_write_super_lockfs(stru
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
+	return 0;
 }
 
 /**
@@ -200,9 +201,10 @@ static void gfs2_write_super_lockfs(stru
  *
  */
 
-static void gfs2_unlockfs(struct super_block *sb)
+static int gfs2_unlockfs(struct super_block *sb)
 {
 	gfs2_unfreeze_fs(sb->s_fs_info);
+	return 0;
 }
 
 /**

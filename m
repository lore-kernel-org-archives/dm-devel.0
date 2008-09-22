From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 5/10] reiserfs: Fix error handling in
	write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 19:57:01 +0900
Message-ID: <20080922195701t-sato@mail.jp.nec.com>
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
 super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-jfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-jfs/fs/reiserfs/super.c linux-2
.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c
--- linux-2.6.27-rc7-lockfs-jfs/fs/reiserfs/super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-reiserfs/fs/reiserfs/super.c	2008-09-22 11:08:04.000000000 +0900
@@ -83,7 +83,7 @@ static void reiserfs_write_super(struct 
 	reiserfs_sync_fs(s, 1);
 }
 
-static void reiserfs_write_super_lockfs(struct super_block *s)
+static int reiserfs_write_super_lockfs(struct super_block *s)
 {
 	struct reiserfs_transaction_handle th;
 	reiserfs_write_lock(s);
@@ -101,11 +101,13 @@ static void reiserfs_write_super_lockfs(
 	}
 	s->s_dirt = 0;
 	reiserfs_write_unlock(s);
+	return 0;
 }
 
-static void reiserfs_unlockfs(struct super_block *s)
+static int reiserfs_unlockfs(struct super_block *s)
 {
 	reiserfs_allow_writes(s);
+	return 0;
 }
 
 extern const struct in_core_key MAX_IN_CORE_KEY;

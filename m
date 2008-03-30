From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] drivers/md/dm-table.c: fix void returns
Date: Mon, 31 Mar 2008 02:28:39 +0300
Message-ID: <20080330232839.GY28445@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758613AbYC3X3l@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

void returning functions returned the return value of another void 
returning function...

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/md/dm-table.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

6b1b4f659d1dfff36c6cf740353dc040e56c1bc2 diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ce27283..545d8c6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -916,7 +916,7 @@ void dm_table_presuspend_targets(struct dm_table *t)
 	if (!t)
 		return;
 
-	return suspend_targets(t, 0);
+	suspend_targets(t, 0);
 }
 
 void dm_table_postsuspend_targets(struct dm_table *t)
@@ -924,7 +924,7 @@ void dm_table_postsuspend_targets(struct dm_table *t)
 	if (!t)
 		return;
 
-	return suspend_targets(t, 1);
+	suspend_targets(t, 1);
 }
 
 int dm_table_resume_targets(struct dm_table *t)

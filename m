From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] drivers/md/dm-table.c: fix void returns
Date: Mon, 14 Apr 2008 21:41:49 +0300
Message-ID: <20080414184149.GX6695@cs181133002.pp.htv.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

void returning functions returned the return value of another void 
returning function...

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

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

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: [PATCH] dm: fix wrong comment
Date: Wed, 24 Dec 2014 14:48:12 +0800
Message-ID: <1419403692-2298-1-git-send-email-junxiao.bi@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

dm_table_put() had been replaced by dm_put_live_table().

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/md/dm-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 73f791b..c8a18e4 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -639,8 +639,8 @@ static int check_name(const char *name)
 
 /*
  * On successful return, the caller must not attempt to acquire
- * _hash_lock without first calling dm_table_put, because dm_table_destroy
- * waits for this dm_table_put and could be called under this lock.
+ * _hash_lock without first calling dm_put_live_table, because dm_table_destroy
+ * waits for this dm_put_live_table and could be called under this lock.
  */
 static struct dm_table *dm_get_inactive_table(struct mapped_device *md, int *srcu_idx)
 {
-- 
1.7.9.5

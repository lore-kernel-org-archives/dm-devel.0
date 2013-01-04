From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] dm: cleanup: remove the unnecessary NULL set to
 the local var *t after kfreed in dm_table_create
Date: Fri, 04 Jan 2013 08:26:52 +0800
Message-ID: <50E621CC.8040009@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

If allocation fails, the local var *t is not used any more after kfreed.
Don't need to reset it to NULL. Remove the unnecesary NULL set here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  drivers/md/dm-table.c |    1 -
  1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index daf25d0..c95405d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -217,7 +217,6 @@ int dm_table_create(struct dm_table **result, 
fmode_t mode,

      if (alloc_targets(t, num_targets)) {
          kfree(t);
-        t = NULL;
          return -ENOMEM;
      }

-- 
1.7.10.4

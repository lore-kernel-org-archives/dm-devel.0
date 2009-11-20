From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/4] dm: move DMF_SUSPENDED flag set before
	postsuspend
Date: Fri, 20 Nov 2009 16:08:58 +0900
Message-ID: <4B06408A.1080700@ct.jp.nec.com>
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
To: Alasdair Kergon <agk@redhat.com>, Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch moves DMF_SUSPENDED flag set before postsuspend.
No one should care about the ordering, because the flag set and
the postsuspend are protected by a single lock, md->suspend_lock,
and all strict flag-checkers take the lock.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.32-rc7/drivers/md/dm.c
===================================================================
--- 2.6.32-rc7.orig/drivers/md/dm.c
+++ 2.6.32-rc7/drivers/md/dm.c
@@ -2542,10 +2542,10 @@ int dm_suspend(struct mapped_device *md,
 	 * requests are being added to md->deferred list.
 	 */
 
-	dm_table_postsuspend_targets(map);
-
 	set_bit(DMF_SUSPENDED, &md->flags);
 
+	dm_table_postsuspend_targets(map);
+
 out:
 	dm_table_put(map);
 

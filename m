From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 2/8] dm-integrity: change the variable suspending
	from bool to int
Date: Tue, 01 May 2018 15:55:18 +0200
Message-ID: <20180501135600.434701234@debian.vm>
References: <20180501135516.961417937@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-suspending.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The early alpha processors can't write a byte or short atomically, so
asynchronously-modified variables shouldn't really have byte type.
Change is to int.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-05-01 00:23:32.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-05-01 00:38:57.000000000 +0200
@@ -178,7 +178,7 @@ struct dm_integrity_c {
 	__u8 sectors_per_block;
 
 	unsigned char mode;
-	bool suspending;
+	int suspending;
 
 	int failed;
 
@@ -2210,7 +2210,7 @@ static void dm_integrity_postsuspend(str
 
 	del_timer_sync(&ic->autocommit_timer);
 
-	ic->suspending = true;
+	WRITE_ONCE(ic->suspending, 1);
 
 	queue_work(ic->commit_wq, &ic->commit_work);
 	drain_workqueue(ic->commit_wq);
@@ -2220,7 +2220,7 @@ static void dm_integrity_postsuspend(str
 		dm_integrity_flush_buffers(ic);
 	}
 
-	ic->suspending = false;
+	WRITE_ONCE(ic->suspending, 0);
 
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/9] dm-integrity: change the variable suspending from bool to int
Date: Wed, 06 Jun 2018 17:33:08 +0200
Message-ID: <20180606153431.226306753@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline; filename=dm-integrity-suspending.patch
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

The early alpha processors can't write a byte or short atomically - they
read 8 bytes, modify the byte or two bytes in registers and write back 8
bytes. The modification of the variable "suspending" may race with
modification of the variable "failed".

This patch changes suspending to an int.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

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
 

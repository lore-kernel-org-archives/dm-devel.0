From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/9] dm-integrity: change the variable suspending from bool to int
Date: Tue, 03 Jul 2018 20:13:25 +0200
Message-ID: <20180703181354.369889280@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline; filename=dm-integrity-suspending.patch
Sender: stable-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
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
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-06-29 23:13:54.990000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-06-29 23:13:54.980000000 +0200
@@ -178,7 +178,7 @@ struct dm_integrity_c {
 	__u8 sectors_per_block;
 
 	unsigned char mode;
-	bool suspending;
+	int suspending;
 
 	int failed;
 
@@ -2214,7 +2214,7 @@ static void dm_integrity_postsuspend(str
 
 	del_timer_sync(&ic->autocommit_timer);
 
-	ic->suspending = true;
+	WRITE_ONCE(ic->suspending, 1);
 
 	queue_work(ic->commit_wq, &ic->commit_work);
 	drain_workqueue(ic->commit_wq);
@@ -2224,7 +2224,7 @@ static void dm_integrity_postsuspend(str
 		dm_integrity_flush_buffers(ic);
 	}
 
-	ic->suspending = false;
+	WRITE_ONCE(ic->suspending, 0);
 
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 

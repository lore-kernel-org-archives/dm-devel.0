From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/11] bottom-layer barrier support
Date: Fri, 10 Apr 2009 01:13:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904100113280.1117@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100110010.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100110370.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100111110.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100112060.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100112330.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100113050.1117@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904100113050.1117@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Modify dm_flush so that is passes empty barrier flushes to the targets.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm.c	2009-04-10 06:33:31.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm.c	2009-04-10 06:33:34.000000000 +0200
@@ -175,6 +175,9 @@ struct mapped_device {
 
 	/* sysfs handle */
 	struct kobject kobj;
+
+	/* zero-length barrier that will be cloned and submitted to targets */
+	struct bio barrier_bio;
 };
 
 #define MIN_IOS 256
@@ -1460,6 +1463,13 @@ static int dm_wait_for_completion(struct
 static void dm_flush(struct mapped_device *md)
 {
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+
+	bio_init(&md->barrier_bio);
+	md->barrier_bio.bi_bdev = md->bdev;
+	md->barrier_bio.bi_rw = WRITE_BARRIER;
+	__split_and_process_bio(md, &md->barrier_bio);
+
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 }
 
 /*

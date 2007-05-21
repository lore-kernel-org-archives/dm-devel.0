From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 2/10]
	dm-raid1-handle-log-failure.patch
Date: Mon, 21 May 2007 17:00:53 -0500
Message-ID: <1179784853.13913.20.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

 brassow

When writing to a mirror, we must update the log first.  Failure
to update the log could result in the log not properly reflecting
the state of the mirror if the machine should crash.

We change the return type of the rh_flush function to give us
the ability to check if a log write was successful.  If the
log write was unsuccessful, we fail the writes to prevent the
case where the log does not properly reflect the state of the
mirror.

A follow-up patch - which is dependent on the ability to
requeue I/O's to core device-mapper - will requeue the I/O's
for retry (allowing the mirror to be reconfigured.)

Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -133,6 +133,7 @@ struct mirror_set {
 	/* recovery */
 	region_t nr_regions;
 	int in_sync;
+	int log_failure;
 
 	struct mirror *default_mirror;	/* Default mirror */
 
@@ -591,9 +592,9 @@ static void rh_recovery_end(struct regio
 	wake(rh->ms);
 }
 
-static void rh_flush(struct region_hash *rh)
+static int rh_flush(struct region_hash *rh)
 {
-	rh->log->type->flush(rh->log);
+	return rh->log->type->flush(rh->log);
 }
 
 static void rh_delay(struct region_hash *rh, struct bio *bio)
@@ -894,13 +895,17 @@ static void do_writes(struct mirror_set 
 	 */
 	rh_inc_pending(&ms->rh, &sync);
 	rh_inc_pending(&ms->rh, &nosync);
-	rh_flush(&ms->rh);
+	ms->log_failure = (rh_flush(&ms->rh)) ? 1 : 0;
 
 	/*
 	 * Dispatch io.
 	 */
-	while ((bio = bio_list_pop(&sync)))
-		do_write(ms, bio);
+	if (unlikely(ms->log_failure))
+		while ((bio = bio_list_pop(&sync)))
+			bio_endio(bio, bio->bi_size, -EIO);
+	else
+		while ((bio = bio_list_pop(&sync)))
+			do_write(ms, bio);
 
 	while ((bio = bio_list_pop(&recover)))
 		rh_delay(&ms->rh, bio);

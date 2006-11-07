From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 10 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:06:38 -0600
Message-ID: <1162915598.17899.56.camel@hydrogen.msp.redhat.com>
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
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

This patch finishes off the previous patch of similar name, but the
patches giving the ability to requeue bios to core device-mapper
must be in place.

This patch requeues write requests if the log can not be updated.

Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-06 16:59:32.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-06 16:59:53.000000000 -0600
@@ -973,14 +973,12 @@ static void do_write(struct mirror_set *
 	struct io_region io[KCOPYD_MAX_REGIONS+1];
 	struct mirror *m;
 
-	/*
-	 * FIXME: Requeue I/O to dm-core
-	 * Otherwise, errors result if log device fails.
-	 * We cannot allow writes to continue if log device
-	 * is dead.
-	 */
 	if (log_failure) {
-		bio_endio(bio, bio->bi_size, -EIO);
+		/*
+		 * Requeue I/O to dm-core.  We cannot allow
+		 * writes to continue if log device is dead.
+		 */
+		bio_endio(bio, bio->bi_size, DM_ENDIO_REQUEUE);
 		return;
 	}
 

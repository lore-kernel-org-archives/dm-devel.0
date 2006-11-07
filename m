From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 5 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:02:08 -0600
Message-ID: <1162915328.17899.44.camel@hydrogen.msp.redhat.com>
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

This patch applies a different method for handling log device failures
during a resume.  (This is why it is a 'part2' and not in the original
patch of similar name.)

When device-mapper resumes a target, it does not allow for the
possibility of failure (the return type is void).  This is of
some concern in the case of mirrors.

A resume on a mirror triggers a log resume.  If the log is disk
based and the log device has failed, there is no way for mirror
to pass that failure up.

The best thing we can do in this case is have the logging code
assume that all regions are out of sync if it fails to read the
log when it resumes.  This way, no corruption is possible.

When the mirror issues it's first write it must 'flush' the log
changes to disk before doing so.  If the failure has persisted,
the failure to flush can be responded to by the mirror.  No data
can be written to the mirror without first updating the log.

At this point, the user can choose to load a new mirror table
that utilizes a core log, revive the failed log device, or use
a new log device.

Index: linux-2.6.18.1/drivers/md/dm-log.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-log.c	2006-11-01 14:37:19.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-log.c	2006-11-01 14:39:07.000000000 -0600
@@ -461,7 +461,20 @@ static int disk_resume(struct dirty_log 
 		DMWARN("Failed to read header on mirror log device, %s",
 		       lc->log_dev->name);
 		fail_log_device(lc);
-		return r;
+		/*
+		 * Mirror does nothing in response to a failed resume.
+		 * In fact, it can do nothing, because the return type
+		 * for resume for a target is 'void'.  Therefore, we
+		 * must assume everything is out-of-sync.  Loose the
+		 * log device and loose the ability to recover quickly.
+		 *
+		 * Mirror can respond to a log device failure when it
+		 * tries to do a flush, however.
+		 *
+		 * So, we set nr_regions here rather than returning the
+		 * error.
+		 */
+		lc->header.nr_regions = 0;
 	}
 
 	/* set or clear any new bits -- device has grown */

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] dm-log-fix-uninitialized-state.patch
Date: Thu, 05 Apr 2007 11:33:05 -0500
Message-ID: <1175790785.24640.2.camel@hydrogen.msp.redhat.com>
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

Applies to linux-2.6.21-rc5-mm4

 brassow

This patch removes the possibility of having uninitialized
log state if the log device has failed.

When a mirror resumes operation, it calls 'resume' on the
logging module.  If disk based logging is being used, the
log device is read to fill in the log state.  If the log
device has failed, we cannot simply return, because this
would leave the in-memory log state uninitialized.  Instead,
we assume all regions are out-of-sync and reset the log
state.  Failure to do this could result in the logging code
reporting a region as in-sync, even though it isn't; which
could result in a corrupted mirror.

Index: linux-2.6.21-rc5-mm4/drivers/md/dm-log.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/drivers/md/dm-log.c
+++ linux-2.6.21-rc5-mm4/drivers/md/dm-log.c
@@ -478,7 +478,14 @@ static int disk_resume(struct dirty_log 
 		DMWARN("%s: Failed to read header on mirror log device",
 		       lc->log_dev->name);
 		fail_log_device(lc);
-		return r;
+		/*
+		 * If the log device cannot be read, we must assume
+		 * all regions are out-of-sync.  If we simply return
+		 * here, the state will be uninitialized and could
+		 * lead us to return 'in-sync' status for regions
+		 * that are actually 'out-of-sync'.
+		 */
+		lc->header.nr_regions = 0;
 	}
 
 	/* set or clear any new bits -- device has grown */

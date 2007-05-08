From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 26/26] dm log: fix resume failed log device
Date: Tue, 8 May 2007 20:49:27 +0100
Message-ID: <20070508194927.GG24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

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

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-log.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.21/drivers/md/dm-log.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-log.c	2007-05-01 19:20:13.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-log.c	2007-05-01 19:20:21.000000000 +0100
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

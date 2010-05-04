From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/2] dm: Add feature flags to dm-mpath
Date: Mon,  3 May 2010 21:01:30 -0700
Message-ID: <1272945691-31649-2-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

Add a feature flag attribute to the multipath structure.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-mpath.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 826bce7..4200d03 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -82,6 +82,7 @@ struct multipath {
 	unsigned saved_queue_if_no_path;/* Saved state during suspension */
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
+	unsigned long features;
 
 	struct work_struct process_queued_ios;
 	struct list_head queued_ios;
@@ -118,6 +119,15 @@ static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
 static void deactivate_path(struct work_struct *work);
 
+static int multipath_test_feature(struct multipath *m, unsigned feature)
+{
+	return test_bit(feature, &m->features);
+}
+
+static void multipath_set_feature(struct multipath *m, unsigned feature)
+{
+	set_bit(feature, &m->features);
+}
 
 /*-----------------------------------------------
  * Allocation routines
-- 
1.6.6.1


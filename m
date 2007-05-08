From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 12/26] dm log: report fault status
Date: Tue, 8 May 2007 20:46:51 +0100
Message-ID: <20070508194651.GS24114@agk.fab.redhat.com>
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

From: Jonathan E Brassow <jbrassow@redhat.com>

This patch reports the status of the log device so that userspace
can detect the error and take appropriate action.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-log.c   |    7 ++++---
 drivers/md/dm-raid1.c |   11 +++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.21/drivers/md/dm-log.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-log.c	2007-05-01 17:40:51.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-log.c	2007-05-01 17:40:51.000000000 +0100
@@ -615,6 +615,7 @@ static int core_status(struct dirty_log 
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("1 %s", log->type->name);
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -630,17 +631,17 @@ static int disk_status(struct dirty_log 
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
-	char buffer[16];
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
+		       lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
-		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
 		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, buffer,
+		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
 	}
Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 17:40:46.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 17:40:51.000000000 +0100
@@ -1205,11 +1205,9 @@ static void mirror_resume(struct dm_targ
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	unsigned int m, sz;
+	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 
-	sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
-
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
@@ -1220,9 +1218,14 @@ static int mirror_status(struct dm_targe
 			(unsigned long long)ms->rh.log->type->
 				get_sync_count(ms->rh.log),
 			(unsigned long long)ms->nr_regions);
+
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+
 		break;
 
 	case STATUSTYPE_TABLE:
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+
 		DMEMIT("%d", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
@@ -1234,7 +1237,7 @@ static int mirror_status(struct dm_targe
 
 static struct target_type mirror_target = {
 	.name	 = "mirror",
-	.version = {1, 0, 2},
+	.version = {1, 0, 3},
 	.module	 = THIS_MODULE,
 	.ctr	 = mirror_ctr,
 	.dtr	 = mirror_dtr,

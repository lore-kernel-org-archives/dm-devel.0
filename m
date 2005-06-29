From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 3 of 8] device failure tolerance
Date: Wed, 29 Jun 2005 13:19:36 -0500
Message-ID: <81dff920a130cbb1abecd2352d0daddd@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Kergon Alasdair <agk@redhat.com>
List-Id: dm-devel.ids

This patch changes the status info returned from the log and the mirror 
code so that they display whether a device is dead (D) or alive (A).  
This is needed in order for the user-land programs to be able to 
determine which device is bad in the event of a failure.

  brassow

diff -urN linux-2.6.12-003/drivers/md/dm-log.c 
linux-2.6.12-004/drivers/md/dm-log.c
--- linux-2.6.12-003/drivers/md/dm-log.c	2005-06-28 16:02:39.071277119 
-0500
+++ linux-2.6.12-004/drivers/md/dm-log.c	2005-06-28 16:40:49.157122050 
-0500
@@ -679,12 +679,22 @@

  	switch(status) {
  	case STATUSTYPE_INFO:
+		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
+		DMEMIT("%s %u %s%s %u ",
+		       log->type->name,
+		       lc->sync == DEFAULTSYNC ? 2 : 3,
+		       buffer,
+		       lc->log_dev_failed ? "/D" : "/A",
+		       lc->region_size);
+		DMEMIT_SYNC;
  		break;

  	case STATUSTYPE_TABLE:
  		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
-		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, buffer,
+		DMEMIT("%s %u %s %u ",
+		       log->type->name,
+		       lc->sync == DEFAULTSYNC ? 2 : 3,
+		       buffer,
  		       lc->region_size);
  		DMEMIT_SYNC;
  	}
diff -urN linux-2.6.12-003/drivers/md/dm-raid1.c 
linux-2.6.12-004/drivers/md/dm-raid1.c
--- linux-2.6.12-003/drivers/md/dm-raid1.c	2005-06-28 
16:02:33.953912094 -0500
+++ linux-2.6.12-004/drivers/md/dm-raid1.c	2005-06-28 
16:46:37.167943233 -0500
@@ -1204,8 +1204,11 @@
  	switch (type) {
  	case STATUSTYPE_INFO:
  		DMEMIT("%d ", ms->nr_mirrors);
-		for (m = 0; m < ms->nr_mirrors; m++)
-			DMEMIT("%s ", ms->mirror[m].dev->name);
+		for (m = 0; m < ms->nr_mirrors; m++) {
+			DMEMIT("%s/%s ", ms->mirror[m].dev->name,
+			       atomic_read(&(ms->mirror[m].error_count)) ?
+			       "D" : "A");
+		}

  		DMEMIT(SECTOR_FORMAT "/" SECTOR_FORMAT,
  		       ms->rh.log->type->get_sync_count(ms->rh.log),

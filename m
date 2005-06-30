From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 03:00:45 -0500
Message-ID: <d459df3fa77e2c972d837f613a137de5@redhat.com>
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

This patch changes the status output.  It will break pvmove and other 
things that may have been parsing the status output of a mirror.  It is 
necessary, however, if we are going to have a way to determine which 
device in a mirror failed - or distinguish an failure event from one 
that may simply signal the device is in-sync.  Right now, different 
logs may output different arguments (device and failure, region size, 
sync/nosync, etc), which may make it difficult to parse.  I wondered 
about just having the log type and device with liveness status.  
However, this would still have variable arguments between core and disk 
- or some future scheme that may use multiple log devices for 
redundancy.

  brassow

diff -urN linux-2.6.12-00004/drivers/md/dm-log.c 
linux-2.6.12-00005/drivers/md/dm-log.c
--- linux-2.6.12-00004/drivers/md/dm-log.c	2005-06-30 
01:44:58.277954335 -0500
+++ linux-2.6.12-00005/drivers/md/dm-log.c	2005-06-30 
02:06:43.632391301 -0500
@@ -717,6 +717,9 @@

  	switch(status) {
  	case STATUSTYPE_INFO:
+		DMEMIT("%s %u %u ", log->type->name,
+		       lc->sync == DEFAULTSYNC ? 1 : 2, lc->region_size);
+		DMEMIT_SYNC;
  		break;

  	case STATUSTYPE_TABLE:
@@ -737,6 +740,14 @@

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
diff -urN linux-2.6.12-00004/drivers/md/dm-raid1.c 
linux-2.6.12-00005/drivers/md/dm-raid1.c
--- linux-2.6.12-00004/drivers/md/dm-raid1.c	2005-06-30 
01:56:19.457727576 -0500
+++ linux-2.6.12-00005/drivers/md/dm-raid1.c	2005-06-30 
01:56:27.164784984 -0500
@@ -1546,8 +1546,11 @@
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

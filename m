From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-raid: Do not call BUG() in __rdev_sectors()
Date: Wed, 28 Jun 2017 09:55:03 +0200
Message-ID: <1498636503-22484-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

__rdev_sectors() might be called for an invalid/non-existing
RAID set during raid_ctr(), which is perfectly fine and no
reason to panic.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-raid.c          | 3 ++-
 drivers/scsi/pmcraid.c        | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7d89322..9bbb596 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1571,7 +1571,8 @@ static sector_t __rdev_sectors(struct raid_set *rs)
 			return rdev->sectors;
 	}
 
-	BUG(); /* Constructor ensures we got some. */
+	/* No valid raid devices */
+	return 0;
 }
 
 /* Calculate the sectors per device and per array used for @rs */
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 56928d6..4b66b92 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3089,7 +3089,7 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 /**
  * pmcraid_eh_host_reset_handler - adapter reset handler callback
  *
- * @scmd: pointer to scsi_cmd that was sent to a resource of adapter
+ * @shost: pointer to scsi_host
  *
  * Initiates adapter reset to bring it up to operational state
  *
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5d55de5..11bd2da 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9367,7 +9367,7 @@ static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
 
 /**
  * qla4xxx_eh_host_reset - kernel callback
- * @cmd: Pointer to Linux's SCSI command structure
+ * @host: Pointer to Linux's SCSI host structure
  *
  * This routine is invoked by the Linux kernel to perform fatal error
  * recovery on the specified adapter.
-- 
1.8.5.6

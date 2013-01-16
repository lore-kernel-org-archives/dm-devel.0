From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/13] Remove unused structures
Date: Wed, 16 Jan 2013 13:14:11 +0100
Message-ID: <1358338456-1234-9-git-send-email-hare@suse.de>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

structs scsi_dev and scsi_idlun are unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 2beccb3..4085900 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -113,12 +113,6 @@ enum detect_prio_states {
 	DETECT_PRIO_ON,
 };
 
-struct scsi_idlun {
-	int dev_id;
-	int host_unique_id;
-	int host_no;
-};
-
 struct sg_id {
 	int host_no;
 	int channel;
@@ -130,12 +124,6 @@ struct sg_id {
 	int unused2;
 };
 
-struct scsi_dev {
-	char dev[FILE_NAME_SIZE];
-	struct scsi_idlun scsi_id;
-	int host_no;
-};
-
 # ifndef HDIO_GETGEO
 #  define HDIO_GETGEO	0x0301	/* get device geometry */
 
@@ -151,7 +139,6 @@ struct path {
 	char dev[FILE_NAME_SIZE];
 	char dev_t[BLK_DEV_SIZE];
 	struct udev_device *udev;
-	struct scsi_idlun scsi_id;
 	struct sg_id sg_id;
 	struct hd_geometry geom;
 	char wwid[WWID_SIZE];
-- 
1.7.4.2

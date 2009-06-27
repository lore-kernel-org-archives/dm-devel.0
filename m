From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: scsi_dh: Reference count scsi_dh_attach
Date: Fri, 26 Jun 2009 19:30:06 -0700
Message-ID: <1246069806.14164.49.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: dm-devel <dm-devel@redhat.com>, Mario Mech <mech@meteo.uni-koeln.de>
List-Id: dm-devel.ids

Problem reported: http://marc.info/?l=dm-devel&m=124585978305866&w=2

This patch fixes the problem:
-----------------
scsi_dh does not do a refernce count for attach/detach, and this affects
the way it is supposed to work with multipath when a device is not
in the dev_list of the hardware handler.

This patch adds a reference count that counts each attach.

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 drivers/scsi/device_handler/scsi_dh.c |   23 ++++++++++++++++-------
 include/scsi/scsi_device.h            |    2 ++
 2 files changed, 18 insertions(+), 7 deletions(-)

Index: linux-2.6.31-rc1/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.31-rc1.orig/include/scsi/scsi_device.h
+++ linux-2.6.31-rc1/include/scsi/scsi_device.h
@@ -191,6 +191,8 @@ struct scsi_device_handler {
 
 struct scsi_dh_data {
 	struct scsi_device_handler *scsi_dh;
+	struct scsi_device *sdev;
+	struct kref kref;
 	char buf[0];
 };
 
Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
@@ -153,12 +153,24 @@ static int scsi_dh_handler_attach(struct
 	if (sdev->scsi_dh_data) {
 		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
 			err = -EBUSY;
-	} else if (scsi_dh->attach)
+		else
+			kref_get(&sdev->scsi_dh_data->kref);
+	} else if (scsi_dh->attach) {
 		err = scsi_dh->attach(sdev);
-
+		if (!err) {
+			kref_init(&sdev->scsi_dh_data->kref);
+			sdev->scsi_dh_data->sdev = sdev;
+		}
+	}
 	return err;
 }
 
+static void __detach_handler (struct kref *kref)
+{
+	struct scsi_dh_data *scsi_dh_data = container_of(kref, struct scsi_dh_data, kref);
+	scsi_dh_data->scsi_dh->detach(scsi_dh_data->sdev);
+}
+
 /*
  * scsi_dh_handler_detach - Detach a device handler from a device
  * @sdev - SCSI device the device handler should be detached from
@@ -180,7 +192,7 @@ static void scsi_dh_handler_detach(struc
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 
 	if (scsi_dh && scsi_dh->detach)
-		scsi_dh->detach(sdev);
+		kref_put(&sdev->scsi_dh_data->kref, __detach_handler);
 }
 
 /*
@@ -474,7 +486,6 @@ int scsi_dh_attach(struct request_queue
 
 	if (!err) {
 		err = scsi_dh_handler_attach(sdev, scsi_dh);
-
 		put_device(&sdev->sdev_gendev);
 	}
 	return err;
@@ -505,10 +516,8 @@ void scsi_dh_detach(struct request_queue
 		return;
 
 	if (sdev->scsi_dh_data) {
-		/* if sdev is not on internal list, detach */
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-		if (!device_handler_match(scsi_dh, sdev))
-			scsi_dh_handler_detach(sdev, scsi_dh);
+		scsi_dh_handler_detach(sdev, scsi_dh);
 	}
 	put_device(&sdev->sdev_gendev);
 }



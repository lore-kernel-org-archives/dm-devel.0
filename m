From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: create sysfs file, dh_state for SCSI devices even if they
	are not in the inteernal lists
Date: Fri, 26 Jun 2009 19:31:28 -0700
Message-ID: <1246069888.14164.53.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: dm-devel <dm-devel@redhat.com>, Mario Mech <mech@meteo.uni-koeln.de>
List-Id: dm-devel.ids

Create the sysfs file, dh_state even if the new SCSI device is not
in the any of the device handler's internal lists.

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
@@ -304,18 +304,15 @@ static int scsi_dh_notifier(struct notif
 	sdev = to_scsi_device(dev);
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		err = device_create_file(dev, &scsi_dh_state_attr);
+		/* don't care about err */
 		devinfo = device_handler_match(NULL, sdev);
-		if (!devinfo)
-			goto out;
-
-		err = scsi_dh_handler_attach(sdev, devinfo);
-		if (!err)
-			err = device_create_file(dev, &scsi_dh_state_attr);
+		if (devinfo)
+			err = scsi_dh_handler_attach(sdev, devinfo);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		device_remove_file(dev, &scsi_dh_state_attr);
 		scsi_dh_handler_detach(sdev, NULL);
 	}
-out:
 	return err;
 }
 



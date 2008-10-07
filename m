From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [dm-devel] failover does not work with rdac device handler
Date: Mon, 06 Oct 2008 19:04:34 -0700
Message-ID: <1223345074.14830.601.camel@chandra-ubuntu>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>
	 ,<1223081419.14830.585.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BB949D3@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBCCF2@cosmail01.lsi.com>
	 <1223322817.14830.593.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBCD31@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBCE37@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BBBCE37@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

Hi,

Can you try the attached patch.

chandra
PS: I see a problem (not related to this patch) that the dh_state file
is not getting recreated, still working on it.

-------------

Keep a reference count of attaches, so that same number of detaches are allowed.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.27-rc8-git5.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
@@ -153,12 +153,26 @@ static int scsi_dh_handler_attach(struct
 	if (sdev->scsi_dh_data) {
 		if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
 			err = -EBUSY;
-	} else if (scsi_dh->attach)
+		else
+			kref_get(&sdev->scsi_dh_data.kref);
+	} else if (scsi_dh->attach) {
 		err = scsi_dh->attach(sdev);
+		if (!err)
+			kref_init(&sdev->scsi_dh_data.kref);
+	}
 
 	return err;
 }
 
+static void scsi_dh_release(struct *kref kref)
+{
+	struct scsi_dh_data *scsi_dh_data;
+	scsi_dh_data = container_of(kref, struct scsi_dh_data, kref);
+
+	if (scsi_dh_data->scsi_dh && scsi_dh_data->scsi_dh->detach)
+		scsi_dh_data->scsi_dh->detach(sdev);
+}
+
 /*
  * scsi_dh_handler_detach - Detach a device handler from a device
  * @sdev - SCSI device the device handler should be detached from
@@ -176,11 +190,7 @@ static void scsi_dh_handler_detach(struc
 	if (scsi_dh && scsi_dh != sdev->scsi_dh_data->scsi_dh)
 		return;
 
-	if (!scsi_dh)
-		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-
-	if (scsi_dh && scsi_dh->detach)
-		scsi_dh->detach(sdev);
+	kref_put(&sdev->scsi_dh_data.kref, scsi_dh_release);
 }
 
 /*
Index: linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.27-rc8-git5.orig/include/scsi/scsi_device.h
+++ linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
@@ -191,6 +191,7 @@ struct scsi_device_handler {
 
 struct scsi_dh_data {
 	struct scsi_device_handler *scsi_dh;
+	struct kref kref;
 	char buf[0];
 };
 



From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [RESEND] [PATCH 2/3] scsi_dh: Provide set_params interface in emc device handler
Date: Mon, 03 Aug 2009 12:42:39 -0700
Message-ID: <20090803194239.5738.74280.sendpatchset@chandra-ubuntu>
References: <20090803194226.5738.82973.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20090803194226.5738.82973.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com, Eddie.Williams@steeleye.com, Chandra Seetharaman <sekharan@us.ibm.com>
List-Id: dm-devel.ids

Handle the parameters provided by user thru multipath.

This handler expects only 2 parameters and their value can either be 0 or 1.

This code originates from the old dm-emc.c file. Appropriate changes have
been made to make it work in the new design.

Reported-by: Eddie Williams <Eddie.Williams@steeleye.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Tested-by: Eddie Williams <Eddie.Williams@steeleye.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |   59 ++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

Index: linux-2.6.31-rc3/drivers/scsi/device_handler/scsi_dh_emc.c
===================================================================
--- linux-2.6.31-rc3.orig/drivers/scsi/device_handler/scsi_dh_emc.c
+++ linux-2.6.31-rc3/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -561,6 +561,61 @@ done:
 
 	return result;
 }
+/*
+ * params - parameters in the following format
+ *      "no_of_params\0param1\0param2\0param3\0...\0"
+ *      for example, string for 2 parameters with value 10 and 21
+ *      is specified as "2\010\021\0".
+ */
+static int clariion_set_params(struct scsi_device *sdev, const char *params)
+{
+	struct clariion_dh_data *csdev = get_clariion_data(sdev);
+	unsigned int hr = 0, st = 0, argc;
+	const char *p = params;
+	int result = SCSI_DH_OK;
+
+	if ((sscanf(params, "%u", &argc) != 1) || (argc != 2))
+		return -EINVAL;
+
+	while (*p++)
+		;
+	if ((sscanf(p, "%u", &st) != 1) || (st > 1))
+		return -EINVAL;
+
+	while (*p++)
+		;
+	if ((sscanf(p, "%u", &hr) != 1) || (hr > 1))
+		return -EINVAL;
+
+	if (st)
+		csdev->flags |= CLARIION_SHORT_TRESPASS;
+	else
+		csdev->flags &= ~CLARIION_SHORT_TRESPASS;
+
+	if (hr)
+		csdev->flags |= CLARIION_HONOR_RESERVATIONS;
+	else
+		csdev->flags &= ~CLARIION_HONOR_RESERVATIONS;
+
+	/*
+	 * If this path is owned, we have to send a trespass command
+	 * with the new parameters. If not, simply return. Next trespass
+	 * command would use the parameters.
+	 */
+	if (csdev->lun_state != CLARIION_LUN_OWNED)
+		goto done;
+
+	csdev->lun_state = CLARIION_LUN_UNINITIALIZED;
+	result = send_trespass_cmd(sdev, csdev);
+	if (result != SCSI_DH_OK)
+		goto done;
+
+	/* Update status */
+	result = clariion_send_inquiry(sdev, csdev);
+
+done:
+	return result;
+}
 
 static const struct scsi_dh_devlist clariion_dev_list[] = {
 	{"DGC", "RAID"},
@@ -581,11 +636,9 @@ static struct scsi_device_handler clarii
 	.check_sense	= clariion_check_sense,
 	.activate	= clariion_activate,
 	.prep_fn	= clariion_prep_fn,
+	.set_params	= clariion_set_params,
 };
 
-/*
- * TODO: need some interface so we can set trespass values
- */
 static int clariion_bus_attach(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data;

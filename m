From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 06/10] scsi_dh: Do not allow arguments for hardware handlers
Date: Thu, 01 May 2008 14:50:17 -0700
Message-ID: <20080501215017.27759.37314.sendpatchset@chandra-ubuntu>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, andmike@us.ibm.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dwysocha@redhat.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>
List-Id: dm-devel.ids

Subject: [PATCH 06/10] scsi_dh: Do not allow arguments for hardware handlers

From: Chandra Seetharaman <sekharan@us.ibm.com>

The new implementation does not use the arguments provided with the
hardware handler. This patch makes the change visible to the user by
failing table load when arguments are provided with the hardware handler.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.25/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25/drivers/md/dm-mpath.c
@@ -653,11 +653,15 @@ static int parse_hw_handler(struct arg_s
 	struct dm_target *ti = m->ti;
 
 	static struct param _params[] = {
-		{0, 1024, "invalid number of hardware handler args"},
+		{0, 1, "invalid number of hardware handler args"},
 	};
 
-	if (read_param(_params, shift(as), &hw_argc, &ti->error))
+	if (read_param(_params, shift(as), &hw_argc, &ti->error)) {
+		if (hw_argc > 1)
+			ti->error = "no arguments accepted for hardware"
+					" handler";
 		return -EINVAL;
+	}
 
 	if (!hw_argc)
 		return 0;

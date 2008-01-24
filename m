From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Wed, 23 Jan 2008 16:32:03 -0800
Message-ID: <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

Subject: scsi_dh: Add support for SDEV_PASSIVE

From: Chandra Seetharaman <sekharan@us.ibm.com>

This patch adds a new device state SDEV_PASSIVE, to correspond to the
passive side access of an active/passive multipathed device.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

---
 drivers/scsi/scsi_lib.c    |   14 	13 +	1 -	0 !
 include/scsi/scsi_device.h |    2 	2 +	0 -	0 !
 2 files changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc8/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.24-rc8.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.24-rc8/drivers/scsi/scsi_lib.c
@@ -1310,6 +1310,14 @@ int scsi_prep_state_check(struct scsi_de
 			if (!(req->cmd_flags & REQ_PREEMPT))
 				ret = BLKPREP_DEFER;
 			break;
+		case SDEV_PASSIVE:
+			/*
+			 * If the device is passive, we refuse to
+			 * process any FS commands.
+			 */
+			if (req->cmd_type == REQ_TYPE_FS)
+				ret = BLKPREP_KILL;
+			break;
 		default:
 			/*
 			 * For any other not fully online state we only allow
@@ -2179,6 +2187,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_PASSIVE:
 			break;
 		default:
 			goto illegal;
@@ -2241,7 +2250,10 @@ scsi_device_set_state(struct scsi_device
 			goto illegal;
 		}
 		break;
-
+	case SDEV_PASSIVE:
+		if (oldstate != SDEV_RUNNING)
+			goto illegal;
+		break;
 	}
 	sdev->sdev_state = state;
 	return 0;
Index: linux-2.6.24-rc8/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.24-rc8.orig/include/scsi/scsi_device.h
+++ linux-2.6.24-rc8/include/scsi/scsi_device.h
@@ -44,6 +44,8 @@ enum scsi_device_state {
 	SDEV_BLOCK,		/* Device blocked by scsi lld.  No scsi 
 				 * commands from user or midlayer should be issued
 				 * to the scsi lld. */
+	SDEV_PASSIVE,		/* Device is the passive side of a
+				 * active/passive multipath storage */
 };
 
 enum scsi_device_event {

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------

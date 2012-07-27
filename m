From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi : Adding all the definitions of host bytes in
 hostbyte_table
Date: Fri, 27 Jul 2012 17:28:40 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B0BC9EDE3@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>
List-Id: dm-devel.ids

Submitted this patch earlier. But it still did not make it to kernel tree.
Resubmitting again(recreated on top of 3.5 kernel).
 
Adding all the definitions of host bytes in hostbyte_table.

Without this patch, scsi_show_result prints hostbyte as invalid
for statuses that are not defined in hostbyte_table(when scsi logging is enabled).

Look at scsi_print_result function for better understanding.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.5-rc7/drivers/scsi/constants.c.orig	2012-07-27 13:02:28.000000000 -0500
+++ linux-3.5-rc7/drivers/scsi/constants.c	2012-07-27 13:03:26.000000000 -0500
@@ -1422,7 +1422,8 @@ static const char * const hostbyte_table
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
-"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST" };
+"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
+"DID_NEXUS_FAILURE" };
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={



From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi : Adding all the definitions of host bytes in hostbyte_table
Date: Thu, 12 Jan 2012 23:10:02 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910F3C0A6@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Adding all the definitions of host bytes in hostbyte_table.

Without this patch, scsi_show_result prints hostbyte as invalid
for statuses that are not defined in hostbyte_table(when scsi logging is enabled).

Look at scsi_print_result function for better understanding.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.1-rc4/drivers/scsi/constants.c.orig	2012-01-12 15:21:28.000000000 -0600
+++ linux-3.1-rc4/drivers/scsi/constants.c	2012-01-12 15:25:07.000000000 -0600
@@ -1422,7 +1422,8 @@ static const char * const hostbyte_table
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
-"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST" };
+"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
+"DID_NEXUS_FAILURE" };
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={

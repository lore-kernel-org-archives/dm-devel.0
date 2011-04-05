From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] scsi_dh_rdac: Adding couple more vendor product ids
Date: Tue, 5 Apr 2011 14:35:25 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFAC8CFB@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4FF7DC637@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4FF7DC637@cosmail01.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds couple more Vendor/Product IDs for RDAC.. There are no functional changes.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.39-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-04-05 15:01:52.000000000 -0500
+++ linux-2.6.39-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-04-05 15:06:18.000000000 -0500
@@ -755,6 +755,7 @@ static const struct scsi_dh_devlist rdac
 	{"IBM", "3526"},
 	{"SGI", "TP9400"},
 	{"SGI", "TP9500"},
+	{"SGI", "TP9700"},
 	{"SGI", "IS"},
 	{"STK", "OPENstorage D280"},
 	{"SUN", "CSM200_R"},
@@ -774,6 +775,7 @@ static const struct scsi_dh_devlist rdac
 	{"SUN", "CSM100_R_FC"},
 	{"SUN", "STK6580_6780"},
 	{"SUN", "SUN_6180"},
+	{"SUN", "ArrayStorage"},
 	{NULL, NULL},
 };
 



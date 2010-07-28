From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] scsi_dh_rdac : Adding  MODULE VERSION for rdac device
 handler
Date: Wed, 28 Jul 2010 17:00:33 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC427@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
List-Id: dm-devel.ids

Adding MODULE_VERSION for scsi_dh_rdac. This will be helpful to differentiate between the previous(non async) versions and the current versions.

Version format aa.bb.ccdd.eeff
aa   - major version(01 for now)
bb   - minor version(for minor bugfixes)
ccdd - can be used to differentiate between distros
eeff - reserved for future

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2010-07-23 06:06:24.000000000 -0500
+++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-23 06:07:07.000000000 -0500
@@ -904,3 +904,4 @@ module_exit(rdac_exit);
 MODULE_DESCRIPTION("Multipath LSI/Engenio RDAC driver");
 MODULE_AUTHOR("Mike Christie, Chandra Seetharaman");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("01.00.0000.0000");




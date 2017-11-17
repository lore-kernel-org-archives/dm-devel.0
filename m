From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi_dh: add new rdac devices
Date: Fri, 17 Nov 2017 22:05:13 +0100
Message-ID: <20171117210513.9667-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Add IBM 3542 and 3552, arrays: FAStT200 and FAStT500.
Add full STK OPENstorage family, arrays: 9176, D173, D178, D210, D220, D240 and D280.
Add STK BladeCtlr family, arrays: B210, B220, B240 and B280.

These changes were done in multipath-tools time ago.

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_dh.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 2b785d09d5bd..b88b5dbbc444 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -56,10 +56,13 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
 	{"IBM", "1815",			"rdac", },
 	{"IBM", "1818",			"rdac", },
 	{"IBM", "3526",			"rdac", },
+	{"IBM", "3542",			"rdac", },
+	{"IBM", "3552",			"rdac", },
 	{"SGI", "TP9",			"rdac", },
 	{"SGI", "IS",			"rdac", },
-	{"STK", "OPENstorage D280",	"rdac", },
+	{"STK", "OPENstorage",		"rdac", },
 	{"STK", "FLEXLINE 380",		"rdac", },
+	{"STK", "BladeCtlr",		"rdac", },
 	{"SUN", "CSM",			"rdac", },
 	{"SUN", "LCSM100",		"rdac", },
 	{"SUN", "STK6580_6780",		"rdac", },
-- 
2.14.3

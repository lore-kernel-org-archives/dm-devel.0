From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: [PATCH] scsi_dh_rdac: Add support for Sun StorageTek ST2500, ST2510
 and ST2530
Date: Wed, 26 Aug 2009 14:16:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908261411370.13027@e-smith.charlieb.ott.istop.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


[Re-submit - ST2500 added.]

These storage arrays can use RDAC when configured with 'linux' as the 
initiator.

http://www.sun.com/storage/disk_systems/workgroup/2500/
http://www.sun.com/storage/disk_systems/workgroup/2510/
http://www.sun.com/storage/disk_systems/workgroup/2530/

Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>

--- linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-25 14:56:42.000000000 -0400
+++ linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c.sun	2009-08-26 14:11:53.000000000 -0400
@@ -628,6 +628,9 @@
  	{"SGI", "IS"},
  	{"STK", "OPENstorage D280"},
  	{"SUN", "CSM200_R"},
+	{"SUN", "LCSM100_I"},
+	{"SUN", "LCSM100_S"},
+	{"SUN", "LCSM100_E"},
  	{"SUN", "LCSM100_F"},
  	{"DELL", "MD3000"},
  	{"DELL", "MD3000i"},



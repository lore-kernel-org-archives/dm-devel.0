From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 09/14] multipath-tools: mark hardware-dependent
	features in multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:54 +0200
Message-ID: <1468000199-15566-10-git-send-email-xose.vazquez@gmail.com>
References: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Some features are hardware-dependent.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index e7df08c..83dcdda 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -212,26 +212,32 @@ are implemented:
 Return a constant priority of \fI1\fR.
 .TP
 .I emc
+(Hardware-dependent)
 Generate the path priority for DGC class arrays as CLARiiON CX/AX and
 EMC VNX families.
 .TP
 .I alua
+(Hardware-dependent)
 Generate the path priority based on the SCSI-3 ALUA settings. This prioritizer
 accepts the optional prio_arg
 .I exclusive_pref_bit
 .TP
 .I ontap
+(Hardware-dependent)
 Generate the path priority for NetApp ONTAP class and OEM arrays as IBM NSeries.
 .TP
 .I rdac
+(Hardware-dependent)
 Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I hp_sw
+(Hardware-dependent)
 Generate the path priority for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with
 Active/Standby mode exclusively.
 .TP
 .I hds
+(Hardware-dependent)
 Generate the path priority for Hitachi HDS Modular storage arrays.
 .TP
 .I random
@@ -307,14 +313,17 @@ Issue a
 command to the device.
 .TP
 .I emc_clariion
+(Hardware-dependent)
 Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
 for CLARiiON CX/AX and EMC VNX arrays families.
 .TP
 .I hp_sw
+(Hardware-dependent)
 Check the path state for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with
 Active/Standby mode exclusively.
 .TP
 .I rdac
+(Hardware-dependent)
 Check the path state for LSI/Engenio/NetApp RDAC class as NetApp E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
@@ -812,17 +821,21 @@ The following hardware handler are implemented:
 .RS
 .TP 12
 .I 1 emc
+(Hardware-dependent)
 Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families.
 .TP
 .I 1 rdac
+(Hardware-dependent)
 Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I 1 hp_sw
+(Hardware-dependent)
 Hardware handler for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with
 Active/Standby mode exclusively.
 .TP
 .I 1 alua
+(Hardware-dependent)
 Hardware handler for SCSI-3 ALUA compatible arrays.
 .RE
 .LP
-- 
2.7.4

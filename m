From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 07/14] multipath-tools: clarify RDAC class info
	at multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:52 +0200
Message-ID: <1468000199-15566-8-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <sean.stewart@netapp.com>
List-Id: dm-devel.ids

RDAC(Redundant Dual Active Controller) done by LSI/Engenio/NetApp
are NetApp E-Series/F-Series and OEM arrays from IBM DELL SGI STK
and SUN.

Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 33f7df8..a59e7a1 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -224,7 +224,8 @@ accepts the optional prio_arg
 Generate the path priority for NetApp ONTAP class and OEM arrays as IBM NSeries.
 .TP
 .I rdac
-Generate the path priority for LSI/Engenio/NetApp E-Series RDAC controller.
+Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp E/EF
+Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I hp_sw
 Generate the path priority for Compaq/HP controller in
@@ -313,7 +314,8 @@ for CLARiiON CX/AX and EMC VNX arrays families.
 Check the path state for HP storage arrays with Active/Standby firmware.
 .TP
 .I rdac
-Check the path state for LSI/Engenio/NetApp E-Series RDAC storage controller.
+Check the path state for LSI/Engenio/NetApp RDAC class as NetApp E/EF
+Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I directio
 (Deprecated) Read the first sector with direct I/O. This checker is being
@@ -812,7 +814,8 @@ The following hardware handler are implemented:
 Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families.
 .TP
 .I 1 rdac
-Hardware handler for LSI/Engenio/NetApp E-Series RDAC storage controller.
+Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp E/EF
+Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I 1 hp_sw
 Hardware handler for Compaq/HP storage arrays in active/standby
-- 
2.7.4

From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 08/14] multipath-tools: clarify HP/COMPAQ/DEC
	Active/Standby arrays info at multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:53 +0200
Message-ID: <1468000199-15566-9-git-send-email-xose.vazquez@gmail.com>
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

Options only valid for HSG80 and MSA/HSV 1x0 arrays with Active/Standby mode
exclusively, their firmware can not be upgraded to support ALUA.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index a59e7a1..e7df08c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -228,8 +228,8 @@ Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I hp_sw
-Generate the path priority for Compaq/HP controller in
-active/standby mode.
+Generate the path priority for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with
+Active/Standby mode exclusively.
 .TP
 .I hds
 Generate the path priority for Hitachi HDS Modular storage arrays.
@@ -311,7 +311,8 @@ Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
 for CLARiiON CX/AX and EMC VNX arrays families.
 .TP
 .I hp_sw
-Check the path state for HP storage arrays with Active/Standby firmware.
+Check the path state for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with
+Active/Standby mode exclusively.
 .TP
 .I rdac
 Check the path state for LSI/Engenio/NetApp RDAC class as NetApp E/EF
@@ -818,8 +819,8 @@ Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I 1 hp_sw
-Hardware handler for Compaq/HP storage arrays in active/standby
-mode.
+Hardware handler for HP/COMPAQ/DEC HSG80 and MSA/HSV arrays with
+Active/Standby mode exclusively.
 .TP
 .I 1 alua
 Hardware handler for SCSI-3 ALUA compatible arrays.
-- 
2.7.4

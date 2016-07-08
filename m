From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 05/14] multipath-tools: clarify DGC/EMC arrays
	info at multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:50 +0200
Message-ID: <1468000199-15566-6-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

DGC(Data General Corporation) arrays are exclusively
CLARiiON CX/AX and EMC VNX families.

Cc: Edward Goggin <egoggin@emc.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 37a219c..5e70315 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -212,7 +212,8 @@ are implemented:
 Return a constant priority of \fI1\fR.
 .TP
 .I emc
-Generate the path priority for EMC arrays.
+Generate the path priority for DGC class arrays as CLARiiON CX/AX and
+EMC VNX families.
 .TP
 .I alua
 Generate the path priority based on the SCSI-3 ALUA settings. This prioritizer
@@ -305,8 +306,8 @@ Issue a
 command to the device.
 .TP
 .I emc_clariion
-Query the EMC Clariion specific EVPD page 0xC0 to determine the path
-state.
+Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
+for CLARiiON CX/AX and EMC VNX arrays families.
 .TP
 .I hp_sw
 Check the path state for HP storage arrays with Active/Standby firmware.
@@ -808,7 +809,7 @@ The following hardware handler are implemented:
 .RS
 .TP 12
 .I 1 emc
-Hardware handler for EMC storage arrays.
+Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families.
 .TP
 .I 1 rdac
 Hardware handler for LSI/Engenio/NetApp E-Series RDAC storage controller.
-- 
2.7.4

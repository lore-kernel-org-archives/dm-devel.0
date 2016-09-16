From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add Dell EMC Unity documentation
Date: Sat, 17 Sep 2016 01:11:07 +0200
Message-ID: <20160916231107.13762-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

It's detected as DGC/VRAID

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c     | 2 +-
 multipath/multipath.conf.5 | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b8b5bb7..8b2eec7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -159,7 +159,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 6,
 	},
 	{
-		/* DGC CLARiiON CX/AX and EMC VNX */
+		/* DGC CLARiiON CX/AX / EMC VNX and Unity */
 		.vendor        = "^DGC",
 		.product       = "^(RAID|DISK|VRAID)",
 		.bl_product    = "LUNZ",
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 8c0b47a..b377885 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -245,7 +245,7 @@ generate the path priority. This prioritizer accepts the optional prio_arg
 .I emc
 (Hardware-dependent)
 Generate the path priority for DGC class arrays as CLARiiON CX/AX and
-EMC VNX families.
+EMC VNX and Unity families.
 .TP
 .I alua
 (Hardware-dependent)
@@ -382,7 +382,7 @@ Issue a \fITEST UNIT READY\fR command to the device.
 .I emc_clariion
 (Hardware-dependent)
 Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
-for CLARiiON CX/AX and EMC VNX arrays families.
+for CLARiiON CX/AX and EMC VNX and Unity arrays families.
 .TP
 .I hp_sw
 (Hardware-dependent)
@@ -1006,7 +1006,8 @@ The following hardware handler are implemented:
 .TP 12
 .I 1 emc
 (Hardware-dependent)
-Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families.
+Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX and Unity
+families.
 .TP
 .I 1 rdac
 (Hardware-dependent)
-- 
2.10.0

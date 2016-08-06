From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 6/7] multipath-tools: identify arrays at
	multipath.conf.5
Date: Sun,  7 Aug 2016 00:40:07 +0200
Message-ID: <1470523208-14067-6-git-send-email-xose.vazquez@gmail.com>
References: <1470523208-14067-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470523208-14067-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 4567103..fc620be 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -251,8 +251,8 @@ Generate the path priority for NetApp ONTAP class and OEM arrays as IBM NSeries.
 .TP
 .I rdac
 (Hardware-dependent)
-Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp E/EF
-Series, and OEM arrays from IBM DELL SGI STK and SUN.
+Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp SANtricity
+E/EF Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I hp_sw
 (Hardware-dependent)
@@ -261,7 +261,7 @@ Active/Standby mode exclusively.
 .TP
 .I hds
 (Hardware-dependent)
-Generate the path priority for Hitachi HDS Modular storage arrays.
+Generate the path priority for Hitachi AMS 2000 and HUS 100 families of arrays.
 .TP
 .I random
 Generate a random priority between 1 and 10.
@@ -374,7 +374,7 @@ Active/Standby mode exclusively.
 .TP
 .I rdac
 (Hardware-dependent)
-Check the path state for LSI/Engenio/NetApp RDAC class as NetApp E/EF
+Check the path state for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I directio
@@ -978,7 +978,7 @@ Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families.
 .TP
 .I 1 rdac
 (Hardware-dependent)
-Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp E/EF
+Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
 Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I 1 hp_sw
-- 
2.7.4

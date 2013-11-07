From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm Kconfig: fix menu indentation
Date: Thu, 7 Nov 2013 12:05:54 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311071204230.10583@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The option DM_LOG_USERSPACE is sub-option of DM_MIRROR, so it should be
placed right after DM_MIRROR.

If we place DM_LOG_USERSPACE after DM_MIRROR, the config menu is correctly
indented:
<M>   Device mapper support
[ ]     Device mapper debugging support
<M>     Crypt target support
<M>     Snapshot target
<M>     Thin provisioning target
[ ]       Keep stack trace of thin provisioning block lock holders
<M>     Cache target (EXPERIMENTAL)
<M>       MQ Cache Policy (EXPERIMENTAL)
<M>       Cleaner Cache Policy (EXPERIMENTAL)
<M>     Mirror target
< >       Mirror userspace logging
<M>     RAID 1/4/5/6/10 target
<M>     Zero target
<M>     Multipath target
<M>       I/O Path Selector based on the number of in-flight I/Os
<M>       I/O Path Selector based on the service time
<M>     I/O delaying target
[*]     DM uevents
<M>     Flakey target
<M>     Verity target support
<M>     Switch target support (EXPERIMENTAL)

Previously, the menu was indented incorrectly:
<M>   Device mapper support
[ ]     Device mapper debugging support
<M>     Crypt target support
<M>     Snapshot target
<M>     Thin provisioning target
[ ]       Keep stack trace of thin provisioning block lock holders
<M>     Cache target (EXPERIMENTAL)
<M>       MQ Cache Policy (EXPERIMENTAL)
<M>       Cleaner Cache Policy (EXPERIMENTAL)
<M>     Mirror target
<M>     RAID 1/4/5/6/10 target
< >   Mirror userspace logging
<M>   Zero target
<M>   Multipath target
<M>     I/O Path Selector based on the number of in-flight I/Os
<M>     I/O Path Selector based on the service time
<M>   I/O delaying target
[*]   DM uevents
<M>   Flakey target
<M>   Verity target support
<M>   Switch target support (EXPERIMENTAL)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/Kconfig |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6-test/drivers/md/Kconfig
===================================================================
--- linux-2.6-test.orig/drivers/md/Kconfig	2013-11-07 17:57:38.000000000 +0100
+++ linux-2.6-test/drivers/md/Kconfig	2013-11-07 17:57:53.000000000 +0100
@@ -297,6 +297,17 @@ config DM_MIRROR
          Allow volume managers to mirror logical volumes, also
          needed for live data migration tools such as 'pvmove'.
 
+config DM_LOG_USERSPACE
+	tristate "Mirror userspace logging"
+	depends on DM_MIRROR && NET
+	select CONNECTOR
+	---help---
+	  The userspace logging module provides a mechanism for
+	  relaying the dm-dirty-log API to userspace.  Log designs
+	  which are more suited to userspace implementation (e.g.
+	  shared storage logs) or experimental logs can be implemented
+	  by leveraging this framework.
+
 config DM_RAID
        tristate "RAID 1/4/5/6/10 target"
        depends on BLK_DEV_DM
@@ -323,17 +334,6 @@ config DM_RAID
 	 RAID-5, RAID-6 distributes the syndromes across the drives
 	 in one of the available parity distribution methods.
 
-config DM_LOG_USERSPACE
-	tristate "Mirror userspace logging"
-	depends on DM_MIRROR && NET
-	select CONNECTOR
-	---help---
-	  The userspace logging module provides a mechanism for
-	  relaying the dm-dirty-log API to userspace.  Log designs
-	  which are more suited to userspace implementation (e.g.
-	  shared storage logs) or experimental logs can be implemented
-	  by leveraging this framework.
-
 config DM_ZERO
 	tristate "Zero target"
 	depends on BLK_DEV_DM

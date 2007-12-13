From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 02/06] dm mpath: hp requires scsi
Date: Thu, 13 Dec 2007 14:42:36 +0000
Message-ID: <20071213144236.GU24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Paul Mundt <lethal@linux-sh.org>

With CONFIG_SCSI=n __scsi_print_sense() is never linked in.

drivers/built-in.o: In function `hp_sw_end_io':
dm-mpath-hp-sw.c:(.text+0x914f8): undefined reference to `__scsi_print_sense'

Caught with a randconfig on current git.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---

 drivers/md/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc5/drivers/md/Kconfig
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/Kconfig	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/Kconfig	2007-12-12 15:43:10.000000000 +0000
@@ -269,7 +269,7 @@ config DM_MULTIPATH_RDAC
 
 config DM_MULTIPATH_HP
         tristate "HP MSA multipath support (EXPERIMENTAL)"
-        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 

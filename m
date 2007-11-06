From: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] md: dm-mpath-hp-sw depends on scsi
Date: Tue, 6 Nov 2007 16:36:20 +0900
Message-ID: <20071106073620.GA5258@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755273AbXKFHgl@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

With CONFIG_SCSI=n __scsi_print_sense() is never linked in.

drivers/built-in.o: In function `hp_sw_end_io':
dm-mpath-hp-sw.c:(.text+0x914f8): undefined reference to `__scsi_print_sense'

Caught with a randconfig on current git.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/md/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 9b6fbf0..3fa7c77 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -269,7 +269,7 @@ config DM_MULTIPATH_RDAC
 
 config DM_MULTIPATH_HP
         tristate "HP MSA multipath support (EXPERIMENTAL)"
-        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 

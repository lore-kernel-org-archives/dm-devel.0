From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] dm: fix DAX dependency
Date: Wed,  4 Apr 2018 11:54:15 +0200
Message-ID: <20180404095427.2537184-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Building device mapper with CONFIG_DAX=m now results in a link error:

drivers/md/dm.o: In function `dm_put_table_device':
dm.c:(.text+0x33c): undefined reference to `put_dax'
drivers/md/dm.o: In function `cleanup_mapped_device':
dm.c:(.text+0x1054): undefined reference to `kill_dax'
dm.c:(.text+0x105c): undefined reference to `put_dax'
drivers/md/dm.o: In function `dm_get_table_device':
dm.c:(.text+0x2744): undefined reference to `dax_get_by_host'
drivers/md/dm-table.o: In function `device_dax_write_cache_enabled':
dm-table.c:(.text+0x1030): undefined reference to `dax_write_cache_enabled'
drivers/md/dm-table.o: In function `dm_table_set_restrictions':
dm-table.c:(.text+0x29b8): undefined reference to `dax_write_cache'

This adds a dependency that prevents the invalid configuration, allowing
a built-in device mapper only if DAX is either built-in as well, or
completely disabled.

Fixes: 4de1c562f7e9 ("dax, dm: allow device-mapper to operate without dax support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
The regression only showed up in linux-next at the start of the merge
window. Any idea what happened?
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 49287135b86c..5e5a47c5ff82 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -200,6 +200,7 @@ config BLK_DEV_DM_BUILTIN
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
+	depends on DAX || DAX=n
 	select BLK_DEV_DM_BUILTIN
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
-- 
2.9.0

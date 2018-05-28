From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] dm: writecache: add DAX dependency
Date: Mon, 28 May 2018 17:38:10 +0200
Message-ID: <20180528153834.2268557-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The new dm-writecache driver inconditionally uses the dax
subsystem, leading to link errors in some configurations:

drivers/md/dm-writecache.o: In function `writecache_ctr':
dm-writecache.c:(.text+0x1fdc): undefined reference to `dax_read_lock'
dm-writecache.c:(.text+0x2004): undefined reference to `dax_direct_access'
dm-writecache.c:(.text+0x21cc): undefined reference to `dax_read_unlock'

It seems wrong to require DAX in order to build the writecache
driver, but that at least avoids randconfig build errors.

Fixes: bb15b431d650 ("dm: add writecache target")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 852c7ebe2902..f8ecf2da1edf 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -338,6 +338,7 @@ config DM_CACHE_SMQ
 config DM_WRITECACHE
 	tristate "Writecache target"
 	depends on BLK_DEV_DM
+	depends on DAX
 	---help---
 	   The writecache target caches writes on persistent memory or SSD.
 	   It is intended for databases or other programs that need extremely
-- 
2.9.0

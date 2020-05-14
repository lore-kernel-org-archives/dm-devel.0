From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] device-mapper: use dynamic debug instead of
	compile-time config option
Date: Thu, 14 May 2020 08:09:28 +0200
Message-ID: <20200514060929.85469-2-hare@suse.de>
References: <20200514060929.85469-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200514060929.85469-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Switch to use dynamic debug to avoid having recompile the kernel
just to enable debugging messages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/device-mapper.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index af48d9da3916..4694e1bb4196 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -557,12 +557,11 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 #define DMINFO(fmt, ...) pr_info(DM_FMT(fmt), ##__VA_ARGS__)
 #define DMINFO_LIMIT(fmt, ...) pr_info_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
 
+#define DMDEBUG_LIMIT(fmt, ...) pr_debug_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
 #ifdef CONFIG_DM_DEBUG
 #define DMDEBUG(fmt, ...) printk(KERN_DEBUG DM_FMT(fmt), ##__VA_ARGS__)
-#define DMDEBUG_LIMIT(fmt, ...) pr_debug_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
 #else
-#define DMDEBUG(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
-#define DMDEBUG_LIMIT(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
+#define DMDEBUG(fmt, ...) pr_debug(DM_FMT(fmt), ##__VA_ARGS__)
 #endif
 
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
-- 
2.16.4

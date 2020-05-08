From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] device-mapper: use dynamic debug instead of
	config option
Date: Fri,  8 May 2020 11:19:30 +0200
Message-ID: <20200508091930.40910-1-hare@suse.de>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Debugging device-mapper via the DMDEBUG() call is currently depending
on the CONFIG_DM_DEBUG option and needs a recompilation to activate.
This patch replaces the config option with dynamic debugging to
enable debugging without recompilation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/device-mapper.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index af48d9da3916..6df78be3637e 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -557,13 +557,8 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
 #define DMINFO(fmt, ...) pr_info(DM_FMT(fmt), ##__VA_ARGS__)
 #define DMINFO_LIMIT(fmt, ...) pr_info_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
 
-#ifdef CONFIG_DM_DEBUG
-#define DMDEBUG(fmt, ...) printk(KERN_DEBUG DM_FMT(fmt), ##__VA_ARGS__)
+#define DMDEBUG(fmt, ...) pr_debug(DM_FMT(fmt), ##__VA_ARGS__)
 #define DMDEBUG_LIMIT(fmt, ...) pr_debug_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
-#else
-#define DMDEBUG(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
-#define DMDEBUG_LIMIT(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
-#endif
 
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
 			  0 : scnprintf(result + sz, maxlen - sz, x))
-- 
2.25.0

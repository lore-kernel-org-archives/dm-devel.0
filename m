From: Asaf Vertz <asaf.vertz@tandemg.com>
Subject: [PATCH] dm bufio: fix time comparison
Date: Tue, 6 Jan 2015 15:44:15 +0200
Message-ID: <20150106134415.GA15873@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

To be future-proof and for better readability the time comparison
modified to use time_after_eq() instead of plain, error-prone math.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/md/dm-bufio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index c33b497..86dbbc7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -11,6 +11,7 @@
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 #include <linux/vmalloc.h>
 #include <linux/shrinker.h>
 #include <linux/module.h>
@@ -1739,7 +1740,7 @@ static unsigned get_max_age_hz(void)
 
 static bool older_than(struct dm_buffer *b, unsigned long age_hz)
 {
-	return (jiffies - b->last_accessed) >= age_hz;
+	return time_after_eq(jiffies, b->last_accessed + age_hz);
 }
 
 static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
-- 
1.7.0.4

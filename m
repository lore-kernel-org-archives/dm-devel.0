From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/6] multipathd: minor dmevents polling code
	cleanups
Date: Thu, 29 Mar 2018 22:37:00 -0500
Message-ID: <1522381023-15262-4-git-send-email-bmarzins@redhat.com>
References: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Change strncpy to strlcpy and lock_cleanup_pop to pthread_cleanup_pop,
based on suggestions by Martin Wilck

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/dmevents.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 0b0d0ce..e98a974 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -24,6 +24,7 @@
 #include "debug.h"
 #include "main.h"
 #include "dmevents.h"
+#include "util.h"
 
 #ifndef DM_DEV_ARM_POLL
 #define DM_DEV_ARM_POLL _IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD + 1, struct dm_ioctl)
@@ -214,8 +215,7 @@ int watch_dmevents(char *name)
 		return -1;
 	}
 
-	strncpy(dev_evt->name, name, WWID_SIZE);
-	dev_evt->name[WWID_SIZE - 1] = 0;
+	strlcpy(dev_evt->name, name, WWID_SIZE);
 	dev_evt->evt_nr = event_nr;
 	dev_evt->action = EVENT_NOTHING;
 
@@ -350,7 +350,7 @@ static int dmevent_loop (void)
 			remove_map_by_alias(curr_dev.name, waiter->vecs, 1);
 		else
 			r = update_multipath(waiter->vecs, curr_dev.name, 1);
-		lock_cleanup_pop(&waiter->vecs->lock);
+		pthread_cleanup_pop(1);
 
 		if (r) {
 			condlog(2, "%s: stopped watching dmevents",
-- 
2.7.4

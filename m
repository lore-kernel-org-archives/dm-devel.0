From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 4/7] libmpathpersist: updatepaths: deal with
	missing pp->udev
Date: Sat, 18 May 2019 00:57:00 +0200
Message-ID: <20190517225703.16295-5-mwilck@suse.com>
References: <20190517225703.16295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190517225703.16295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dbond@redhat.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We will change the data structure initialization to a lazy
approach, where pp->udev isn't necessarily initialized
when get_mpvec() is called. Deal with it.
---
 libmpathpersist/mpath_persist.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 6505774f..fee1db72 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -16,6 +16,7 @@
 #include "config.h"
 #include "switchgroup.h"
 #include "discovery.h"
+#include "configure.h"
 #include "dmparser.h"
 #include <ctype.h>
 #include "propsel.h"
@@ -96,6 +97,17 @@ updatepaths (struct multipath * mpp)
 				continue;
 			}
 			pp->mpp = mpp;
+			if (pp->udev == NULL) {
+				pp->udev = get_udev_device(pp->dev_t, DEV_DEVT);
+				if (pp->udev == NULL) {
+					pp->state = PATH_DOWN;
+					continue;
+				}
+				conf = get_multipath_config();
+				pathinfo(pp, conf, DI_SYSFS|DI_CHECKER);
+				put_multipath_config(conf);
+				continue;
+			}
 			if (pp->state == PATH_UNCHECKED ||
 					pp->state == PATH_WILD) {
 				conf = get_multipath_config();
-- 
2.21.0

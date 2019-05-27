From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/9] libmpathpersist: updatepaths: deal with
	missing pp->udev
Date: Mon, 27 May 2019 14:59:37 +0200
Message-ID: <20190527125942.8366-5-mwilck@suse.com>
References: <20190527125942.8366-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190527125942.8366-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We will change the data structure initialization to a lazy
approach, where pp->udev isn't necessarily initialized
when get_mpvec() is called. Deal with it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
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

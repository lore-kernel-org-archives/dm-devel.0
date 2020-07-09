From: mwilck@suse.com
Subject: [PATCH 29/35] libmultipath: snprint_devices(): print
	hidden/foreign status
Date: Thu,  9 Jul 2020 12:16:14 +0200
Message-ID: <20200709101620.6786-30-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The "hidden" and "claimed by foreign" properties take precedence
over blacklisting/whitelisting in pathinfo(). We should take
this into account when printing the device list.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index fb94f86..ea95d69 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -30,6 +30,7 @@
 #include "debug.h"
 #include "discovery.h"
 #include "util.h"
+#include "foreign.h"
 
 #define MAX(x,y) (((x) > (y)) ? (x) : (y))
 #define MIN(x,y) (((x) > (y)) ? (y) : (x))
@@ -2061,13 +2062,23 @@ int snprint_devices(struct config *conf, char *buff, size_t len,
 
 		pp = find_path_by_dev(vecs->pathvec, devname);
 		if (!pp) {
-			r = filter_devnode(conf->blist_devnode,
-					   conf->elist_devnode,
-					   devname);
-			if (r > 0)
-				status = "devnode blacklisted, unmonitored";
-			else
-				status = "devnode whitelisted, unmonitored";
+			const char *hidden;
+
+			hidden = udev_device_get_sysattr_value(u_dev,
+							       "hidden");
+			if (hidden && !strcmp(hidden, "1"))
+				status = "hidden, unmonitored";
+			else if (is_claimed_by_foreign(u_dev))
+				status = "foreign, monitored";
+			else {
+				r = filter_devnode(conf->blist_devnode,
+						   conf->elist_devnode,
+						   devname);
+				if (r > 0)
+					status = "devnode blacklisted, unmonitored";
+				else
+					status = "devnode whitelisted, unmonitored";
+			}
 		} else
 			status = " devnode whitelisted, monitored";
 
-- 
2.26.2

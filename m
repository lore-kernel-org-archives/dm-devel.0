From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 18/23] libmultipath: pathinfo: call into
	foreign library
Date: Tue,  6 Mar 2018 00:15:02 +0100
Message-ID: <20180305231507.10386-19-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This actually enables the use of foreign paths.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 645224c1029c..45a4d8378893 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -31,6 +31,7 @@
 #include "prio.h"
 #include "defaults.h"
 #include "prioritizers/alua_rtpg.h"
+#include "foreign.h"
 
 int
 alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
@@ -1909,7 +1910,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	 * limited by DI_BLACKLIST and occurs before this debug
 	 * message with the mask value.
 	 */
-	if (pp->udev && filter_property(conf, pp->udev) > 0)
+	if (pp->udev && (is_claimed_by_foreign(pp->udev) ||
+			 filter_property(conf, pp->udev) > 0))
 		return PATHINFO_SKIPPED;
 
 	if (filter_devnode(conf->blist_devnode,
-- 
2.16.1

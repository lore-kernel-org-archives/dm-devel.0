From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 04/24] libmultipath: decrease verbosity of
	pathinfo messages
Date: Mon, 10 Dec 2018 10:49:39 +0100
Message-ID: <20181210094959.11338-5-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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

Reduce the verbosity of pointless messages from pathinfo(), in
particular those that are printed on every checker invocation.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f9a59011..3ad33492 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1382,7 +1382,7 @@ common_sysfs_pathinfo (struct path * pp)
 	devt = udev_device_get_devnum(pp->udev);
 	snprintf(pp->dev_t, BLK_DEV_SIZE, "%d:%d", major(devt), minor(devt));
 
-	condlog(3, "%s: dev_t = %s", pp->dev, pp->dev_t);
+	condlog(4, "%s: dev_t = %s", pp->dev, pp->dev_t);
 
 	if (sysfs_get_size(pp, &pp->size))
 		return PATHINFO_FAILED;
@@ -1599,6 +1599,7 @@ get_prio (struct path * pp)
 	struct prio * p;
 	struct config *conf;
 	int checker_timeout;
+	int old_prio;
 
 	if (!pp)
 		return 0;
@@ -1619,13 +1620,14 @@ get_prio (struct path * pp)
 	conf = get_multipath_config();
 	checker_timeout = conf->checker_timeout;
 	put_multipath_config(conf);
+	old_prio = pp->priority;
 	pp->priority = prio_getprio(p, pp, checker_timeout);
 	if (pp->priority < 0) {
 		condlog(3, "%s: %s prio error", pp->dev, prio_name(p));
 		pp->priority = PRIO_UNDEF;
 		return 1;
 	}
-	condlog(3, "%s: %s prio = %u",
+	condlog((old_prio == pp->priority ? 4 : 3), "%s: %s prio = %u",
 		pp->dev, prio_name(p), pp->priority);
 	return 0;
 }
@@ -1863,7 +1865,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			udev_device_get_sysattr_value(pp->udev, "hidden");
 
 		if (hidden && !strcmp(hidden, "1")) {
-			condlog(3, "%s: hidden", pp->dev);
+			condlog(4, "%s: hidden", pp->dev);
 			return PATHINFO_SKIPPED;
 		}
 		if (is_claimed_by_foreign(pp->udev) ||
@@ -1876,7 +1878,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			   pp->dev) > 0)
 		return PATHINFO_SKIPPED;
 
-	condlog(3, "%s: mask = 0x%x", pp->dev, mask);
+	condlog(4, "%s: mask = 0x%x", pp->dev, mask);
 
 	/*
 	 * Sanity check: we need the device number to
-- 
2.19.2

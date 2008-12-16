From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Memory leak in ev_add_map.
Date: Tue, 16 Dec 2008 10:54:56 -0500
Message-ID: <1229442897-3765-5-git-send-email-konrad@virtualiron.com>
References: <1229442897-3765-1-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-2-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-3-git-send-email-konrad@virtualiron.com>
	<1229442897-3765-4-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1229442897-3765-4-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

 When using dm_mapname it makes a strdup of the returned value. We use
 the dm_mapname return value (alias) in our function but neglected
 to free it at the exit points.

---
 multipathd/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 30dba5b..e8a2660 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -243,6 +243,7 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 
 	if (map_present && dm_type(alias, TGT_MPATH) <= 0) {
 		condlog(4, "%s: not a multipath map", alias);
+		FREE(alias);
 		return 0;
 	}
 
@@ -256,6 +257,7 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 		 */
 		condlog(0, "%s: devmap already registered",
 			dev->kernel);
+		FREE(alias);
 		return 0;
 	}
 
@@ -280,6 +282,7 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 		condlog(0, "%s: uev_add_map %s failed", alias, dev->kernel);
 
 	FREE(refwwid);
+	FREE(alias);
 	return r;
 }
 
-- 
1.5.4.1

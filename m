From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmultipath: fix skip_kpartx support for
	removing maps
Date: Thu, 13 Apr 2017 15:05:48 +0200
Message-ID: <20170413130548.20420-1-mwilck@suse.com>
References: <20170405224402.GI19236@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405224402.GI19236@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Commit 79a05a4e inadvertently removed the code necessary
to support multipath maps without partitions, as introduced
in b73a34ea "libmultipath: add skip_kpartx option". Revert
this part of the commit, so that skip_kpartx works again.

Fixes: 79a05a4e libmultipath: move suspend logic to _dm_flush_map
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 026418f8..5fb9d9ac 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -761,6 +761,12 @@ out:
 }
 
 static int
+has_partmap(const char *name, void *data)
+{
+	return 1;
+}
+
+static int
 partmap_in_use(const char *name, void *data)
 {
 	int part_count, *ret_count = (int *)data;
@@ -785,12 +791,18 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 {
 	int r;
 	int queue_if_no_path = 0;
+	int udev_flags = 0;
 	unsigned long long mapsize;
 	char params[PARAMS_SIZE] = {0};
 
 	if (!dm_is_mpath(mapname))
 		return 0; /* nothing to do */
 
+	/* if the device currently has no partitions, do not
+	   run kpartx on it if you fail to delete it */
+	if (do_foreach_partmaps(mapname, has_partmap, NULL) == 0)
+		udev_flags |= MPATH_UDEV_NO_KPARTX_FLAG;
+
 	/* If you aren't doing a deferred remove, make sure that no
 	 * devices are in use */
 	if (!do_deferred(deferred_remove) && partmap_in_use(mapname, NULL))
@@ -834,7 +846,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 				mapname);
 			if (need_suspend && queue_if_no_path != -1) {
 				dm_simplecmd_noflush(DM_DEVICE_RESUME,
-						     mapname, 0);
+						     mapname, udev_flags);
 			}
 		}
 		if (retries)
-- 
2.12.2

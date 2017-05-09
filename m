From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/6] libmultipath: fix suspended devs from failed
	reloads
Date: Tue,  9 May 2017 11:57:03 -0500
Message-ID: <1494349025-6561-5-git-send-email-bmarzins@redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

When multipath reloads a device, it can either fail while loading the
new table or while resuming the device. If it fails while resuming the
device, the device can get stuck in the suspended state.  To fix this,
multipath needs to resume the device again so that it can continue using
the old table.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 19 ++++++++++++++++++-
 libmultipath/devmapper.h |  1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2c4a13a..69b634b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -396,7 +396,13 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	if (r)
 		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
 				 1, udev_flags, 0);
-	return r;
+	if (r)
+		return r;
+
+	if (dm_is_suspended(mpp->alias))
+		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush, 1,
+			     udev_flags, 0);
+	return 0;
 }
 
 static int
@@ -1030,6 +1036,17 @@ dm_geteventnr (char *name)
 	return info.event_nr;
 }
 
+int
+dm_is_suspended(const char *name)
+{
+	struct dm_info info;
+
+	if (do_get_info(name, &info) != 0)
+		return -1;
+
+	return info.suspended;
+}
+
 char *
 dm_mapname(int major, int minor)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 5b66865..fa739bc 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -52,6 +52,7 @@ int dm_enablegroup(char * mapname, int index);
 int dm_disablegroup(char * mapname, int index);
 int dm_get_maps (vector mp);
 int dm_geteventnr (char *name);
+int dm_is_suspended(const char *name);
 int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
 int dm_remove_partmaps (const char * mapname, int need_sync,
-- 
1.8.3.1

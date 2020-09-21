From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH v2] libmultipath: check udev_device_get_* return
 value to avoid segfault
Date: Mon, 21 Sep 2020 12:00:39 +0800
Message-ID: <be54400a-5da9-8444-c473-562d675b10f3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

The udev_device_get_* function may return NULL, and it will be
deregerenced in str* and sscanf func. We check the return value
to avoid segfault. Fix all.

Signed-off-by:Lixiaokeng<lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/configure.c    |  4 +++-
 libmultipath/discovery.c    |  9 +++++++--
 libmultipath/foreign/nvme.c | 10 +++++++---
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 213dbe48..83693eeb 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -531,6 +531,7 @@ static void trigger_partitions_udev_change(struct udev_device *dev,
 {
 	struct udev_enumerate *part_enum;
 	struct udev_list_entry *item;
+	const char *devtype;

 	part_enum = udev_enumerate_new(udev);
 	if (!part_enum)
@@ -551,7 +552,8 @@ static void trigger_partitions_udev_change(struct udev_device *dev,
 		if (!part)
 			continue;

-		if (!strcmp("partition", udev_device_get_devtype(part))) {
+		devtype = udev_device_get_devtype(part);
+		if (devtype && !strcmp("partition", devtype)) {
 			condlog(4, "%s: triggering %s event for %s", __func__,
 				action, syspath);
 			sysfs_attr_set_value(part, "uevent", action, len);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3f1b1d71..2f301ac4 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -356,7 +356,7 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 		tgtdev = udev_device_get_parent(parent);
 		while (tgtdev) {
 			tgtname = udev_device_get_sysname(tgtdev);
-			if (sscanf(tgtname, "end_device-%d:%d",
+			if (tgtname && sscanf(tgtname, "end_device-%d:%d",
 				   &host, &tgtid) == 2)
 				break;
 			tgtdev = udev_device_get_parent(tgtdev);
@@ -389,7 +389,7 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 	/* Check for FibreChannel */
 	tgtdev = udev_device_get_parent(parent);
 	value = udev_device_get_sysname(tgtdev);
-	if (sscanf(value, "rport-%d:%d-%d",
+	if (value && sscanf(value, "rport-%d:%d-%d",
 		   &host, &channel, &tgtid) == 3) {
 		tgtdev = udev_device_new_from_subsystem_sysname(udev,
 				"fc_remote_ports", value);
@@ -519,6 +519,9 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
 		 */
 		value = udev_device_get_sysname(parent);

+		if (!value)
+			return 1;
+
 		strncpy(pci_name, value, SLOT_NAME_SIZE);
 		udev_device_unref(hostdev);
 		return 0;
@@ -1468,6 +1471,8 @@ ccw_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 	 * host / bus / target / lun
 	 */
 	attr_path = udev_device_get_sysname(parent);
+	if (!attr_path)
+		return PATHINFO_FAILED;
 	pp->sg_id.lun = 0;
 	if (sscanf(attr_path, "%i.%i.%x",
 		   &pp->sg_id.host_no,
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 0bc5106e..b726be2a 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -482,6 +482,7 @@ _find_path_by_syspath(struct nvme_map *map, const char *syspath)
 	struct nvme_pathgroup *pg;
 	char real[PATH_MAX];
 	const char *ppath;
+	const char *psyspath;
 	int i;

 	ppath = realpath(syspath, real);
@@ -493,8 +494,8 @@ _find_path_by_syspath(struct nvme_map *map, const char *syspath)
 	vector_foreach_slot(&map->pgvec, pg, i) {
 		struct nvme_path *path = nvme_pg_to_path(pg);

-		if (!strcmp(ppath,
-			    udev_device_get_syspath(path->udev)))
+		psyspath = udev_device_get_syspath(path->udev);
+		if (psyspath && !strcmp(ppath, psyspath))
 			return path;
 	}
 	condlog(4, "%s: %s: %s not found", __func__, THIS, ppath);
@@ -538,6 +539,7 @@ struct udev_device *get_ctrl_blkdev(const struct context *ctx,
 	struct udev_list_entry *item;
 	struct udev_device *blkdev = NULL;
 	struct udev_enumerate *enm = udev_enumerate_new(ctx->udev);
+	const char *devtype;

 	if (enm == NULL)
 		return NULL;
@@ -562,7 +564,9 @@ struct udev_device *get_ctrl_blkdev(const struct context *ctx,
 					   udev_list_entry_get_name(item));
 		if (tmp == NULL)
 			continue;
-		if (!strcmp(udev_device_get_devtype(tmp), "disk")) {
+
+		devtype = udev_device_get_devtype(tmp);
+		if (devtype && !strcmp(devtype, "disk")) {
 			blkdev = tmp;
 			break;
 		} else
-- 

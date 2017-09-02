From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/31] kpartx: fix a corner case when renaming
	partitions
Date: Sun,  3 Sep 2017 00:38:34 +0200
Message-ID: <20170902223900.7339-6-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Fix a pathological issue that I discovered with test-kpartx.
When a dm device is named like a device node (e.g. dm name "loop1"),
kpartx would erroneously pick the dm device if asked to work on
partitions on the other device. Fortunately we can use the UUID
scheme created earlier to see whether or not the device is a dm device.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 kpartx/devmapper.h | 13 +++++++++++++
 kpartx/kpartx.c    | 25 -------------------------
 3 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 4aca0e51..4469fa84 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -668,7 +668,12 @@ int dm_find_part(const char *parent, const char *delim, int part,
 	if (dm_type(tmp, "linear") != 1)
 		goto out;
 
-	if (dm_devn(parent, &major, &minor))
+	/*
+	 * Try nondm uuid first. That way we avoid confusing
+	 * a device name with a device mapper name.
+	 */
+	if (!nondm_parse_uuid(parent_uuid, &major, &minor) &&
+	    dm_devn(parent, &major, &minor))
 		goto out;
 	snprintf(dev_t, sizeof(dev_t), "%d:%d", major, minor);
 
@@ -693,3 +698,40 @@ out:
 	free((void*)tmp);
 	return r;
 }
+
+char *nondm_create_uuid(dev_t devt)
+{
+#define NONDM_UUID_BUFLEN (34 + sizeof(NONDM_UUID_PREFIX) + \
+			   sizeof(NONDM_UUID_SUFFIX))
+	static char uuid_buf[NONDM_UUID_BUFLEN];
+	snprintf(uuid_buf, sizeof(uuid_buf), "%s_%u:%u_%s",
+		 NONDM_UUID_PREFIX, major(devt), minor(devt),
+		 NONDM_UUID_SUFFIX);
+	uuid_buf[NONDM_UUID_BUFLEN-1] = '\0';
+	return uuid_buf;
+}
+
+int nondm_parse_uuid(const char *uuid, int *major, int *minor)
+{
+	const char *p;
+	char *e;
+	int ma, mi;
+
+	if (strncmp(uuid, NONDM_UUID_PREFIX "_", sizeof(NONDM_UUID_PREFIX)))
+		return 0;
+	p = uuid + sizeof(NONDM_UUID_PREFIX);
+	ma = strtoul(p, &e, 10);
+	if (e == p || *e != ':')
+		return 0;
+	p = e + 1;
+	mi = strtoul(p, &e, 10);
+	if (e == p || *e != '_')
+		return 0;
+	p = e + 1;
+	if (strcmp(p, NONDM_UUID_SUFFIX))
+		return 0;
+
+	*major = ma;
+	*minor = mi;
+	return 1;
+}
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 0ce4b0d5..73b80f2f 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -22,4 +22,17 @@ int dm_find_part(const char *parent, const char *delim, int part,
 		 const char *parent_uuid,
 		 char *name, size_t namesiz, char **part_uuid, int verbose);
 
+/*
+ * UUID format for partitions created on non-DM devices
+ * ${UUID_PREFIX}devnode_${MAJOR}:${MINOR}_${NONDM_UUID_SUFFIX}"
+ * where ${UUID_PREFIX} is "part${PARTNO}-" (see devmapper.c).
+ *
+ * The suffix should be sufficiently unique to avoid incidental conflicts;
+ * the value below is a base64-encoded random number.
+ * The UUID format shouldn't be changed between kpartx releases.
+ */
+#define NONDM_UUID_PREFIX "devnode"
+#define NONDM_UUID_SUFFIX "Wh5pYvM"
+char *nondm_create_uuid(dev_t devt);
+int nondm_parse_uuid(const char *uuid, int *major, int *minor);
 #endif /* _KPARTX_DEVMAPPER_H */
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index ad486afd..62f54308 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -60,31 +60,6 @@ struct pt {
 int ptct = 0;
 int udev_sync = 1;
 
-/*
- * UUID format for partitions created on non-DM devices
- * ${UUID_PREFIX}devnode_${MAJOR}:${MINOR}_${NONDM_UUID_SUFFIX}"
- * where ${UUID_PREFIX} is "part${PARTNO}-" (see devmapper.c).
- *
- * The suffix should be sufficiently unique to avoid incidental conflicts;
- * the value below is a base64-encoded random number.
- * The UUID format shouldn't be changed between kpartx releases.
- */
-#define NONDM_UUID_PREFIX "devnode"
-#define NONDM_UUID_SUFFIX "Wh5pYvM"
-
-static char *
-nondm_create_uuid(dev_t devt)
-{
-#define NONDM_UUID_BUFLEN (34 + sizeof(NONDM_UUID_PREFIX) + \
-			   sizeof(NONDM_UUID_SUFFIX))
-	static char uuid_buf[NONDM_UUID_BUFLEN];
-	snprintf(uuid_buf, sizeof(uuid_buf), "%s_%u:%u_%s",
-		 NONDM_UUID_PREFIX, major(devt), minor(devt),
-		 NONDM_UUID_SUFFIX);
-	uuid_buf[NONDM_UUID_BUFLEN-1] = '\0';
-	return uuid_buf;
-}
-
 static void
 addpts(char *t, ptreader f)
 {
-- 
2.14.0

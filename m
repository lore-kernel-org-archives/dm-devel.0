From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/12] kpartx: use partition UUID for non-DM
	devices
Date: Mon, 15 May 2017 17:37:19 +0200
Message-ID: <20170515153722.11508-10-mwilck@suse.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

For dm devices, kpartx uses an UUID check at partition removal
to make sure it only deletes partitions it previously created.
Non-DM parent devices such as loop devices don't generally have
a UUID.

Introduce a "fake" UUID for these devices to make sure kpartx
deletes only devices it had created previously. Otherwise kpartx
might e.g. delete LVM LVs that are inside a device it is trying
to delete partitions for. It seems to be wiser to make sure the
user delete these manually before running "kpartx -d".

With the fake UUID in place, we can re-introduce the UUID check
for non-DM device that was removed in the earlier patch
"kpartx: dm_remove_partmaps: support non-dm devices".

This disables also deletion of partition mappings created
by earlier versions of kpartx. If kpartx has been updated after
partition mappings were created, the "-f" flag can be used
to force delting these partitions, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c |  2 +-
 kpartx/kpartx.c    | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index b714ba4e..4ab58ce9 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -511,7 +511,7 @@ do_foreach_partmaps (const char * mapname, const char *uuid,
 		/*
 		 * skip if uuids don't match
 		 */
-		if (is_dmdev && uuid && dm_compare_uuid(uuid, names->name)) {
+		if (uuid && dm_compare_uuid(uuid, names->name)) {
 			if (rd->verbose)
 				printf("%s: is not a kpartx partition. Not removing\n",
 				       names->name);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index ea728b42..587c3dfe 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -60,6 +60,31 @@ struct pt {
 int ptct = 0;
 int udev_sync = 0;
 
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
+
+static char *
+nondm_create_uuid(dev_t devt)
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
 static void
 addpts(char *t, ptreader f)
 {
@@ -360,6 +385,15 @@ main(int argc, char **argv){
 			uuid = dm_mapuuid(mapname);
 	}
 
+	/*
+	 * We are called for a non-DM device.
+	 * Make up a fake UUID for the device, unless "-d -f" is given.
+	 * This allows deletion of partitions created with older kpartx
+	 * versions which didn't use the fake UUID during creation.
+	 */
+	if (!uuid && !(what == DELETE && force_devmap))
+		uuid = nondm_create_uuid(buf.st_rdev);
+
 	if (!mapname)
 		mapname = device + off;
 
-- 
2.12.2

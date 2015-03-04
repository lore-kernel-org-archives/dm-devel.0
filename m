From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 7/8] dm sysfs: introduce ability to add writable
	attributes
Date: Tue,  3 Mar 2015 19:47:10 -0500
Message-ID: <1425430031-78140-8-git-send-email-snitzer@redhat.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: axboe@kernel.dk, jmoyer@redhat.com
List-Id: dm-devel.ids

Add DM_ATTR_RW() macro and establish .store method in dm_sysfs_ops.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-sysfs.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index c62c5ab..1271c31 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -11,7 +11,7 @@
 struct dm_sysfs_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct mapped_device *, char *);
-	ssize_t (*store)(struct mapped_device *, char *);
+	ssize_t (*store)(struct mapped_device *, const char *, size_t count);
 };
 
 #define DM_ATTR_RO(_name) \
@@ -39,6 +39,31 @@ static ssize_t dm_attr_show(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
+#define DM_ATTR_RW(_name) \
+struct dm_sysfs_attr dm_attr_##_name = \
+	__ATTR(_name, S_IRUGO | S_IWUSR, dm_attr_##_name##_show, dm_attr_##_name##_store)
+
+static ssize_t dm_attr_store(struct kobject *kobj, struct attribute *attr,
+			     const char *page, size_t count)
+{
+	struct dm_sysfs_attr *dm_attr;
+	struct mapped_device *md;
+	ssize_t ret;
+
+	dm_attr = container_of(attr, struct dm_sysfs_attr, attr);
+	if (!dm_attr->store)
+		return -EIO;
+
+	md = dm_get_from_kobject(kobj);
+	if (!md)
+		return -EINVAL;
+
+	ret = dm_attr->store(md, page, count);
+	dm_put(md);
+
+	return ret;
+}
+
 static ssize_t dm_attr_name_show(struct mapped_device *md, char *buf)
 {
 	if (dm_copy_name_and_uuid(md, buf, NULL))
@@ -77,12 +102,9 @@ static struct attribute *dm_attrs[] = {
 
 static const struct sysfs_ops dm_sysfs_ops = {
 	.show	= dm_attr_show,
+	.store	= dm_attr_store,
 };
 
-/*
- * dm kobject is embedded in mapped_device structure
- * no need to define release function here
- */
 static struct kobj_type dm_ktype = {
 	.sysfs_ops	= &dm_sysfs_ops,
 	.default_attrs	= dm_attrs,
-- 
1.9.3 (Apple Git-50)

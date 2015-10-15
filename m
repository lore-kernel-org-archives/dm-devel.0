From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 04/12] block: Export integrity data interval size in sysfs
Date: Thu, 15 Oct 2015 16:00:02 -0400
Message-ID: <20151015200002.20721.63395.stgit@dwillia2-desk3.jf.intel.com>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: axboe@fb.com, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, Sagi Grimberg <sagig@mellanox.com>, dm-devel@redhat.com, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

From: Martin K. Petersen <martin.petersen@oracle.com>

The size of the data interval was not exported in the sysfs integrity
directory. Export it so that userland apps can tell whether the interval
is different from the device's logical block size.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-block |    7 +++++++
 block/blk-integrity.c                 |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 8df003963d99..71d184dbb70d 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -60,6 +60,13 @@ Description:
 		Indicates whether a storage device is capable of storing
 		integrity metadata. Set if the device is T10 PI-capable.
 
+What:		/sys/block/<disk>/integrity/protection_interval_bytes
+Date:		July 2015
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Describes the number of data bytes which are protected
+		by one integrity tuple. Typically the device's logical
+		block size.
 
 What:		/sys/block/<disk>/integrity/write_generate
 Date:		June 2008
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index c7508654faff..7a96f57ed195 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -289,6 +289,14 @@ static ssize_t integrity_tag_size_show(struct blk_integrity *bi, char *page)
 		return sprintf(page, "0\n");
 }
 
+static ssize_t integrity_interval_show(struct blk_integrity *bi, char *page)
+{
+	if (bi != NULL)
+		return sprintf(page, "%u\n", 1 << bi->interval_exp);
+	else
+		return sprintf(page, "0\n");
+}
+
 static ssize_t integrity_verify_store(struct blk_integrity *bi,
 				      const char *page, size_t count)
 {
@@ -343,6 +351,11 @@ static struct integrity_sysfs_entry integrity_tag_size_entry = {
 	.show = integrity_tag_size_show,
 };
 
+static struct integrity_sysfs_entry integrity_interval_entry = {
+	.attr = { .name = "protection_interval_bytes", .mode = S_IRUGO },
+	.show = integrity_interval_show,
+};
+
 static struct integrity_sysfs_entry integrity_verify_entry = {
 	.attr = { .name = "read_verify", .mode = S_IRUGO | S_IWUSR },
 	.show = integrity_verify_show,
@@ -363,6 +376,7 @@ static struct integrity_sysfs_entry integrity_device_entry = {
 static struct attribute *integrity_attrs[] = {
 	&integrity_format_entry.attr,
 	&integrity_tag_size_entry.attr,
+	&integrity_interval_entry.attr,
 	&integrity_verify_entry.attr,
 	&integrity_generate_entry.attr,
 	&integrity_device_entry.attr,


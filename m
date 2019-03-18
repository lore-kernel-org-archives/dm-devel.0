From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 01/10] libmultipath: add sysfs_get_inquiry()
Date: Mon, 18 Mar 2019 12:24:36 +0100
Message-ID: <20190318112445.6636-2-mwilck@suse.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Provide a utility function to retrieve inquiry data from
sysfs, like we do for VPDs.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 23 ++++++++++++++++++-----
 libmultipath/discovery.h |  6 ++++--
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 10bd8cd6..65d651d4 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -218,12 +218,11 @@ declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
 
-ssize_t
-sysfs_get_vpd (struct udev_device * udev, int pg,
-	       unsigned char * buff, size_t len)
+static ssize_t
+sysfs_get_binary (struct udev_device * udev, const char *attrname,
+		  unsigned char *buff, size_t len)
 {
 	ssize_t attr_len;
-	char attrname[9];
 	const char * devname;
 
 	if (!udev) {
@@ -232,7 +231,6 @@ sysfs_get_vpd (struct udev_device * udev, int pg,
 	}
 
 	devname = udev_device_get_sysname(udev);
-	sprintf(attrname, "vpd_pg%02x", pg);
 	attr_len = sysfs_bin_attr_get_value(udev, attrname, buff, len);
 	if (attr_len < 0) {
 		condlog(3, "%s: attribute %s not found in sysfs",
@@ -242,6 +240,21 @@ sysfs_get_vpd (struct udev_device * udev, int pg,
 	return attr_len;
 }
 
+ssize_t sysfs_get_vpd(struct udev_device * udev, unsigned char pg,
+		      unsigned char *buff, size_t len)
+{
+	char attrname[9];
+
+	snprintf(attrname, sizeof(attrname), "vpd_pg%02x", pg);
+	return sysfs_get_binary(udev, attrname, buff, len);
+}
+
+ssize_t sysfs_get_inquiry(struct udev_device * udev,
+			  unsigned char *buff, size_t len)
+{
+	return sysfs_get_binary(udev, "inquiry", buff, len);
+}
+
 int
 sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 9aacf75b..7cacbb6c 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -48,8 +48,10 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
 int sysfs_get_host_adapter_name(const struct path *pp,
 				char *adapter_name);
-ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
-		       size_t len);
+ssize_t sysfs_get_vpd (struct udev_device *udev, unsigned char pg,
+		       unsigned char *buff, size_t len);
+ssize_t sysfs_get_inquiry(struct udev_device *udev,
+			  unsigned char *buff, size_t len);
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev);
-- 
2.21.0

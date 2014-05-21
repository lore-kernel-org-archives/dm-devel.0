From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: Fix some minor issues in path
	reordering code
Date: Wed, 21 May 2014 14:02:47 -0500
Message-ID: <20140521190247.GM1716@dhcp80-209.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: ShivaKrishna Merla <shivakrishna.merla@netapp.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

There were a couple of small issues with the path reordering code.

Since you may fail to get the adapter name at any time while looping
through the paths, you need to clean up when this fails, instead of
just exitting group_by_host_adapter().

I've looked at a couple kernels, and I don't see any sysfs file named:
/sys/class/iscsi_host/host<n>/ip_address
It's always:
/sys/class/iscsi_host/host<n>/ipaddress

Also /sys/class/iscsi_host/host<n>/ipaddress could be an IPv6 address,
in which case we need 40 bytes to hold is, so SLOT_NAME_SIZE needs to
be 40 bytes large.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 2 +-
 libmultipath/discovery.c | 2 +-
 libmultipath/structs.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 42e0b9b..3ed6b55 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -56,7 +56,7 @@ int group_by_host_adapter(struct pathgroup *pgp, vector adapters)
 		pp = VECTOR_SLOT(pgp->paths, 0);
 
 		if (sysfs_get_host_adapter_name(pp, adapter_name1))
-			return 1;
+			goto out;
 		/* create a new host adapter group
 		 */
 		agp = alloc_adaptergroup();
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6f13745..786e1de 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -397,7 +397,7 @@ int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address)
 			"iscsi_host", host_name);
 	if (hostdev) {
 		value = udev_device_get_sysattr_value(hostdev,
-				"ip_address");
+				"ipaddress");
 		if (value) {
 			strncpy(ip_address, value, SLOT_NAME_SIZE);
 			udev_device_unref(hostdev);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 772a7d7..af03edf 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -16,7 +16,7 @@
 #define PATH_SIZE		512
 #define NAME_SIZE		512
 #define HOST_NAME_LEN		8
-#define SLOT_NAME_SIZE		32
+#define SLOT_NAME_SIZE		40
 
 #define SCSI_VENDOR_SIZE	9
 #define SCSI_PRODUCT_SIZE	17
-- 
1.8.3.1

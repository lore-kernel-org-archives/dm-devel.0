From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 25/33] libmultipath: sysfs_attr_set_value: use
	const char*
Date: Tue, 28 Feb 2017 17:23:21 +0100
Message-ID: <20170228162329.14517-26-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

The value argument in syfs_attr_set_value should be const char*.

Signed-off-by: Martin Wilck <mwilck@suse.de>
---
 libmultipath/sysfs.c | 2 +-
 libmultipath/sysfs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 9cf03117..97e09977 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -154,7 +154,7 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 }
 
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
-			     char * value, size_t value_len)
+			     const char * value, size_t value_len)
 {
 	char devpath[PATH_SIZE];
 	struct stat statbuf;
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 2588c247..75c0f9c1 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -6,7 +6,7 @@
 #define _LIBMULTIPATH_SYSFS_H
 
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
-			     char * value, size_t value_len);
+			     const char * value, size_t value_len);
 ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len);
 ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
-- 
2.11.0

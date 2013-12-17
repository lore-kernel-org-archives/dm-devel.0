From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] libmultipath: Fix overflow in sysfs_get_str()
Date: Tue, 17 Dec 2013 08:04:08 +0100
Message-ID: <1387263848-73945-6-git-send-email-hare@suse.de>
References: <1387263848-73945-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387263848-73945-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

sysfs_get_str() should first do a strchop() before comparing the
returned string length with the provided buffer. Otherwise we might
incur a false positive as the overflowing bits might be occupied
by spaces, which will be removed later on.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b7470f8..228ffd3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -157,13 +157,12 @@ sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)	\
 			devname, #fname);				\
 		return -ENXIO;						\
 	}								\
-	if (strlen(attr) > len) {					\
+	if (strchop(attr) > len) {					\
 		condlog(3, "%s: overflow in attribute %s",		\
 			devname, #fname);				\
 		return -EINVAL;						\
 	}								\
-	strlcpy(buff, attr, len);					\
-	return strchop(buff);						\
+	return strlcpy(buff, attr, len);				\
 }
 
 declare_sysfs_get_str(devtype);
-- 
1.7.12.4

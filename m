From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/5] libmultipath: Zero-terminate
	sysfs_attr_get_value() result
Date: Fri, 18 Jul 2014 14:53:39 +0200
Message-ID: <53C918D3.7060908@acm.org>
References: <53C91871.9070402@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53C91871.9070402@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

The callers of sysfs_attr_get_value() expect a '\0'-terminated string.
Hence terminate the string returned by this function with '\0'. Detected
by Valgrind.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 libmultipath/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index e5834f9..f42cda8 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -88,6 +88,8 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	} else if (size == value_len) {
 		condlog(4, "overflow while reading from %s", devpath);
 		size = 0;
+	} else {
+		value[size] = '\0';
 	}
 
 	close(fd);
-- 
1.8.4.5

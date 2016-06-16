From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 32/39] libmultipath/sysfs.c: always terminate
	value from sysfs_attr_get_value()
Date: Thu, 16 Jun 2016 11:47:38 +0200
Message-ID: <1466070465-1021-33-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Coverity complained that the returned value is not always NULL
terminated.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index a74de9f..2c0b591 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -86,16 +86,17 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	if (size < 0) {
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
 		size = -errno;
+		value[0] = '\0';
 	} else if (size == value_len) {
+		value[size - 1] = '\0';
 		condlog(4, "overflow while reading from %s", devpath);
 		size = 0;
 	} else {
 		value[size] = '\0';
+		size = strchop(value);
 	}
 
 	close(fd);
-	if (size > 0)
-		size = strchop(value);
 	return size;
 }
 
-- 
2.6.6

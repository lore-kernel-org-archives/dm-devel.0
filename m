From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] libmultipath: improve debugging messages in
	sysfs_attr_set_value()
Date: Thu, 14 Mar 2013 15:08:45 +0100
Message-ID: <1363270128-20900-4-git-send-email-hare@suse.de>
References: <1363270128-20900-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1363270128-20900-1-git-send-email-hare@suse.de>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

We should be printing out debugging messages for all failure
cases in sysfs_attr_set_value().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index d33747f..da228e4 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -58,12 +58,16 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	}
 
 	/* skip directories */
-	if (S_ISDIR(statbuf.st_mode))
+	if (S_ISDIR(statbuf.st_mode)) {
+		condlog(4, "%s is a directory", devpath);
 		return 0;
+	}
 
 	/* skip non-writeable files */
-	if ((statbuf.st_mode & S_IWUSR) == 0)
+	if ((statbuf.st_mode & S_IWUSR) == 0) {
+		condlog(4, "%s is not writeable", devpath);
 		return 0;
+	}
 
 	/* write attribute value */
 	fd = open(devpath, O_WRONLY);
-- 
1.7.10.4

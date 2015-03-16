From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/78] Remove trailing linefeed from sysfs
	attributes
Date: Mon, 16 Mar 2015 13:36:08 +0100
Message-ID: <1426509425-15978-22-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When reading from sysfs attributes might have a trailing linefeed,
which will then show up in the log messages as an additional
linefeed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 0e05316..102135a 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -93,6 +93,8 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	}
 
 	close(fd);
+	if (size > 0)
+		size = strchop(value);
 	return size;
 }
 
-- 
1.8.4.5

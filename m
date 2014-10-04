From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/3] libmultipath: fix sysfs_get_size bug
Date: Fri,  3 Oct 2014 19:11:22 -0500
Message-ID: <1412381483-15757-3-git-send-email-bmarzins@redhat.com>
References: <1412381483-15757-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412381483-15757-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

sysfs_get_size wasn't checking for a negative return value from
sysfs_attr_get_value.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index f42cda8..0e05316 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -158,7 +158,7 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 		return 1;
 
 	attr[0] = '\0';
-	if (sysfs_attr_get_value(pp->udev, "size", attr, 255) == 0) {
+	if (sysfs_attr_get_value(pp->udev, "size", attr, 255) <= 0) {
 		condlog(3, "%s: No size attribute in sysfs", pp->dev);
 		return 1;
 	}
-- 
1.8.3.1

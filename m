From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 4/6] libmultipath: check udev* return value in
 trigger_partitions_udev_change
Date: Tue, 15 Sep 2020 12:41:11 +0800
Message-ID: <94e6143b-9aac-affa-9c48-7e48f1910732@huawei.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel
	mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

We check the return value  of udev_device_get_devtype before
dereference it.

Signed-off-by:Lixiaokeng<Lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/configure.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 972cf5fe..7263707c 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -515,6 +515,7 @@ static void trigger_partitions_udev_change(struct udev_device *dev,
 {
 	struct udev_enumerate *part_enum;
 	struct udev_list_entry *item;
+	const char *devtype;

 	part_enum = udev_enumerate_new(udev);
 	if (!part_enum)
@@ -535,7 +536,8 @@ static void trigger_partitions_udev_change(struct udev_device *dev,
 		if (!part)
 			continue;

-		if (!strcmp("partition", udev_device_get_devtype(part))) {
+		devtype = udev_device_get_devtype(part);
+		if (devtype && !strcmp("partition", devtype)) {
 			condlog(4, "%s: triggering %s event for %s", __func__,
 				action, syspath);
 			sysfs_attr_set_value(part, "uevent", action, len);
-- 

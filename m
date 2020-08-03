From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH] libmultipath: fix null dereference in add
Date: Mon, 3 Aug 2020 19:57:01 +0800
Message-ID: <9f10e135-348d-d11a-85cb-797522ba5210@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
List-Id: dm-devel.ids

I got a multipath segfault while running iscsi login/logout and following scripts in parallel:

#!/bin/bash
interval=1
while true
do
              multipath -F &> /dev/null
              multipath -r &> /dev/null
              multipath -v2 &> /dev/null
              multipath -ll &> /dev/null
              sleep $interval
done

This is the debuginfo:
#0  0x00007f3805e4df58 in add (ctx=0x55d1569e4a00, ud=0x55d1569bafd0) at nvme.c:801
801              if (strcmp("disk", udev_device_get_devtype(ud)))
(gdb) bt
#0  0x00007f3805e4df58 in add (ctx=0x55d1569e4a00, ud=0x55d1569bafd0) at nvme.c:801
#1  0x00007f3806687a44 in add_foreign (udev=0x55d1569bafd0) at foreign.c:299
#2  0x00007f3806665abf in is_claimed_by_foreign (ud=<optimized out>) at foreign.h:316
#3  pathinfo (pp=0x55d1569e9f50, conf=0x55d1569b92d0, mask=69) at discovery.c:2064
#4  0x000055d154c91cbb in check_usable_paths (conf=0x55d1569b92d0, devpath=0x55d1569e3200 "dm-6", dev_type=<optimized out>) at main.c:368
#5  0x000055d154c910a5 in main (argc=3, argv=<optimized out>) at main.c:1057
In add() at libmultipath/foreign/nvme.c, udev_device_get_devtype(ud) return a NULL pointer then dereferenced.
Here, NULL check is needed.
Check if udev_device_get_devtype return NULL before dereferencing it.

Signed-off-by: lutianxiong <lutianxiong huawei com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/foreign/nvme.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 280b6bd..6061999 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -600,12 +600,14 @@ int add(struct context *ctx, struct udev_device *ud)
 {
 	struct udev_device *subsys;
 	int rc;
+	const char *devtype;

 	condlog(5, "%s called for \"%s\"", __func__, THIS);

 	if (ud == NULL)
 		return FOREIGN_ERR;
-	if (strcmp("disk", udev_device_get_devtype(ud)))
+	if ((devtype = udev_device_get_devtype(ud)) == NULL ||
+						strcmp("disk", devtype))
 		return FOREIGN_IGNORED;

 	subsys = udev_device_get_parent_with_subsystem_devtype(ud,
-- 

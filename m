From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 3/6] libmultipath: check udev* return value in
 sysfs_get_tgt_nodename
Date: Tue, 15 Sep 2020 12:40:39 +0800
Message-ID: <a47d7089-02c4-320b-9710-bc8cfd2fd14b@huawei.com>
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

We check the return value of udev_device_get_parent and
udev_device_get_sysname.

Signed-off-by:lixiaokeng<lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 27cb67f8..c490dddb 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -356,7 +356,7 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 		tgtdev = udev_device_get_parent(parent);
 		while (tgtdev) {
 			tgtname = udev_device_get_sysname(tgtdev);
-			if (sscanf(tgtname, "end_device-%d:%d",
+			if (tgtname && sscanf(tgtname, "end_device-%d:%d",
 				   &host, &tgtid) == 2)
 				break;
 			tgtdev = udev_device_get_parent(tgtdev);
@@ -389,7 +389,7 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 	/* Check for FibreChannel */
 	tgtdev = udev_device_get_parent(parent);
 	value = udev_device_get_sysname(tgtdev);
-	if (sscanf(value, "rport-%d:%d-%d",
+	if (value && sscanf(value, "rport-%d:%d-%d",
 		   &host, &channel, &tgtid) == 3) {
 		tgtdev = udev_device_new_from_subsystem_sysname(udev,
 				"fc_remote_ports", value);
-- 

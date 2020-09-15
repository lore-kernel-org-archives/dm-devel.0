From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 1/6] libmultipath: check uedv* return value in
 sysfs_get_host_pci_name
Date: Tue, 15 Sep 2020 12:39:15 +0800
Message-ID: <965e9cd1-f0dc-b94a-4314-0e8f6cb50bf5@huawei.com>
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

udev_device_get_sysname may return NULL. We check the return value.

Signed-off-by:Lixiaokeng<Lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/discovery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3f1b1d71..4264b0da 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -519,6 +519,9 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
 		 */
 		value = udev_device_get_sysname(parent);

+		if (!value)
+			return 1;
+
 		strncpy(pci_name, value, SLOT_NAME_SIZE);
 		udev_device_unref(hostdev);
 		return 0;
-- 

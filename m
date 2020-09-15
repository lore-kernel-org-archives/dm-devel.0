From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 2/6] libmultipath: check udev* return value in
 ccw_sysfs_pathinfo
Date: Tue, 15 Sep 2020 12:39:59 +0800
Message-ID: <cf6ba543-dd8d-cbc9-b69d-a4e9efd0c7f9@huawei.com>
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

We check the return value of udev_device_get_sysname.

Signed-off-by:Lixiaokeng<lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/discovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4264b0da..27cb67f8 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1471,6 +1471,8 @@ ccw_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 	 * host / bus / target / lun
 	 */
 	attr_path = udev_device_get_sysname(parent);
+	if (attr_path)
+		return PATHINFO_FAILED;
 	pp->sg_id.lun = 0;
 	if (sscanf(attr_path, "%i.%i.%x",
 		   &pp->sg_id.host_no,
-- 

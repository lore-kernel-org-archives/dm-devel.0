From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 07/14] libmultipath: check return value of
 dm_mapname in, sysfs_check_holders
Date: Wed, 2 Sep 2020 15:19:51 +0800
Message-ID: <efc49805-8938-00d4-5eff-230f8f6f064e@huawei.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
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
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

In sysfs_check_holders func, table_name is obtained by calling
dm_mapname func, and then call dm_reassign_table for reassigning
table. However, we donnot check whether dm_mapname func returns
NULL, and then it may cause a segmentation fault in dm_task_set_name.

Here, we will check whether dm_mapname func returns NULL before
using it.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 12a82d95..5390de62 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -278,7 +278,11 @@ int sysfs_check_holders(char * check_devt, char * new_devt)
 			continue;
 		}
 		table_name = dm_mapname(major, table_minor);
-
+		if (!table_name) {
+			condlog(2, "%s: mapname not found for %d:%d", check_dev,
+				major, table_minor);
+			continue;
+		}
 		condlog(0, "%s: reassign table %s old %s new %s", check_dev,
 			table_name, check_devt, new_devt);

-- 

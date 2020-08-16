From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH 4/6] libmultipath: check blist before calling
 MALLOC in alloc_ble_device func
Date: Sun, 16 Aug 2020 09:45:06 +0800
Message-ID: <4127cfc2-413f-32d9-cf76-0c0453524aeb@huawei.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmarzins@redhat.com, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


In alloc_ble_device func, ble is firstly allocated by calling MALLOC,
and then input blist is checked whether it is valid. If blist is not
valid, ble will be freed without using.

Here, we should check blist firstly.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/blacklist.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index db58ccc..bedcc7e 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -66,12 +66,16 @@ out:

 int alloc_ble_device(vector blist)
 {
-	struct blentry_device * ble = MALLOC(sizeof(struct blentry_device));
+	struct blentry_device *ble;

+	if (!blist)
+		return 1;
+
+	ble = MALLOC(sizeof(struct blentry_device));
 	if (!ble)
 		return 1;

-	if (!blist || !vector_alloc_slot(blist)) {
+	if (!vector_alloc_slot(blist)) {
 		FREE(ble);
 		return 1;
 	}
-- 
1.8.3.1

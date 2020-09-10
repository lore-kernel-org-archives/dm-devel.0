From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V4 05/14] multipathd: check return value of
 malloc in cli_getprkey func
Date: Thu, 10 Sep 2020 18:49:27 +0800
Message-ID: <4a43f1ca-c756-ed8f-c69d-a388b0911a61@huawei.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
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

In cli_getprkey func, we check the return value of malloc.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 multipathd/cli_handlers.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index e9698704..235e2a2e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1531,6 +1531,8 @@ cli_getprkey(void * v, char ** reply, int * len, void * data)
 		return 1;

 	*reply = malloc(26);
+	if (!*reply)
+		return 1;

 	if (!get_be64(mpp->reservation_key)) {
 		sprintf(*reply, "none\n");
-- 

From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V3 05/14] multipathd: use MALLOC and check return
 value in cli_getprkey func
Date: Tue, 8 Sep 2020 16:49:03 +0800
Message-ID: <fd8cdf1e-3a56-e904-21e1-eb6258f78d79@huawei.com>
References: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
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

In cli_getprkey func, we use MALLOC instead of malloc, and check
the return value of MALLOC.

V1->V2: turn back MALLOC to malloc and reomve error message

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

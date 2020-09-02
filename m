From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 04/14] multipathd: check MALLOC return value in,
 mpath_pr_event_handler_fn
Date: Wed, 2 Sep 2020 15:17:56 +0800
Message-ID: <8b45a04b-c851-94ba-fcba-676c03b060e7@huawei.com>
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

In  mpath_pr_event_handler_fn, we use MALLOC instead of malloc, and check
the return value of MALLOC.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 multipathd/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 67e9af11..7180d3c1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3391,8 +3391,12 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 		goto out;
 	}

-	param= malloc(sizeof(struct prout_param_descriptor));
-	memset(param, 0 , sizeof(struct prout_param_descriptor));
+	param = (struct prout_param_descriptor *)MALLOC(sizeof(struct prout_param_descriptor));
+	if (!param) {
+		ret = MPATH_PR_OTHER;
+		goto out;
+	}
+
 	param->sa_flags = mpp->sa_flags;
 	memcpy(param->sa_key, &mpp->reservation_key, 8);
 	param->num_transportid = 0;
-- 

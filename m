From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V4 04/14] multipathd: check MALLOC return value
 in mpath_pr_event_handler_fn
Date: Thu, 10 Sep 2020 18:48:35 +0800
Message-ID: <c1041522-f3e6-7d1f-3fd0-34c356230b5a@huawei.com>
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

In  mpath_pr_event_handler_fn, we use MALLOC instead of malloc, and check
the return value of MALLOC. And we delete seting ret when jump to out

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 multipathd/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 67e9af11..f1264459 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3365,7 +3365,6 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
 		condlog(1, "%s: No key found. Device may not be registered.", pp->dev);
-		ret = MPATH_PR_SUCCESS;
 		goto out;
 	}
 	condlog(2, "Multipath  reservation_key: 0x%" PRIx64 " ",
@@ -3387,12 +3386,13 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	{
 		condlog(0, "%s: Either device not registered or ", pp->dev);
 		condlog(0, "host is not authorised for registration. Skip path");
-		ret = MPATH_PR_OTHER;
 		goto out;
 	}

-	param= malloc(sizeof(struct prout_param_descriptor));
-	memset(param, 0 , sizeof(struct prout_param_descriptor));
+	param = (struct prout_param_descriptor *)MALLOC(sizeof(struct prout_param_descriptor));
+	if (!param)
+		goto out;
+
 	param->sa_flags = mpp->sa_flags;
 	memcpy(param->sa_key, &mpp->reservation_key, 8);
 	param->num_transportid = 0;
-- 

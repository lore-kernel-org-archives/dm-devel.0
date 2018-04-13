From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmultipath: Fix logic in should_multipath
Date: Fri, 13 Apr 2018 19:20:42 +0200
Message-ID: <20180413172042.11820-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Commit d3b71498 missed a negation.

Fixes: d3b71498 "multipath: fix rcu thread cancellation hang"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/wwids.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 0ec9f25b..8c21b33f 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -284,7 +284,7 @@ should_multipath(struct path *pp1, vector pathvec)
 	ignore_new_devs = conf->ignore_new_devs;
 	find_multipaths = conf->find_multipaths;
 	put_multipath_config(conf);
-	if (find_multipaths && !ignore_new_devs)
+	if (!find_multipaths && !ignore_new_devs)
 		return 1;
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
-- 
2.16.1

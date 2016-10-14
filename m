From: tang.wenjun3@zte.com.cn
Subject: [PATCH 14/94] multipath-tools: remove pgpolicy=FAILOVER
	from Ceph/RBD
Date: Fri, 14 Oct 2016 09:55:56 +0800
Message-ID: <1476410236-9368-14-git-send-email-tang.wenjun3@zte.com.cn>
References: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 10144149@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

It's already the default pgpolicy.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 01d3c53..bfe5df4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -818,7 +818,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "Ceph",
 		.product       = "RBD",
-		.pgpolicy      = FAILOVER,
 		.no_path_retry = NO_PATH_RETRY_FAIL,
 		.checker_name  = RBD,
 		.deferred_remove = DEFERRED_REMOVE_ON,
-- 
2.8.1.windows.1

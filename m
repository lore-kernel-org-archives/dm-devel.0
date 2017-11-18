From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/4] libmultipath: path latency: log threshold
	with p2
Date: Sat, 18 Nov 2017 01:11:32 +0100
Message-ID: <20171118001134.26622-3-mwilck@suse.com>
References: <20171118001134.26622-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171118001134.26622-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is not a critical error. It just means that the path in
question will have low priority (rightly so, if it has >100s latency).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/path_latency.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index b8c5bc7c50a4..ce5c95dd7075 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -299,7 +299,7 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 			(long long)pow(base_num, lg_avglatency));
 
 	if (lg_avglatency > lg_maxavglatency) {
-		pp_pl_log(0,
+		pp_pl_log(2,
 			  "%s: average latency (%lld us) is outside the thresold (%lld us)",
 			  pp->dev, (long long)pow(base_num, lg_avglatency),
 			  (long long)MAX_AVG_LATENCY);
-- 
2.15.0

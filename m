From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/57] libmultipath: correctly display checker
	status
Date: Wed, 27 Apr 2016 13:10:16 +0200
Message-ID: <1461755458-29225-16-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The '%d chk' message should only be used if there are active paths,
otherwise the path checker most certainly haven't been run.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/print.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 96a1680..7fec6e9 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -177,7 +177,7 @@ snprint_queueing (char * buff, size_t len, struct multipath * mpp)
 		if (mpp->retry_tick > 0)
 			return snprintf(buff, len, "%i sec",
 					mpp->retry_tick);
-		else if (mpp->retry_tick == 0)
+		else if (mpp->retry_tick == 0 && mpp->nr_active > 0)
 			return snprintf(buff, len, "%i chk",
 					mpp->no_path_retry);
 		else
-- 
2.6.6

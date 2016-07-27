From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/7] libmultipath: Fix spelling in a log message
Date: Wed, 27 Jul 2016 14:13:01 -0700
Message-ID: <96b074bd-63a8-a3f0-9878-26175600d079@sandisk.com>
References: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 0caf269..1625990 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -459,7 +459,7 @@ out:
 		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
 			origin);
 	else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
-		condlog(3, "%s: no_path_retry = %s (inheritied setting)",
+		condlog(3, "%s: no_path_retry = %s (inherited setting)",
 			mp->alias, buff);
 	else
 		condlog(3, "%s: no_path_retry = undef (internal default)",
-- 
2.9.2

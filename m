From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 1/5] rbd: fix sync repair support
Date: Tue, 11 Oct 2016 16:36:51 -0500
Message-ID: <1476221815-17900-2-git-send-email-mchristi@redhat.com>
References: <1476221815-17900-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476221815-17900-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

If sync was set we were calling check instead
of function passed in.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index bfec2c9..8f88154 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -552,7 +552,7 @@ static int rbd_exec_fn(struct checker *c, thread_fn *fn)
 	int rbd_status, r;
 
 	if (c->sync)
-		return rbd_check(ct, c->message);
+		return fn(ct, c->message);
 	/*
 	 * Async mode
 	 */
-- 
2.7.2

From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 1/2] multipath-tools: check for initialized
	checker before
Date: Mon, 15 Aug 2016 12:13:45 -0500
Message-ID: <1471281226-7719-1-git-send-email-mchristi@redhat.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, bart.vanassche@sandisk.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

This fixes a regression added with:
015f87b16a7797a17afd514aec46e65c2a1a2f73

We can hit a race where when pathinfo is setting up a path, the path
could have gone down already. In the DI_CHECKER chunk we then do not run
get_state and attach a checker. Later when check_path is run
path_offline could still return PATH_DOWN or PATH_REMOVED and
get_state is again not run so we do not get to attach a checker. I
was then running repair_path since the state was PATH_DOWN, and we then
hit a segfault.

This has us test if a checker is selected before running repair.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 8976c89..fd999b0 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -213,7 +213,7 @@ void checker_put (struct checker * dst)
 
 void checker_repair (struct checker * c)
 {
-	if (!c)
+	if (!c || !checker_selected(c))
 		return;
 
 	c->message[0] = '\0';
-- 
2.7.2

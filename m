From: tang.junhui@zte.com.cn
Subject: [PATCH 3/3] Treat PATH_TIMEOUT as PATH_DOWN
Date: Tue, 18 Oct 2016 10:51:09 +0800
Message-ID: <1476759069-9832-3-git-send-email-tang.junhui@zte.com.cn>
References: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, "tang.junhui" <tang.junhui@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

Treat PATH_TIMEOUT as PATH_DOWN since it is basically the same as
PATH_DOWN, except with a different state name. So change it to PATH_DOWN
immediately if it is PATH_TIMEOUT according to the method in pathinfo().
After the modification all PATH_TIMEOUTs are equal to PATH_DOWN since the
rest of pp->state is assigned all in pathinfo().

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 multipathd/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e369a79..f715eb5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1528,6 +1528,10 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		put_multipath_config(conf);
 		return 1;
 	}
+
+	if (newstate == PATH_TIMEOUT)
+		newstate = PATH_DOWN;
+
 	if (!pp->mpp) {
 		if (!strlen(pp->wwid) && pp->initialized != INIT_MISSING_UDEV &&
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
@@ -1601,7 +1605,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		pp->checkint = conf->checkint;
 		put_multipath_config(conf);
 
-		if (newstate == PATH_DOWN || newstate == PATH_SHAKY || newstate == PATH_TIMEOUT) {
+		if (newstate == PATH_DOWN || newstate == PATH_SHAKY) {
 			/*
 			 * proactively fail path in the DM
 			 */
-- 
2.8.1.windows.1

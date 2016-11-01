From: peng.liang5@zte.com.cn
Subject: [PATCH] multipathd: remove unnecessary condition in
	check_path
Date: Tue, 1 Nov 2016 16:14:31 +0800
Message-ID: <1477988071-5104-1-git-send-email-peng.liang5@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, PengLiang <peng.liang5@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: PengLiang <peng.liang5@zte.com.cn>

The pp->mpp is an unnecessary condition. It will be return before this condition
if pp->mpp is NULL.

Signed-off-by: PengLiang <peng.liang5@zte.com.cn>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 03c2dd9..6a80ebe 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1566,7 +1566,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
 	     pp->wait_checks > 0) {
-		if (pp->mpp && pp->mpp->nr_active > 0) {
+		if (pp->mpp->nr_active > 0) {
 			pp->state = PATH_DELAYED;
 			pp->wait_checks--;
 			return 1;
-- 
2.8.1.windows.1

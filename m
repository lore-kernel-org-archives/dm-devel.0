From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 23/24] multipathd: simplify retry logic in
	ev_add_path()
Date: Mon, 10 Dec 2018 10:49:58 +0100
Message-ID: <20181210094959.11338-24-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Move the retry loop for DOMAP_RETRY out of the redundant outer
if conditional, and replace the goto construct with a while loop.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fd3459f7..99145293 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -993,15 +993,14 @@ rescan:
 	/*
 	 * reload the map for the multipath mapped device
 	 */
-retry:
 	ret = domap(mpp, params, 1);
+	while (ret == DOMAP_RETRY && retries-- > 0) {
+		condlog(0, "%s: retry domap for addition of new "
+			"path %s", mpp->alias, pp->dev);
+		sleep(1);
+		ret = domap(mpp, params, 1);
+	}
 	if (ret == DOMAP_FAIL || ret == DOMAP_RETRY) {
-		if (ret == DOMAP_RETRY && retries-- > 0) {
-			condlog(0, "%s: retry domap for addition of new "
-				"path %s", mpp->alias, pp->dev);
-			sleep(1);
-			goto retry;
-		}
 		condlog(0, "%s: failed in domap for addition of new "
 			"path %s", mpp->alias, pp->dev);
 		/*
-- 
2.19.2

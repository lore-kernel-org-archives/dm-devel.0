From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/78] multipathd: handle DOMAP_RETRY
Date: Mon, 16 Mar 2015 13:36:15 +0100
Message-ID: <1426509425-15978-29-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Calling domap() will first check if all paths are available by
using 'flock' on each path. This might fail if other processes
are holding the lock already. In these cases we should retry
domap() as the processes should terminate eventually.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2107113..494f4bb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -467,6 +467,7 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 	char params[PARAMS_SIZE] = {0};
 	int retries = 3;
 	int start_waiter = 0;
+	int ret;
 
 	/*
 	 * need path UID to go any further
@@ -546,7 +547,15 @@ rescan:
 	/*
 	 * reload the map for the multipath mapped device
 	 */
-	if (domap(mpp, params) <= 0) {
+retry:
+	ret = domap(mpp, params);
+	if (ret <= 0) {
+		if (ret < 0 && retries-- > 0) {
+			condlog(0, "%s: retry domap for addition of new "
+				"path %s", mpp->alias, pp->dev);
+			sleep(1);
+			goto retry;
+		}
 		condlog(0, "%s: failed in domap for addition of new "
 			"path %s", mpp->alias, pp->dev);
 		/*
-- 
1.8.4.5

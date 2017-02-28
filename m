From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 31/33] multipathd: fixup check for new path states
Date: Tue, 28 Feb 2017 17:23:27 +0100
Message-ID: <20170228162329.14517-32-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When testing for new path states we should be making sure to
always using the same path state mask. Otherwise we'll miss
out any states.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e2e73749..aa359b4a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1735,7 +1735,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		pp->checkint = conf->checkint;
 		put_multipath_config(conf);
 
-		if (newstate == PATH_DOWN || newstate == PATH_SHAKY || newstate == PATH_TIMEOUT) {
+		if (newstate != PATH_UP && newstate != PATH_GHOST) {
 			/*
 			 * proactively fail path in the DM
 			 */
-- 
2.11.0

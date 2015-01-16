From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/8] multipathd: fix memory corruption issue
Date: Fri, 16 Jan 2015 14:23:29 -0600
Message-ID: <1421439812-11826-6-git-send-email-bmarzins@redhat.com>
References: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

setup_multipath already removes the mpp if it fails, so we shouldn't be
accessing the mpp at all if it fails, and especially not freeing it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3afed62..a194c80 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -657,9 +657,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 			/*
 			 * update our state from kernel
 			 */
-			if (setup_multipath(vecs, mpp)) {
-				goto fail;
-			}
+			if (setup_multipath(vecs, mpp))
+				return 1;
 			sync_map_state(mpp);
 
 			condlog(2, "%s [%s]: path removed from map %s",
-- 
1.8.3.1

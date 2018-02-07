From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/7] multipathd: remove unused configure parameter
Date: Wed,  7 Feb 2018 16:49:44 -0600
Message-ID: <1518043787-7066-5-git-send-email-bmarzins@redhat.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

configure() is always called with start_waiters=1, so there is no point
in having the parameter. Remove it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index cf76241..233d09f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1950,7 +1950,7 @@ checkerloop (void *ap)
 }
 
 int
-configure (struct vectors * vecs, int start_waiters)
+configure (struct vectors * vecs)
 {
 	struct multipath * mpp;
 	struct path * pp;
@@ -2049,11 +2049,9 @@ configure (struct vectors * vecs, int start_waiters)
 			i--;
 			continue;
 		}
-		if (start_waiters) {
-			if (start_waiter_thread(mpp, vecs)) {
-				remove_map(mpp, vecs, 1);
-				i--;
-			}
+		if (start_waiter_thread(mpp, vecs)) {
+			remove_map(mpp, vecs, 1);
+			i--;
 		}
 	}
 	return 0;
@@ -2120,7 +2118,7 @@ reconfigure (struct vectors * vecs)
 	rcu_assign_pointer(multipath_conf, conf);
 	call_rcu(&old->rcu, rcu_free_config);
 
-	configure(vecs, 1);
+	configure(vecs);
 
 
 	return 0;
-- 
2.7.4

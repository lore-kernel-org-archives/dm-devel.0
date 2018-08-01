From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 31/32] multipathd: remove useless check and fix
	format
Date: Wed,  1 Aug 2018 15:57:17 -0500
Message-ID: <1533157038-3924-32-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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

The only thing this patch changes is to remove the check for pp->mpp
before the check for pp->mpp->prflags, since check_path() already
verified that pp->mpp != NULL. This fixes a number of coverity warnings.
Also, I normalized the spacing and indenting of the nearby code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 125a805..3c2fe7b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1978,14 +1978,14 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			return 1;
 		}
 
-		if(newstate == PATH_UP || newstate == PATH_GHOST){
-			if ( pp->mpp && pp->mpp->prflag ){
+		if (newstate == PATH_UP || newstate == PATH_GHOST) {
+			if (pp->mpp->prflag) {
 				/*
 				 * Check Persistent Reservation.
 				 */
-			condlog(2, "%s: checking persistent reservation "
-				"registration", pp->dev);
-			mpath_pr_event_handle(pp);
+				condlog(2, "%s: checking persistent "
+					"reservation registration", pp->dev);
+				mpath_pr_event_handle(pp);
 			}
 		}
 
-- 
2.7.4

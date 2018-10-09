From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 16/19] multipathd: remove useless check and
	fix format
Date: Tue,  9 Oct 2018 18:03:13 -0500
Message-ID: <1539126196-28926-17-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

The only thing this patch changes is to remove the check for pp->mpp
before the check for pp->mpp->prflags, since check_path() already
verified that pp->mpp != NULL. This fixes a number of coverity warnings.
Also, I normalized the spacing and indenting of the nearby code.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index cd96304..463b1b8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1979,14 +1979,14 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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

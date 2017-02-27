From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 4/6] multipathd: add messages on delayed path
	addition
Date: Mon, 27 Feb 2017 12:26:41 -0600
Message-ID: <1488220003-20541-5-git-send-email-bmarzins@redhat.com>
References: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
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

When multipath delays adding a path because the device is waiting for
udev to finish initialization, it now logs a message, so the users
know what happened to the path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 553d1d1..1d73f9d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -486,6 +486,8 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 
 	if (mpp) {
 		if (mpp->wait_for_udev > 1) {
+			condlog(2, "%s: performing delayed actions",
+				mpp->alias);
 			if (update_map(mpp, vecs))
 				/* setup multipathd removed the map */
 				return 1;
@@ -720,6 +722,7 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 	    (pathcount(mpp, PATH_UP) > 0 ||
 	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT))) {
 		/* if wait_for_udev is set and valid paths exist */
+		condlog(2, "%s: delaying path addition until %s is fully initialized", pp->dev, mpp->alias);
 		mpp->wait_for_udev = 2;
 		orphan_path(pp, "waiting for create to complete");
 		return 0;
-- 
1.8.3.1

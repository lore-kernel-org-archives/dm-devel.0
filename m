From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 27/33] libmultipath: differentiate ACT_NOTHING
	and ACT_IMPOSSIBLE
Date: Tue, 28 Feb 2017 17:23:23 +0100
Message-ID: <20170228162329.14517-28-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

select_action uses ACT_NOTHING for two different cases,
1) if changes can't be applied for some reason, and
2) if nothing needs to be done. Introduce ACT_IMPOSSIBLE
for case 1).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 7 ++++---
 libmultipath/configure.h | 1 +
 libmultipath/print.c     | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b400bb96..025947a8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -464,13 +464,13 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		/* reset alias to existing alias */
 		FREE(mpp->alias);
 		mpp->alias = STRDUP(cmpp->alias);
-		mpp->action = ACT_NOTHING;
+		mpp->action = ACT_IMPOSSIBLE;
 		return;
 	}
 
 	if (pathcount(mpp, PATH_UP) == 0) {
-		mpp->action = ACT_NOTHING;
-		condlog(3, "%s: set ACT_NOTHING (no usable path)",
+		mpp->action = ACT_IMPOSSIBLE;
+		condlog(3, "%s: set ACT_IMPOSSIBLE (no usable path)",
 			mpp->alias);
 		return;
 	}
@@ -671,6 +671,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 	switch (mpp->action) {
 	case ACT_REJECT:
 	case ACT_NOTHING:
+	case ACT_IMPOSSIBLE:
 		return DOMAP_EXIST;
 
 	case ACT_SWITCHPG:
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 442c956d..fb078a61 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -20,6 +20,7 @@ enum actions {
 	ACT_RESIZE,
 	ACT_FORCERENAME,
 	ACT_DRY_RUN,
+	ACT_IMPOSSIBLE,
 };
 
 #define FLUSH_ONE 1
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 00a36267..7c2a1588 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -996,7 +996,7 @@ int snprint_multipath_topology(char *buff, int len, struct multipath *mpp,
 
 	if (verbosity > 1 &&
 	    mpp->action != ACT_NOTHING &&
-	    mpp->action != ACT_UNDEF)
+	    mpp->action != ACT_UNDEF && mpp->action != ACT_IMPOSSIBLE)
 			c += sprintf(c, "%%A: ");
 
 	c += sprintf(c, "%%n");
-- 
2.11.0

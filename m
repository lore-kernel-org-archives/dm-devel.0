From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 3/4] multipathd: fix pp->initialized state
	ping-ponging
Date: Wed, 13 Feb 2019 16:55:07 -0600
Message-ID: <1550098508-27459-4-git-send-email-bmarzins@redhat.com>
References: <1550098508-27459-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1550098508-27459-1-git-send-email-bmarzins@redhat.com>
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

When a multipath device fails to get a wwid in pathinfo, it moves to the
INIT_MISSING_UDEV state. After a device in this state sends
retrigger_tries change uevents in check_path(), it moves to the
INIT_FAILED state.  However, when check_path() is run on a device in
INIT_FAILED, it can call pathinfo, which will set the path back
into INIT_MISSING_UDEV if it cannot get a wwid.  The next call to
check_path() will put the path back into INIT_FAILED.  The device will
continue to ping-pong between these states.

To solve this a new pp->initialized state has been added INIT_NEW.  New
path devices start in this state, instead of INIT_FAILED. INIT_NEW and
INIT_FAILED are treated exactly the same, with one exception. A device
in INIT_FAILED cannot transition back to INIT_MISSING_UDEV.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 8 +++++---
 libmultipath/structs.h   | 1 +
 multipathd/main.c        | 4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1748eeb..6aef188 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1966,8 +1966,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
 		get_uid(pp, path_state, pp->udev);
 		if (!strlen(pp->wwid)) {
-			pp->initialized = INIT_MISSING_UDEV;
-			pp->tick = conf->retrigger_delay;
+			if (pp->initialized != INIT_FAILED) {
+				pp->initialized = INIT_MISSING_UDEV;
+				pp->tick = conf->retrigger_delay;
+			}
 			return PATHINFO_OK;
 		}
 		else
@@ -2000,7 +2002,7 @@ blank:
 	 * Recoverable error, for example faulty or offline path
 	 */
 	pp->chkrstate = pp->state = PATH_DOWN;
-	if (pp->initialized == INIT_FAILED)
+	if (pp->initialized == INIT_NEW || pp->initialized == INIT_FAILED)
 		memset(pp->wwid, 0, WWID_SIZE);
 
 	return PATHINFO_OK;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 375c728..b794b0d 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -202,6 +202,7 @@ enum ghost_delay_states {
 };
 
 enum initialized_states {
+	INIT_NEW,
 	INIT_FAILED,
 	INIT_MISSING_UDEV,
 	INIT_REQUESTED_UDEV,
diff --git a/multipathd/main.c b/multipathd/main.c
index 37bea63..43830e8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2028,7 +2028,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		return 1;
 	}
 	if (!pp->mpp) {
-		if (!strlen(pp->wwid) && pp->initialized == INIT_FAILED &&
+		if (!strlen(pp->wwid) &&
+		    (pp->initialized == INIT_FAILED ||
+		     pp->initialized == INIT_NEW) &&
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
 			condlog(2, "%s: add missing path", pp->dev);
 			conf = get_multipath_config();
-- 
2.17.2

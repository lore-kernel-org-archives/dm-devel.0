From: mwilck@suse.com
Subject: [PATCH v2 63/74] multipathd: deal with INIT_REMOVED
	during path addition
Date: Wed, 12 Aug 2020 13:35:07 +0200
Message-ID: <20200812113511.26469-5-mwilck@suse.com>
References: <20200812113511.26469-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113511.26469-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

With the introduction of INIT_REMOVED, we have to deal with the situation
when a path is re-added in this state. This enables us to detect the
situation where a path is added while still part of a map after a failed
removal, which we couldn't before. Dealing with this correctly requires
some additional logic. There's a good case (re-added path is still mapped
by a map with matching WWID) and a bad case (non-matching WWID).

The logic is very similar in uev_add_path() and cli_add_path().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 54 +++++++++++++++++++++++++++++++++++--
 multipathd/main.c         | 57 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 105 insertions(+), 6 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 782bb00..c60182f 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -713,11 +713,61 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		goto blacklisted;
 
 	pp = find_path_by_dev(vecs->pathvec, param);
-	if (pp) {
+	if (pp && pp->initialized != INIT_REMOVED) {
 		condlog(2, "%s: path already in pathvec", param);
 		if (pp->mpp)
 			return 0;
-	} else {
+	} else if (pp) {
+		/* Trying to add a path in INIT_REMOVED state */
+		struct multipath *prev_mpp;
+
+		prev_mpp = pp->mpp;
+		if (prev_mpp == NULL)
+			condlog(0, "Bug: %s was in INIT_REMOVED state without being a multipath member",
+				pp->dev);
+		pp->mpp = NULL;
+		pp->initialized = INIT_NEW;
+		pp->wwid[0] = '\0';
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		r = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
+		pthread_cleanup_pop(1);
+
+		if (prev_mpp) {
+			/* Similar logic as in uev_add_path() */
+			pp->mpp = prev_mpp;
+			if (r == PATHINFO_OK &&
+			    !strncmp(prev_mpp->wwid, pp->wwid, WWID_SIZE)) {
+				condlog(2, "%s: path re-added to %s", pp->dev,
+					pp->mpp->alias);
+				/* Have the checker reinstate this path asap */
+				pp->tick = 1;
+				return 0;
+			} else if (!ev_remove_path(pp, vecs, true))
+				/* Path removed in ev_remove_path() */
+				pp = NULL;
+			else {
+				/* Init state is now INIT_REMOVED again */
+				pp->dmstate = PSTATE_FAILED;
+				dm_fail_path(pp->mpp->alias, pp->dev_t);
+				condlog(1, "%s: failed to re-add path still mapped in %s",
+					pp->dev, pp->mpp->alias);
+				return 1;
+			}
+		} else {
+			switch (r) {
+			case PATHINFO_SKIPPED:
+				goto blacklisted;
+			case PATHINFO_OK:
+				break;
+			default:
+				condlog(0, "%s: failed to get pathinfo", param);
+				return 1;
+			}
+		}
+	}
+
+	if (!pp) {
 		struct udev_device *udevice;
 
 		udevice = udev_device_new_from_subsystem_sysname(udev,
diff --git a/multipathd/main.c b/multipathd/main.c
index 2013f20..739cc05 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -842,9 +842,23 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
 		int r;
+		struct multipath *prev_mpp = NULL;
+
+		if (pp->initialized == INIT_REMOVED) {
+			condlog(3, "%s: re-adding removed path", pp->dev);
+			pp->initialized = INIT_NEW;
+			prev_mpp = pp->mpp;
+			if (prev_mpp == NULL)
+				condlog(0, "Bug: %s was in INIT_REMOVED state without being a multipath member",
+					pp->dev);
+			pp->mpp = NULL;
+			/* make sure get_uid() is called */
+			pp->wwid[0] = '\0';
+		} else
+			condlog(3,
+				"%s: spurious uevent, path already in pathvec",
+				uev->kernel);
 
-		condlog(3, "%s: spurious uevent, path already in pathvec",
-			uev->kernel);
 		if (!pp->mpp && !strlen(pp->wwid)) {
 			condlog(3, "%s: reinitialize path", uev->kernel);
 			udev_device_unref(pp->udev);
@@ -854,9 +868,44 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 			r = pathinfo(pp, conf,
 				     DI_ALL | DI_BLACKLIST);
 			pthread_cleanup_pop(1);
-			if (r == PATHINFO_OK)
+			if (r == PATHINFO_OK && !prev_mpp)
 				ret = ev_add_path(pp, vecs, need_do_map);
-			else if (r == PATHINFO_SKIPPED) {
+			else if (r == PATHINFO_OK &&
+				 !strncmp(pp->wwid, prev_mpp->wwid, WWID_SIZE)) {
+				/*
+				 * Path was unsuccessfully removed, but now
+				 * re-added, and still belongs to the right map
+				 * - all fine, reinstate asap
+				 */
+				pp->mpp = prev_mpp;
+				pp->tick = 1;
+				ret = 0;
+			} else if (prev_mpp) {
+				/*
+				 * Bad: re-added path still hangs in wrong map
+				 * Make another attempt to remove the path
+				 */
+				pp->mpp = prev_mpp;
+				ret = ev_remove_path(pp, vecs, true);
+				if (r == PATHINFO_OK && !ret)
+					/*
+					 * Path successfully freed, move on to
+					 * "new path" code path below
+					 */
+					pp = NULL;
+				else {
+					/*
+					 * Failure in ev_remove_path will keep
+					 * path in pathvec in INIT_REMOVED state
+					 * Fail the path to make sure it isn't
+					 * used any more.
+					 */
+					pp->dmstate = PSTATE_FAILED;
+					dm_fail_path(pp->mpp->alias, pp->dev_t);
+					condlog(1, "%s: failed to re-add path still mapped in %s",
+						pp->dev, pp->mpp->alias);
+				}
+			} else if (r == PATHINFO_SKIPPED) {
 				condlog(3, "%s: remove blacklisted path",
 					uev->kernel);
 				i = find_slot(vecs->pathvec, (void *)pp);
-- 
2.28.0

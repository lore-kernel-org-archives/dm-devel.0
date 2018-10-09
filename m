From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 14/19] multipathd: function return value tweaks
Date: Tue,  9 Oct 2018 18:03:11 -0500
Message-ID: <1539126196-28926-15-git-send-email-bmarzins@redhat.com>
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

In cli_add_map() the return value of get_refwwid is never used, and
refwwid is checked to see if the function returned successfully, so the
return value doesn't need to be saved.

In resize_map, if setup_map fails, multipathd shouldn't attempt to
create the device with resulting params string. It should just fail
instead. Found by coverity.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 5682b5c..bb16472 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -796,8 +796,8 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 		if (!alias && !count) {
 			condlog(2, "%s: mapname not found for %d:%d",
 				param, major, minor);
-			rc = get_refwwid(CMD_NONE, param, DEV_DEVMAP,
-					 vecs->pathvec, &refwwid);
+			get_refwwid(CMD_NONE, param, DEV_DEVMAP,
+				    vecs->pathvec, &refwwid);
 			if (refwwid) {
 				if (coalesce_paths(vecs, NULL, refwwid,
 						   FORCE_RELOAD_NONE, CMD_NONE))
@@ -881,7 +881,12 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 
 	mpp->size = size;
 	update_mpp_paths(mpp, vecs->pathvec);
-	setup_map(mpp, params, PARAMS_SIZE, vecs);
+	if (setup_map(mpp, params, PARAMS_SIZE, vecs) != 0) {
+		condlog(0, "%s: failed to setup map for resize : %s",
+			mpp->alias, strerror(errno));
+		mpp->size = orig_size;
+		return 1;
+	}
 	mpp->action = ACT_RESIZE;
 	mpp->force_udev_reload = 1;
 	if (domap(mpp, params, 1) <= 0) {
-- 
2.7.4

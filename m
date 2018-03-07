From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH RESEND 3/4] libmultipath: uev_update_path: always
	warn if WWID changed
Date: Thu,  8 Mar 2018 00:21:51 +0100
Message-ID: <20180307232152.15538-4-mwilck@suse.com>
References: <20180307232152.15538-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307232152.15538-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Print the warning about changed WWID not only if disable_changed_wwids
is set, but always. It's actually more dangerous if that option is
not set.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f85995810950..e9668205ce92 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -940,15 +940,18 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp) {
 		struct multipath *mpp = pp->mpp;
+		char wwid[WWID_SIZE];
 
-		if (disable_changed_wwids &&
-		    (strlen(pp->wwid) || pp->wwid_changed)) {
-			char wwid[WWID_SIZE];
+		strcpy(wwid, pp->wwid);
+		get_uid(pp, pp->state, uev->udev);
 
-			strcpy(wwid, pp->wwid);
-			get_uid(pp, pp->state, uev->udev);
-			if (strcmp(wwid, pp->wwid) != 0) {
-				condlog(0, "%s: path wwid changed from '%s' to '%s'. disallowing", uev->kernel, wwid, pp->wwid);
+		if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+			condlog(0, "%s: path wwid changed from '%s' to '%s'. %s",
+				uev->kernel, wwid, pp->wwid,
+				(disable_changed_wwids ? "disallowing" :
+				 "continuing"));
+			if (disable_changed_wwids &&
+			    (strlen(wwid) || pp->wwid_changed)) {
 				strcpy(pp->wwid, wwid);
 				if (!pp->wwid_changed) {
 					pp->wwid_changed = 1;
@@ -957,7 +960,9 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 						dm_fail_path(pp->mpp->alias, pp->dev_t);
 				}
 				goto out;
-			} else
+			} else if (!disable_changed_wwids)
+				strcpy(pp->wwid, wwid);
+			else
 				pp->wwid_changed = 0;
 		}
 
-- 
2.16.1

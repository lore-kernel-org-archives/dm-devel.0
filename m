From: mwilck@suse.com
Subject: [PATCH 33/35] multipathd: remove set_multipath_wwid()
Date: Thu,  9 Jul 2020 12:16:18 +0200
Message-ID: <20200709101620.6786-34-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

This function was only called from one place. Making the dm_get_uuid
call explicit there makes the code more obvious.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f014d2a..40c050b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -400,15 +400,6 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 	remove_maps(vecs);
 }
 
-static void
-set_multipath_wwid (struct multipath * mpp)
-{
-	if (strlen(mpp->wwid))
-		return;
-
-	dm_get_uuid(mpp->alias, mpp->wwid, WWID_SIZE);
-}
-
 int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 		      int reset)
 {
@@ -552,7 +543,10 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 		condlog(3, "%s: cannot access table", mpp->alias);
 		goto out;
 	}
-	set_multipath_wwid(mpp);
+	if (!strlen(mpp->wwid))
+		dm_get_uuid(mpp->alias, mpp->wwid, WWID_SIZE);
+	if (!strlen(mpp->wwid))
+		condlog(1, "%s: adding map with empty WWID", mpp->alias);
 	conf = get_multipath_config();
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	put_multipath_config(conf);
-- 
2.26.2

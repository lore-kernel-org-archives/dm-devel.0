From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 09/24] libmultipath: increase log level of map
	removal
Date: Mon, 10 Dec 2018 10:49:44 +0100
Message-ID: <20181210094959.11338-10-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This is an important event which we want to see with -v3.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 6 +++---
 multipathd/main.c          | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index e28a88ac..01391d77 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -113,8 +113,6 @@ remove_map(struct multipath * mpp, struct vectors * vecs, int purge_vec)
 {
 	int i;
 
-	condlog(4, "%s: remove multipath map", mpp->alias);
-
 	/*
 	 * clear references to this map
 	 */
@@ -134,8 +132,10 @@ void
 remove_map_by_alias(const char *alias, struct vectors * vecs, int purge_vec)
 {
 	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, alias);
-	if (mpp)
+	if (mpp) {
+		condlog(2, "%s: removing map by alias", alias);
 		remove_map(mpp, vecs, purge_vec);
+	}
 }
 
 void
diff --git a/multipathd/main.c b/multipathd/main.c
index e07ef502..85055993 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -334,6 +334,7 @@ remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs)
 {
 	/* devices are automatically removed by the dmevent polling code,
 	 * so they don't need to be manually removed here */
+	condlog(3, "%s: removing map from internal tables", mpp->alias);
 	if (!poll_dmevents)
 		stop_waiter_thread(mpp, vecs);
 	remove_map(mpp, vecs, PURGE_VEC);
-- 
2.19.2

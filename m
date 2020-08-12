From: mwilck@suse.com
Subject: [PATCH v2 64/74] libmultipath: orphan_paths(): avoid BUG
	message
Date: Wed, 12 Aug 2020 13:35:08 +0200
Message-ID: <20200812113511.26469-6-mwilck@suse.com>
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

Since c44d769, we print a BUG message when we orphan a path that
holds the mpp->hwe pointer. But if this called via orphan_paths(),
this is expected and we shouldn't warn.

Fixes: c44d769 ("libmultipath: warn if freeing path that holds mpp->hwe")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index ba3165a..b644d3f 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -124,6 +124,8 @@ void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 	int i;
 	struct path * pp;
 
+	/* Avoid BUG message from orphan_path() */
+	mpp->hwe = NULL;
 	vector_foreach_slot (pathvec, pp, i) {
 		if (pp->mpp == mpp) {
 			if (pp->initialized == INIT_REMOVED) {
-- 
2.28.0

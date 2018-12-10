From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 15/24] libmultipath: adopt_paths: check for
	size match
Date: Mon, 10 Dec 2018 10:49:50 +0100
Message-ID: <20181210094959.11338-16-mwilck@suse.com>
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

In coalesce_paths() and ev_add_path(), we check for size mismatch.
We should do it here, too.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 01391d77..5305bd31 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -60,6 +60,12 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 
 	vector_foreach_slot (pathvec, pp, i) {
 		if (!strncmp(mpp->wwid, pp->wwid, WWID_SIZE)) {
+			if (pp->size != 0 && mpp->size != 0 &&
+			    pp->size != mpp->size) {
+				condlog(3, "%s: size mismatch for %s, not adding path",
+					pp->dev, mpp->alias);
+				continue;
+			}
 			condlog(3, "%s: ownership set to %s",
 				pp->dev, mpp->alias);
 			pp->mpp = mpp;
-- 
2.19.2

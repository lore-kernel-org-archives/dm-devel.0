From: mwilck@suse.com
Subject: [PATCH 2/4] libmultipath: warn if freeing path that
	holds mpp->hwe
Date: Mon, 13 Jul 2020 13:07:41 +0200
Message-ID: <20200713110743.26329-3-mwilck@suse.com>
References: <20200713110743.26329-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200713110743.26329-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng@huawei.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This just adds an error message to the previous patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 9bbe5d1..0a73d2a 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -93,8 +93,11 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 void orphan_path(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
-	if (pp->mpp && pp->mpp->hwe == pp->hwe)
+	if (pp->mpp && pp->hwe && pp->mpp->hwe == pp->hwe) {
+		condlog(0, "BUG: orphaning path %s that holds hwe of %s",
+			pp->dev, pp->mpp->alias);
 		pp->mpp->hwe = NULL;
+	}
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
-- 
2.26.2

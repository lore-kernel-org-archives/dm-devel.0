From: mwilck@suse.com
Subject: [PATCH 4/4] libmultipath: fix mpp->hwe handling in
	sync_paths()
Date: Mon, 13 Jul 2020 13:07:43 +0200
Message-ID: <20200713110743.26329-5-mwilck@suse.com>
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

This is anologous to

1f96269 ("multipathd: fix mpp->hwe handling on path removal")
f6839eb ("multipathd: fix mpp->hwe handling when paths are freed")

When paths are removed from a map, we need to make sure that
mpp->hwe doesn't become stale.

Reported-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 0a73d2a..0519996 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -256,6 +256,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 		}
 		if (!found) {
 			condlog(3, "%s dropped path %s", mpp->alias, pp->dev);
+			if (mpp->hwe == pp->hwe)
+				mpp->hwe = NULL;
 			vector_del_slot(mpp->paths, i--);
 			orphan_path(pp, "path removed externally");
 		}
@@ -263,6 +265,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 	update_mpp_paths(mpp, pathvec);
 	vector_foreach_slot (mpp->paths, pp, i)
 		pp->mpp = mpp;
+	if (mpp->hwe == NULL)
+		extract_hwe_from_path(mpp);
 }
 
 int
-- 
2.26.2

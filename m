From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 04/16] libmultipath: should_multipath: keep
	existing maps
Date: Fri, 19 Jan 2018 01:29:04 +0100
Message-ID: <20180119002916.10323-5-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If with find_multipaths and !ignore_new_devs, if a path is already
multipathed, keep it. The same logic is applied in multipath -u
with ignore_wwids.
---
 libmultipath/wwids.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index fcbf5281b491..828a3de5b5cb 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -287,6 +287,13 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
 	if (!ignore_new_devs) {
+		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
+
+		if (mp != NULL && first_path(mp) != NULL) {
+			condlog(3, "wwid %s is already multipathed, keeping it",
+				pp1->wwid);
+			return 1;
+		}
 		vector_foreach_slot(pathvec, pp2, i) {
 			if (pp1->dev == pp2->dev)
 				continue;
-- 
2.15.1

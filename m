From: zhang.kai16@zte.com.cn
Subject: [PATCH] libmultipath:fix loop traversed partly
Date: Thu, 14 Jul 2016 20:09:33 +0800
Message-ID: <1468498173-8328-1-git-send-email-zhang.kai16@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: "zhang.kai" <zhang.kai16@zte.com.cn>, dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

From: "zhang.kai" <zhang.kai16@zte.com.cn>

Problem:
With each iteration of the vector_foreach_slot() loop statement,
some slots couldn't be traversed when a slot is deleted from vector.

Reasons:
Currently,loop's index 'i' is not decremented correspondingly when a slot is
deleted from vector.Meanwhile, in the vector_foreach_slot() loop, mpp is assigned
from vector newmp directly, so find_slot() could be omitted.

Signed-off-by: zhang.kai <zhang.kai16@zte.com.cn>
---
 libmultipath/configure.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a9b9cf0..c06a3df 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -924,16 +924,14 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 	if (newmp) {
 		vector_foreach_slot (newmp, mpp, i) {
 			char alias[WWID_SIZE];
-			int j;
 
 			if (!deadmap(mpp))
 				continue;
 
 			strncpy(alias, mpp->alias, WWID_SIZE - 1);
 
-			if ((j = find_slot(newmp, (void *)mpp)) != -1)
-				vector_del_slot(newmp, j);
-
+			vector_del_slot(newmp, i);
+			i--;
 			remove_map(mpp, vecs, 0);
 
 			if (dm_flush_map(alias))
-- 
2.8.1.windows.1

--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.

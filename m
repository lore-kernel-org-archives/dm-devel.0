From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/39] libmultipath: memory leak in
	add_map_without_path()
Date: Thu, 16 Jun 2016 11:47:12 +0200
Message-ID: <1466070465-1021-7-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

If we call add_map_without_path() with an empty alias the
mpp structure is never freed.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/structs_vec.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index e992b54..20a7457 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -414,8 +414,12 @@ add_map_without_path (struct vectors * vecs, char * alias)
 {
 	struct multipath * mpp = alloc_multipath();
 
-	if (!mpp || !alias)
+	if (!mpp)
+		return NULL;
+	if (!alias) {
+		FREE(mpp);
 		return NULL;
+	}
 
 	mpp->alias = STRDUP(alias);
 
-- 
2.6.6

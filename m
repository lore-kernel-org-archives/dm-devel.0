From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 01/12] Fix memory issues in path reordering
	failure code paths
Date: Mon, 30 Jun 2014 00:13:52 -0500
Message-ID: <1404105243-5071-2-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

There were some possible NULL pointer dereferences and multiple frees
in the failure code paths of the path reordering code.  This patch
cleans them up.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3ed6b55..6ad7a80 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -160,8 +160,16 @@ int order_paths_in_pg_by_alt_adapters(struct pathgroup *pgp, vector adapters,
 
 	while (total_paths > 0) {
 		agp = VECTOR_SLOT(adapters, next_adapter_index);
+		if (!agp) {
+			condlog(0, "can't get adapter group %d", next_adapter_index);
+			return 1;
+		}
 
 		hgp = VECTOR_SLOT(agp->host_groups, agp->next_host_index);
+		if (!hgp) {
+			condlog(0, "can't get host group %d of adapter group %d", next_adapter_index, agp->next_host_index);
+			return 1;
+		}
 
 		if (!hgp->num_paths) {
 			agp->next_host_index++;
@@ -223,8 +231,8 @@ int rr_optimize_path_order(struct pathgroup *pgp)
 	/* group paths in path group by host adapters
 	 */
 	if (group_by_host_adapter(pgp, adapters)) {
+		/* already freed adapters */
 		condlog(3, "Failed to group paths by adapters");
-		free_adaptergroup(adapters);
 		return 0;
 	}
 
-- 
1.8.3.1

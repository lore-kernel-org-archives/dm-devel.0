From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/12] libmultipath: don't treat multi-linear
	mappings as partitions
Date: Mon, 15 May 2017 17:37:18 +0200
Message-ID: <20170515153722.11508-9-mwilck@suse.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm_type is used in libmultipath only to check whether a mapping
is "linear", with the intention to test if it represents a
"partition". This test returns TRUE also for mappings with
multiple targets, the first of which happens to be a linear
mapping into the target device. This is questionable, it's
hard to assign a "type" to such maps anyway.

Fix this by returning an error for multi-target maps.
This is analogous to the patch
"kpartx: don't treat multi-linear mappings as partitions".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5fb9d9ac..c19dcb62 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -572,7 +572,7 @@ out:
  * returns:
  *    1 : match
  *    0 : no match
- *   -1 : empty map
+ *   -1 : empty map, or more than 1 target
  */
 int dm_type(const char *name, char *type)
 {
@@ -594,10 +594,11 @@ int dm_type(const char *name, char *type)
 		goto out;
 
 	/* Fetch 1st target */
-	dm_get_next_target(dmt, NULL, &start, &length,
-			   &target_type, &params);
-
-	if (!target_type)
+	if (dm_get_next_target(dmt, NULL, &start, &length,
+			       &target_type, &params) != NULL)
+		/* multiple targets */
+		r = -1;
+	else if (!target_type)
 		r = -1;
 	else if (!strcmp(target_type, type))
 		r = 1;
@@ -1185,9 +1186,9 @@ do_foreach_partmaps (const char * mapname,
 	do {
 		if (
 		    /*
-		     * if devmap target is "linear"
+		     * if there is only a single "linear" target
 		     */
-		    (dm_type(names->name, TGT_PART) > 0) &&
+		    (dm_type(names->name, TGT_PART) == 1) &&
 
 		    /*
 		     * and both uuid end with same suffix starting
-- 
2.12.2

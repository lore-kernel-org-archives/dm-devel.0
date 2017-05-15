From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/12] kpartx: remove "no_partitions" support
Date: Mon, 15 May 2017 17:37:12 +0200
Message-ID: <20170515153722.11508-3-mwilck@suse.com>
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

The kernel does not support the "no_partitions" feature - remove it.
Distributions who want to keep support for this feature should
re-enable it with a distro-specific patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 29 -----------------------------
 kpartx/kpartx.c    |  5 -----
 2 files changed, 34 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index cf6650c6..8aca9592 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -542,32 +542,3 @@ dm_remove_partmaps (char * mapname, char *uuid, int verbose)
 	struct remove_data rd = { verbose };
 	return do_foreach_partmaps(mapname, uuid, remove_partmap, &rd);
 }
-
-#define FEATURE_NO_PART "no_partitions"
-
-int
-dm_no_partitions(char *mapname)
-{
-	char params[PARAMS_SIZE], *ptr;
-	int i, num_features;
-
-	if (dm_get_map(mapname, params))
-		return 0;
-
-	ptr = params;
-	num_features = strtoul(params, &ptr, 10);
-	if ((ptr == params) || num_features == 0) {
-		/* No features found, return success */
-		return 0;
-	}
-	for (i = 0; (i < num_features); i++) {
-		if (!ptr || ptr > params + strlen(params))
-			break;
-		/* Skip whitespaces */
-		while(ptr && *ptr == ' ') ptr++;
-		if (!strncmp(ptr, FEATURE_NO_PART, strlen(FEATURE_NO_PART)))
-			return 1;
-		ptr = strchr(ptr, ' ');
-	}
-	return 0;
-}
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 58e60ffe..e0c105f4 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -362,11 +362,6 @@ main(int argc, char **argv){
 
 	if (!mapname)
 		mapname = device + off;
-	if (!force_devmap &&
-		 dm_no_partitions(mapname)) {
-		/* Feature 'no_partitions' is set, return */
-		return 0;
-	}
 
 	if (delim == NULL) {
 		delim = malloc(DELIM_SIZE);
-- 
2.12.2

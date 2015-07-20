From: Tejaswini Poluri <tpoluri@mvista.com>
Subject: [PATCH 1/2] multipathd: Fixing add map functionality
Date: Mon, 20 Jul 2015 14:59:31 +0530
Message-ID: <1437384572-23106-1-git-send-email-tpoluri@mvista.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Tejaswini Poluri <tpoluri@mvista.com>
List-Id: dm-devel.ids

Add map feature of multipathd tools fails as the device
is also been completely removed along with removing the map
in the remove map code.
So when add map is called we are creating the device again
in cli_add_map() using the coloasce_paths code.

Signed-off-by: Tejaswini Poluri <tpoluri@mvista.com>
---
 multipathd/cli_handlers.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index dc96c45..032a789 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -535,7 +535,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, MAP);
 	int major, minor;
 	char dev_path[PATH_SIZE];
-	char *alias;
+	char *alias, *refwwid;
 	int rc;
 
 	param = convert_dev(param, 0);
@@ -545,27 +545,33 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 		*reply = strdup("blacklisted\n");
 		*len = strlen(*reply) + 1;
 		condlog(2, "%s: map blacklisted", param);
-		return 0;
+		return 1;
 	}
+mapname:
 	minor = dm_get_minor(param);
 	if (minor < 0) {
 		condlog(2, "%s: not a device mapper table", param);
-		return 0;
 	}
 	major = dm_get_major(param);
 	if (major < 0) {
 		condlog(2, "%s: not a device mapper table", param);
-		return 0;
 	}
 	sprintf(dev_path,"dm-%d", minor);
 	alias = dm_mapname(major, minor);
 	if (!alias) {
 		condlog(2, "%s: mapname not found for %d:%d",
 			param, major, minor);
-		return 0;
+		rc = get_refwwid(param, DEV_DEVMAP, vecs->pathvec, &refwwid);
+		if (refwwid) {
+			if (coalesce_paths(vecs, NULL, refwwid, 0))
+				condlog(2, "%s: coalesce_paths failed", param);
+			dm_lib_release();
+		}
+		goto mapname;
 	}
 	rc = ev_add_map(dev_path, alias, vecs);
 	FREE(alias);
+	FREE(refwwid);
 	return rc;
 }
 
-- 
1.9.1

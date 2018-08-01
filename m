From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 13/32] kpartx: Fix memory leak of uuid found by
	coverity
Date: Wed,  1 Aug 2018 15:56:59 -0500
Message-ID: <1533157038-3924-14-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

After the call to make_prefixed_uuid() allocs uuid, it must be freed if
dm_find_part() fails.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index f94d70e..cd33449 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -663,7 +663,7 @@ int dm_find_part(const char *parent, const char *delim, int part,
 
 	tmp = dm_find_uuid(uuid);
 	if (tmp == NULL)
-		return r;
+		goto out;
 
 	/* Sanity check on partition, see dm_foreach_partmaps */
 	if (dm_type(tmp, "linear") != 1)
@@ -689,13 +689,14 @@ int dm_find_part(const char *parent, const char *delim, int part,
 		       tmp, uuid, name);
 
 	r = dm_rename(tmp, name);
-	if (r == 0) {
-		free(uuid);
-		if (verbose)
-			fprintf(stderr, "renaming %s->%s failed\n", tmp, name);
-	} else
+	if (r == 1) {
 		*part_uuid = uuid;
+		return 1;
+	}
+	if (verbose)
+		fprintf(stderr, "renaming %s->%s failed\n", tmp, name);
 out:
+	free(uuid);
 	free(tmp);
 	return r;
 }
-- 
2.7.4

From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Substantial memory leak when large amount of
	LUNs are present.
Date: Tue, 16 Dec 2008 10:54:53 -0500
Message-ID: <1229442897-3765-2-git-send-email-konrad@virtualiron.com>
References: <1229442897-3765-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1229442897-3765-1-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

 dm_get_name() was creating a vector, populating it with multipaths,
 then only deleting the vector itself, which leaked all of the multipaths.
 If the number of LUNs (ie. multipaths) was large then the leak was equally large.

Signed-off-by: Konrad Rzeszutek <konrad@virtualiron.com>
---
 libmultipath/devmapper.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 70e10c2..a021e44 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -764,7 +764,7 @@ dm_get_name(char *uuid, char *name)
 {
 	vector vec;
 	struct multipath *mpp;
-	int i;
+	int i, rc = 0;
 
 	vec = vector_alloc();
 
@@ -772,20 +772,22 @@ dm_get_name(char *uuid, char *name)
 		return 0;
 
 	if (dm_get_maps(vec)) {
-		vector_free(vec);
-		return 0;
+		goto out;
 	}
 
 	vector_foreach_slot(vec, mpp, i) {
 		if (!strcmp(uuid, mpp->wwid)) {
-			vector_free(vec);
 			strcpy(name, mpp->alias);
-			return 1;
+			rc=1;
+			break;
 		}
 	}
-
+out:
+	vector_foreach_slot(vec, mpp, i) {
+		free_multipath(mpp, KEEP_PATHS);
+	}
 	vector_free(vec);
-	return 0;
+	return rc;
 }
 
 int
-- 
1.5.4.1

From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/39] libmultipath/devmapper.c: Remove unused
	'next' argument
Date: Thu, 16 Jun 2016 11:47:15 +0200
Message-ID: <1466070465-1021-10-git-send-email-hare@suse.de>
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

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/devmapper.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 6e675fe..f395481 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -421,7 +421,6 @@ dm_get_map(const char * name, unsigned long long * size, char * outparams)
 {
 	int r = 1;
 	struct dm_task *dmt;
-	void *next = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *params = NULL;
@@ -438,8 +437,8 @@ dm_get_map(const char * name, unsigned long long * size, char * outparams)
 		goto out;
 
 	/* Fetch 1st target */
-	next = dm_get_next_target(dmt, next, &start, &length,
-				  &target_type, &params);
+	dm_get_next_target(dmt, NULL, &start, &length,
+			   &target_type, &params);
 
 	if (size)
 		*size = length;
@@ -530,7 +529,6 @@ dm_get_status(char * name, char * outstatus)
 {
 	int r = 1;
 	struct dm_task *dmt;
-	void *next = NULL;
 	uint64_t start, length;
 	char *target_type;
 	char *status;
@@ -547,8 +545,8 @@ dm_get_status(char * name, char * outstatus)
 		goto out;
 
 	/* Fetch 1st target */
-	next = dm_get_next_target(dmt, next, &start, &length,
-				  &target_type, &status);
+	dm_get_next_target(dmt, NULL, &start, &length,
+			   &target_type, &status);
 
 	if (snprintf(outstatus, PARAMS_SIZE, "%s", status) <= PARAMS_SIZE)
 		r = 0;
@@ -571,7 +569,6 @@ dm_type(const char * name, char * type)
 {
 	int r = 0;
 	struct dm_task *dmt;
-	void *next = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *params;
@@ -588,8 +585,8 @@ dm_type(const char * name, char * type)
 		goto out;
 
 	/* Fetch 1st target */
-	next = dm_get_next_target(dmt, next, &start, &length,
-				  &target_type, &params);
+	dm_get_next_target(dmt, NULL, &start, &length,
+			   &target_type, &params);
 
 	if (!target_type)
 		r = -1;
-- 
2.6.6

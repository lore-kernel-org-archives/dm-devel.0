From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/39] libmultipath/devmapper.c: fixup possible
	buffer overflow
Date: Thu, 16 Jun 2016 11:47:44 +0200
Message-ID: <1466070465-1021-39-git-send-email-hare@suse.de>
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

Fixup possible buffer overflow in dm_reassign_table().
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/devmapper.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0223e18..926d2f5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1434,15 +1434,18 @@ out:
 void dm_reassign_deps(char *table, char *dep, char *newdep)
 {
 	char *p, *n;
-	char newtable[PARAMS_SIZE];
+	char *newtable;
 
-	strcpy(newtable, table);
+	newtable = strdup(table);
+	if (!newtable)
+		return;
 	p = strstr(newtable, dep);
 	n = table + (p - newtable);
 	strcpy(n, newdep);
 	n += strlen(newdep);
 	p += strlen(dep);
 	strcat(n, p);
+	free(newtable);
 }
 
 int dm_reassign_table(const char *name, char *old, char *new)
@@ -1451,7 +1454,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
 	uint64_t start, length;
 	struct dm_task *dmt, *reload_dmt;
 	char *target, *params = NULL;
-	char buff[PARAMS_SIZE];
+	char *buff;
 	void *next = NULL;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_TABLE)))
@@ -1472,8 +1475,12 @@ int dm_reassign_table(const char *name, char *old, char *new)
 	do {
 		next = dm_get_next_target(dmt, next, &start, &length,
 					  &target, &params);
-		memset(buff, 0, PARAMS_SIZE);
-		strcpy(buff, params);
+		buff = strdup(params);
+		if (!buff) {
+			condlog(3, "%s: failed to replace target %s, "
+				"out of memory", name, target);
+			goto out_reload;
+		}
 		if (strcmp(target, TGT_MPATH) && strstr(params, old)) {
 			condlog(3, "%s: replace target %s %s",
 				name, target, buff);
@@ -1483,6 +1490,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
 			modified++;
 		}
 		dm_task_add_target(reload_dmt, start, length, target, buff);
+		free(buff);
 	} while (next);
 
 	if (modified) {
-- 
2.6.6

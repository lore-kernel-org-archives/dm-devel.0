From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/6] libmultipath: cleanup rlookup_binding
Date: Fri, 12 Sep 2014 12:44:47 -0500
Message-ID: <1410543892-29826-2-git-send-email-bmarzins@redhat.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
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

Before the use_existing_alias() code was added, the scan_device() call in
rlookup_binding always failed, complicated the function and was completely
pointless. Now it has a use, but only when called by use_existing_alias().
Instead of doing this extra work in rlookup_binding() this patch makes
use_existing_alias call scan_device() itself when necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c   | 29 ++++++++++++++---------------
 libmultipath/propsel.c |  2 +-
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index f1879c9..f2859b0 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -149,13 +149,11 @@ rlookup_binding(FILE *f, char *buff, char *map_alias, char *prefix)
 {
 	char line[LINE_MAX];
 	unsigned int line_nr = 0;
-	int id = 0;
 
 	buff[0] = '\0';
 
 	while (fgets(line, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
-		int curr_id;
 
 		line_nr++;
 		c = strpbrk(line, "#\n\r");
@@ -164,9 +162,6 @@ rlookup_binding(FILE *f, char *buff, char *map_alias, char *prefix)
 		alias = strtok(line, " \t");
 		if (!alias) /* blank line */
 			continue;
-		curr_id = scan_devname(alias, prefix);
-		if (curr_id >= id)
-			id = curr_id + 1;
 		wwid = strtok(NULL, " \t");
 		if (!wwid){
 			condlog(3,
@@ -184,16 +179,12 @@ rlookup_binding(FILE *f, char *buff, char *map_alias, char *prefix)
 				"\nSetting wwid to %s", alias, wwid);
 			strncpy(buff, wwid, WWID_SIZE);
 			buff[WWID_SIZE - 1] = '\0';
-			return id;
+			return 0;
 		}
 	}
 	condlog(3, "No matching alias [%s] in bindings file.", map_alias);
 
-	/* Get the theoretical id for this map alias.
-	 * Used by use_existing_alias
-	 */
-	id = scan_devname(map_alias, prefix);
-	return id;
+	return -1;
 }
 
 static char *
@@ -264,9 +255,7 @@ use_existing_alias (char *wwid, char *file, char *alias_old,
 	/* lookup the binding. if it exsists, the wwid will be in buff
 	 * either way, id contains the id for the alias
 	 */
-	id = rlookup_binding(f , buff,  alias_old, prefix);
-	if (id < 0)
-		goto out;
+	rlookup_binding(f, buff, alias_old, prefix);
 
 	if (strlen(buff) > 0) {
 		/* if buff is our wwid, it's already
@@ -283,7 +272,17 @@ use_existing_alias (char *wwid, char *file, char *alias_old,
 	}
 
 	/* allocate the existing alias in the bindings file */
-	if (can_write && id && !bindings_read_only) {
+	id = scan_devname(alias_old, prefix);
+	if (id <= 0)
+		goto out;
+
+	if (fflush(f) != 0) {
+		condlog(0, "cannot fflush bindings file stream : %s",
+			strerror(errno));
+		goto out;
+	}
+
+	if (can_write && !bindings_read_only) {
 		alias = allocate_binding(fd, wwid, id, prefix);
 		condlog(0, "Allocated existing binding [%s] for WWID [%s]",
 			alias, wwid);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index e23d65c..7a966bb 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -269,7 +269,7 @@ select_alias (struct multipath * mp)
 				mp->alias_old, mp->alias_prefix,
 				conf->bindings_read_only);
 		memset (mp->alias_old, 0, WWID_SIZE);
-	} 
+	}
 
 	if (mp->alias == NULL)
 		mp->alias = get_user_friendly_alias(mp->wwid,
-- 
1.8.3.1

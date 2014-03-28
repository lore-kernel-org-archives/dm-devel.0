From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH] libmultipath: Use existing user friendly name if
	possible
Date: Fri, 28 Mar 2014 21:01:14 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF24AC9EB61@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

When a system is booted to the SAN, a condition can occur where one
user friendly name is given to a disk during boot, but multipathd tries
to allocate a different one after boot. If the second alias is already
used by another device, multipathd can't rename it. Multipathd then has
incorrect information about the alias/wwid relationships, which can
result in paths being added to the wrong map.

This patch works around this problem by first trying to use the alias
already bound to a device during boot.  If the bindings file has that
alias bound to a different device, it'll auto generate a new alias to
rename it to.

The alias prioritization is:
1. multipath.conf per-device alias
2. Currently bound alias
3. New auto-generated alias
4. wwid

Signed-off-by: Sean Stewart <sean.stewart@netapp.com>
Reviewed-by: Shiva Krishna Merla <shivakrishna.merla@netapp.com>
---
 libmultipath/alias.c       | 64 +++++++++++++++++++++++++++++++++++++++++++---
 libmultipath/alias.h       |  2 ++
 libmultipath/propsel.c     | 32 +++++++++++++++--------
 libmultipath/structs_vec.c | 15 +++++++++++
 4 files changed, 100 insertions(+), 13 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index ab15185..008396e 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -145,7 +145,7 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 }
 
 static int
-rlookup_binding(FILE *f, char *buff, char *map_alias)
+rlookup_binding(FILE *f, char *buff, char *map_alias, char *prefix)
 {
 	char line[LINE_MAX];
 	unsigned int line_nr = 0;
@@ -164,7 +164,7 @@ rlookup_binding(FILE *f, char *buff, char *map_alias)
 		alias = strtok(line, " \t");
 		if (!alias) /* blank line */
 			continue;
-		curr_id = scan_devname(alias, NULL); /* TBD: Why this call? */
+		curr_id = scan_devname(alias, prefix);
 		if (curr_id >= id)
 			id = curr_id + 1;
 		wwid = strtok(NULL, " \t");
@@ -188,6 +188,11 @@ rlookup_binding(FILE *f, char *buff, char *map_alias)
 		}
 	}
 	condlog(3, "No matching alias [%s] in bindings file.", map_alias);
+
+	/* Get the theoretical id for this map alias.
+	 * Used by use_existing_alias
+	 */
+	id = scan_devname(map_alias, prefix);
 	return id;
 }
 
@@ -237,6 +242,59 @@ allocate_binding(int fd, char *wwid, int id, char *prefix)
 }
 
 char *
+use_existing_alias (char *wwid, char *file, char *alias_old,
+		char *prefix, int bindings_read_only)
+{
+	char *alias = NULL;
+	int id = 0;
+	int fd, can_write;
+	char buff[WWID_SIZE];
+	FILE *f;
+
+	fd = open_file(file, &can_write, BINDINGS_FILE_HEADER);
+	if (fd < 0)
+		return NULL;
+
+	f = fdopen(fd, "r");
+	if (!f) {
+		condlog(0, "cannot fdopen on bindings file descriptor");
+		close(fd);
+		return NULL;
+	}
+	/* lookup the binding. if it exsists, the wwid will be in buff
+	 * either way, id contains the id for the alias
+	 */
+	id = rlookup_binding(f , buff,  alias_old, prefix);
+	if (id < 0)
+		goto out;
+
+	if (strlen(buff) > 0) {
+		/* if buff is our wwid, it's already
+		 * allocated correctly
+		 */
+		if (strcmp(buff, wwid) == 0)
+			alias = STRDUP(alias_old);
+		else {
+			alias = NULL;
+			condlog(0, "alias %s already bound to wwid %s, cannot reuse",
+				alias_old, buff);
+		}
+		goto out;	
+	}
+
+	/* allocate the existing alias in the bindings file */
+	if (can_write && id && !bindings_read_only) {
+		alias = allocate_binding(fd, wwid, id, prefix);
+		condlog(0, "Allocated existing binding [%s] for WWID [%s]",
+			alias, wwid);
+	}
+
+out:
+	fclose(f);
+	return alias;
+}
+
+char *
 get_user_friendly_alias(char *wwid, char *file, char *prefix,
 			int bindings_read_only)
 {
@@ -305,7 +363,7 @@ get_user_friendly_wwid(char *alias, char *buff, char *file)
 		return -1;
 	}
 
-	rlookup_binding(f, buff, alias);
+	rlookup_binding(f, buff, alias, NULL);
 	if (!strlen(buff)) {
 		fclose(f);
 		return -1;
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index 8ddd0b5..9cb3e8f 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -10,3 +10,5 @@
 char *get_user_friendly_alias(char *wwid, char *file, char *prefix,
 			      int bindings_readonly);
 int get_user_friendly_wwid(char *alias, char *buff, char *file);
+char *use_existing_alias (char *wwid, char *file, char *alias_old,
+		char *prefix, int bindings_read_only);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 7b7944d..2859e3e 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -253,19 +253,31 @@ want_user_friendly_names(struct multipath * mp)
 extern int
 select_alias (struct multipath * mp)
 {
-	if (mp->mpe && mp->mpe->alias)
+	if (mp->mpe && mp->mpe->alias) {
 		mp->alias = STRDUP(mp->mpe->alias);
-	else {
-		mp->alias = NULL;
-		if (want_user_friendly_names(mp)) {
-			select_alias_prefix(mp);
-			mp->alias = get_user_friendly_alias(mp->wwid,
-					conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
-		}
-		if (mp->alias == NULL)
-			mp->alias = STRDUP(mp->wwid);
+		goto out;
 	}
 
+	mp->alias = NULL;
+	if (!want_user_friendly_names(mp))
+		goto out;
+
+	select_alias_prefix(mp);
+	
+	if (strlen(mp->alias_old) > 0) {
+		mp->alias = use_existing_alias(mp->wwid, conf->bindings_file,
+				mp->alias_old, mp->alias_prefix,
+				conf->bindings_read_only);
+		memset (mp->alias_old, 0, WWID_SIZE);
+	} 
+
+	if (mp->alias == NULL)
+		mp->alias = get_user_friendly_alias(mp->wwid,
+				conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
+out:
+	if (mp->alias == NULL)
+		mp->alias = STRDUP(mp->wwid);
+
 	return mp->alias ? 0 : 1;
 }
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 76c7e02..8cdbe3d 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -403,6 +403,20 @@ out:
 	return NULL;
 }
 
+static void
+find_existing_alias (struct multipath * mpp,
+		     struct vectors *vecs)
+{
+	struct multipath * mp;
+	int i;
+
+	vector_foreach_slot (vecs->mpvec, mp, i)
+		if (strcmp(mp->wwid, mpp->wwid) == 0) {
+			strncpy(mpp->alias_old, mp->alias, WWID_SIZE);
+			return;
+		}
+}
+
 extern struct multipath *
 add_map_with_path (struct vectors * vecs,
 		   struct path * pp, int add_vec)
@@ -416,6 +430,7 @@ add_map_with_path (struct vectors * vecs,
 	mpp->hwe = pp->hwe;
 
 	strcpy(mpp->wwid, pp->wwid);
+	find_existing_alias(mpp, vecs);
 	if (select_alias(mpp))
 		goto out;
 	mpp->size = pp->size;
-- 
1.8.3.1

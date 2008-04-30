From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Use 'mpatha' for user_friendly_names option
Date: Wed, 30 Apr 2008 11:03:29 +0200
Message-ID: <20080430090329.CAC0718C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


We really should use 'mpatha' instead of 'mpath0' for the
generated names with the user_friendly_names option.
Otherwise we can't distinguish them from EVMS names.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/alias.c |   61 +++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index ca434fe..517b055 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -179,6 +179,46 @@ fail:
 	return -1;
 }
 
+static int
+format_devname(char *name, int id, int len)
+{
+	int pos;
+
+	memset(name,0, len);
+	strcpy(name,"mpath");
+	for (pos = len - 1; pos >= 5; pos--) {
+		name[pos] = 'a' + id % 26;
+		if (id < 26)
+			break;
+		id /= 26;
+		id--;
+	}
+	memmove(name + 5, name + pos, len - pos);
+	name[5 + len - pos] = '\0';
+	return (5 + len - pos);
+}
+
+static int
+scan_devname(char *alias)
+{
+	char *c;
+	int i, n = 0;
+
+	if (strncmp(alias, "mpath", 5))
+		return -1;
+
+	c = alias + 5;
+	while (*c != '\0' && *c != ' ' && *c != '\t') {
+		i = *c - 'a';
+		n = ( n * 26 ) + i;
+		c++;
+		if (*c < 'a' || *c > 'z')
+			break;
+		n++;
+	}
+
+	return n;
+}
 
 static int
 lookup_binding(FILE *f, char *map_wwid, char **map_alias)
@@ -200,7 +240,8 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias)
 		alias = strtok(buf, " \t");
 		if (!alias) /* blank line */
 			continue;
-		if (sscanf(alias, "mpath%d", &curr_id) == 1 && curr_id >= id)
+		curr_id = scan_devname(alias);
+		if (curr_id >= id)
 			id = curr_id + 1;
 		wwid = strtok(NULL, " \t");
 		if (!wwid){
@@ -221,7 +262,7 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias)
 	}
 	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
 	return id;
-}	
+}
 
 static int
 rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
@@ -243,7 +284,8 @@ rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
 		alias = strtok(buf, " \t");
 		if (!alias) /* blank line */
 			continue;
-		if (sscanf(alias, "mpath%d", &curr_id) == 1 && curr_id >= id)
+		curr_id = scan_devname(alias);
+		if (curr_id >= id)
 			id = curr_id + 1;
 		wwid = strtok(NULL, " \t");
 		if (!wwid){
@@ -264,7 +306,7 @@ rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
 	}
 	condlog(3, "No matching alias [%s] in bindings file.", map_alias);
 	return id;
-}	
+}
 
 static char *
 allocate_binding(int fd, char *wwid, int id)
@@ -272,13 +314,16 @@ allocate_binding(int fd, char *wwid, int id)
 	char buf[LINE_MAX];
 	off_t offset;
 	char *alias, *c;
-	
+	int i;
+
 	if (id < 0) {
 		condlog(0, "Bindings file full. Cannot allocate new binding");
 		return NULL;
 	}
-	
-	snprintf(buf, LINE_MAX, "mpath%d %s\n", id, wwid);
+
+	i = format_devname(buf, id, LINE_MAX);
+	c = buf + i;
+	snprintf(c,LINE_MAX - i, " %s\n", wwid);
 	buf[LINE_MAX - 1] = '\0';
 
 	offset = lseek(fd, 0, SEEK_END);
@@ -304,7 +349,7 @@ allocate_binding(int fd, char *wwid, int id)
 		condlog(3, "Created new binding [%s] for WWID [%s]", alias,
 			wwid);
 	return alias;
-}		
+}
 
 char *
 get_user_friendly_alias(char *wwid, char *file)
-- 
1.5.2.4

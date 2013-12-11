From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 09/16] libmultipath: try to deal with bindings
	file hand editting
Date: Wed, 11 Dec 2013 00:43:03 -0600
Message-ID: <1386744190-1295-10-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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

Unfortunately, instead of adding aliases to /etc/multipath.conf like they
should, some users add aliases to the bindings file. If they add aliases
that look like user_friendly_names, like mpathfoo, they interfere with
the code to find the next available user_friendly_name (giving you
mpathfop as the next user_friendly_name in this case).  This patch
will fix this by giving the next name available name after an unbroken
string of names starting with the smallest possible name. It order to keep
the choice quick, it won't handle situation where the list of names
starting at the smallest possible is not in order.  There are a number
of ways to do a better job finding the smallest possible name, but this
will fix most of the cases I've seen, without slowing things down at all.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index d913294..ab15185 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -46,11 +46,11 @@ format_devname(char *name, int id, int len, char *prefix)
 	memset(name,0, len);
 	strcpy(name, prefix);
 	for (pos = len - 1; pos >= prefix_len; pos--) {
+		id--;
 		name[pos] = 'a' + id % 26;
 		if (id < 26)
 			break;
 		id /= 26;
-		id--;
 	}
 	memmove(name + prefix_len, name + pos, len - pos);
 	name[prefix_len + len - pos] = '\0';
@@ -66,13 +66,22 @@ scan_devname(char *alias, char *prefix)
 	if (!prefix || strncmp(alias, prefix, strlen(prefix)))
 		return -1;
 
+	if (strlen(alias) == strlen(prefix))
+		return -1;	
+
+	if (strlen(alias) > strlen(prefix) + 7)
+		/* id of 'aaaaaaaa' overflows int */
+		return -1;
+
 	c = alias + strlen(prefix);
 	while (*c != '\0' && *c != ' ' && *c != '\t') {
+		if (*c < 'a' || *c > 'z')
+			return -1;
 		i = *c - 'a';
 		n = ( n * 26 ) + i;
+		if (n < 0)
+			return -1;
 		c++;
-		if (*c < 'a' || *c > 'z')
-			break;
 		n++;
 	}
 
@@ -84,7 +93,9 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 {
 	char buf[LINE_MAX];
 	unsigned int line_nr = 0;
-	int id = 0;
+	int id = 1;
+	int biggest_id = 1;
+	int smallest_bigger_id = INT_MAX;
 
 	*map_alias = NULL;
 
@@ -100,8 +111,12 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 		if (!alias) /* blank line */
 			continue;
 		curr_id = scan_devname(alias, prefix);
-		if (curr_id >= id)
-			id = curr_id + 1;
+		if (curr_id == id)
+			id++;
+		if (curr_id > biggest_id)
+			biggest_id = curr_id;
+		if (curr_id > id && curr_id < smallest_bigger_id)
+			smallest_bigger_id = curr_id;
 		wwid = strtok(NULL, " \t");
 		if (!wwid){
 			condlog(3,
@@ -116,11 +131,17 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 			if (*map_alias == NULL)
 				condlog(0, "Cannot copy alias from bindings "
 					"file : %s", strerror(errno));
-			return id;
+			return 0;
 		}
 	}
 	condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
-	return id;
+	if (id < 0) {
+		condlog(0, "no more available user_friendly_names");
+		return 0;
+	}
+	if (id < smallest_bigger_id)
+		return id;
+	return biggest_id + 1;
 }
 
 static int
@@ -254,7 +275,7 @@ get_user_friendly_alias(char *wwid, char *file, char *prefix,
 		return NULL;
 	}
 
-	if (!alias && can_write && !bindings_read_only)
+	if (!alias && can_write && !bindings_read_only && id)
 		alias = allocate_binding(fd, wwid, id, prefix);
 
 	fclose(f);
-- 
1.8.4.2

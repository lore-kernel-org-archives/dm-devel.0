From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 03/72] libmultipath: alias.c: constify function
	arguments
Date: Sat, 12 Oct 2019 21:27:40 +0000
Message-ID: <20191012212703.12989-4-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 29 ++++++++++++++++-------------
 libmultipath/alias.h | 12 +++++++-----
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index fd6b7f91..5b05ff69 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -37,7 +37,7 @@
  */
 
 int
-valid_alias(char *alias)
+valid_alias(const char *alias)
 {
 	if (strchr(alias, '/') != NULL)
 		return 0;
@@ -46,7 +46,7 @@ valid_alias(char *alias)
 
 
 static int
-format_devname(char *name, int id, int len, char *prefix)
+format_devname(char *name, int id, int len, const char *prefix)
 {
 	int pos;
 	int prefix_len = strlen(prefix);
@@ -66,9 +66,9 @@ format_devname(char *name, int id, int len, char *prefix)
 }
 
 static int
-scan_devname(char *alias, char *prefix)
+scan_devname(const char *alias, const char *prefix)
 {
-	char *c;
+	const char *c;
 	int i, n = 0;
 
 	if (!prefix || strncmp(alias, prefix, strlen(prefix)))
@@ -97,7 +97,8 @@ scan_devname(char *alias, char *prefix)
 }
 
 static int
-lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
+lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
+	       const char *prefix)
 {
 	char buf[LINE_MAX];
 	unsigned int line_nr = 0;
@@ -109,7 +110,8 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 
 	rewind(f);
 	while (fgets(buf, LINE_MAX, f)) {
-		char *c, *alias, *wwid;
+		const char *alias, *wwid;
+		char *c;
 		int curr_id;
 
 		line_nr++;
@@ -154,7 +156,7 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 }
 
 static int
-rlookup_binding(FILE *f, char *buff, char *map_alias, char *prefix)
+rlookup_binding(FILE *f, char *buff, const char *map_alias, const char *prefix)
 {
 	char line[LINE_MAX];
 	unsigned int line_nr = 0;
@@ -162,7 +164,8 @@ rlookup_binding(FILE *f, char *buff, char *map_alias, char *prefix)
 	buff[0] = '\0';
 
 	while (fgets(line, LINE_MAX, f)) {
-		char *c, *alias, *wwid;
+		char *c;
+		const char *alias, *wwid;
 
 		line_nr++;
 		c = strpbrk(line, "#\n\r");
@@ -197,7 +200,7 @@ rlookup_binding(FILE *f, char *buff, char *map_alias, char *prefix)
 }
 
 static char *
-allocate_binding(int fd, char *wwid, int id, char *prefix)
+allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 {
 	char buf[LINE_MAX];
 	off_t offset;
@@ -243,8 +246,8 @@ allocate_binding(int fd, char *wwid, int id, char *prefix)
 }
 
 char *
-use_existing_alias (char *wwid, char *file, char *alias_old,
-		char *prefix, int bindings_read_only)
+use_existing_alias (const char *wwid, const char *file, const char *alias_old,
+		    const char *prefix, int bindings_read_only)
 {
 	char *alias = NULL;
 	int id = 0;
@@ -311,7 +314,7 @@ out:
 }
 
 char *
-get_user_friendly_alias(char *wwid, char *file, char *prefix,
+get_user_friendly_alias(const char *wwid, const char *file, const char *prefix,
 			int bindings_read_only)
 {
 	char *alias;
@@ -358,7 +361,7 @@ get_user_friendly_alias(char *wwid, char *file, char *prefix,
 }
 
 int
-get_user_friendly_wwid(char *alias, char *buff, char *file)
+get_user_friendly_wwid(const char *alias, char *buff, const char *file)
 {
 	int fd, unused;
 	FILE *f;
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index 95473ff9..7c4b302b 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -7,9 +7,11 @@
 "# alias wwid\n" \
 "#\n"
 
-int valid_alias(char *alias);
-char *get_user_friendly_alias(char *wwid, char *file, char *prefix,
+int valid_alias(const char *alias);
+char *get_user_friendly_alias(const char *wwid, const char *file,
+			      const char *prefix,
 			      int bindings_readonly);
-int get_user_friendly_wwid(char *alias, char *buff, char *file);
-char *use_existing_alias (char *wwid, char *file, char *alias_old,
-		char *prefix, int bindings_read_only);
+int get_user_friendly_wwid(const char *alias, char *buff, const char *file);
+char *use_existing_alias (const char *wwid, const char *file,
+			  const char *alias_old,
+			  const char *prefix, int bindings_read_only);
-- 
2.23.0

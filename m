From: mwilck@suse.com
Subject: [PATCH v2 12/21] libmultipath: constify file argument in
	config parser
Date: Thu, 24 Sep 2020 15:37:07 +0200
Message-ID: <20200924133716.14120-13-mwilck@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 3 +--
 libmultipath/config.h | 2 +-
 libmultipath/parser.c | 9 +++++----
 libmultipath/parser.h | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index df0f8f4..5c91a09 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -719,8 +719,7 @@ static void set_max_checkint_from_watchdog(struct config *conf)
 }
 #endif
 
-struct config *
-load_config (char * file)
+struct config *load_config(const char *file)
 {
 	struct config *conf = alloc_config();
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 8e13ae9..116fe37 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -250,7 +250,7 @@ void free_mptable (vector mptable);
 
 int store_hwe (vector hwtable, struct hwentry *);
 
-struct config *load_config (char * file);
+struct config *load_config (const char *file);
 struct config * alloc_config (void);
 void free_config (struct config * conf);
 extern struct config *get_multipath_config(void);
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index ed6d5d6..163ffbc 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -390,7 +390,7 @@ oom:
 /* non-recursive configuration stream handler */
 static int kw_level = 0;
 
-int warn_on_duplicates(vector uniques, char *str, char *file)
+int warn_on_duplicates(vector uniques, char *str, const char *file)
 {
 	char *tmp;
 	int i;
@@ -434,7 +434,7 @@ is_sublevel_keyword(char *str)
 }
 
 int
-validate_config_strvec(vector strvec, char *file)
+validate_config_strvec(vector strvec, const char *file)
 {
 	char *str = NULL;
 	int i;
@@ -499,7 +499,8 @@ validate_config_strvec(vector strvec, char *file)
 }
 
 static int
-process_stream(struct config *conf, FILE *stream, vector keywords, char *file)
+process_stream(struct config *conf, FILE *stream, vector keywords,
+	       const char *file)
 {
 	int i;
 	int r = 0, t;
@@ -584,7 +585,7 @@ out:
 
 /* Data initialization */
 int
-process_file(struct config *conf, char *file)
+process_file(struct config *conf, const char *file)
 {
 	int r;
 	FILE *stream;
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 62906e9..06666cc 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -77,7 +77,7 @@ extern void dump_keywords(vector keydump, int level);
 extern void free_keywords(vector keywords);
 extern vector alloc_strvec(char *string);
 extern void *set_value(vector strvec);
-extern int process_file(struct config *conf, char *conf_file);
+extern int process_file(struct config *conf, const char *conf_file);
 extern struct keyword * find_keyword(vector keywords, vector v, char * name);
 int snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
 		    const void *data);
-- 
2.28.0

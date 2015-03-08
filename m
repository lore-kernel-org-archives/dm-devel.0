From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 12/15] libmultipath: cleanup parser code
Date: Sat,  7 Mar 2015 21:31:43 -0600
Message-ID: <1425785506-20419-13-git-send-email-bmarzins@redhat.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
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

read_value_block() and alloc_value_block() are completely unused, and can
go away. Also, all of the config file parsing is done it parse.c, so
there's no reason to make "stream" a global variable.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c | 101 ++++----------------------------------------------
 libmultipath/parser.h |   6 ---
 2 files changed, 8 insertions(+), 99 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index d351ab2..e4296ee 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -280,8 +280,8 @@ out:
 	return NULL;
 }
 
-int
-read_line(char *buf, int size)
+static int
+read_line(FILE *stream, char *buf, int size)
 {
 	char *p;
 
@@ -291,93 +291,6 @@ read_line(char *buf, int size)
 	return 1;
 }
 
-vector
-read_value_block(void)
-{
-	char *buf;
-	int i;
-	char *str = NULL;
-	char *dup;
-	vector vec = NULL;
-	vector elements = vector_alloc();
-
-	if (!elements)
-		return NULL;
-
-	buf = (char *) MALLOC(MAXBUF);
-
-	if (!buf) {
-		vector_free(elements);
-		return NULL;
-	}
-
-	while (read_line(buf, MAXBUF)) {
-		vec = alloc_strvec(buf);
-		if (vec) {
-			str = VECTOR_SLOT(vec, 0);
-			if (!strcmp(str, EOB)) {
-				free_strvec(vec);
-				break;
-			}
-
-			for (i = 0; i < VECTOR_SIZE(vec); i++) {
-				str = VECTOR_SLOT(vec, i);
-				dup = (char *) MALLOC(strlen(str) + 1);
-				if (!dup)
-					goto out;
-				memcpy(dup, str, strlen(str));
-
-				if (!vector_alloc_slot(elements)) {
-					free_strvec(vec);
-					goto out1;
-				}
-
-				vector_set_slot(elements, dup);
-			}
-			free_strvec(vec);
-		}
-	}
-	FREE(buf);
-	return elements;
-out1:
-	FREE(dup);
-out:
-	FREE(buf);
-	vector_free(elements);
-	return NULL;
-}
-
-int
-alloc_value_block(vector strvec, void (*alloc_func) (vector))
-{
-	char *buf;
-	char *str = NULL;
-	vector vec = NULL;
-
-	buf = (char *) MALLOC(MAXBUF);
-
-	if (!buf)
-		return 1;
-
-	while (read_line(buf, MAXBUF)) {
-		vec = alloc_strvec(buf);
-		if (vec) {
-			str = VECTOR_SLOT(vec, 0);
-			if (!strcmp(str, EOB)) {
-				free_strvec(vec);
-				break;
-			}
-
-			if (VECTOR_SIZE(vec))
-				(*alloc_func) (vec);
-
-			free_strvec(vec);
-		}
-	}
-	FREE(buf);
-	return 0;
-}
-
 void *
 set_value(vector strvec)
 {
@@ -553,7 +466,7 @@ validate_config_strvec(vector strvec, char *file)
 }
 
 static int
-process_stream(vector keywords, char *file)
+process_stream(FILE *stream, vector keywords, char *file)
 {
 	int i;
 	int r = 0, t;
@@ -574,7 +487,7 @@ process_stream(vector keywords, char *file)
 		return 1;
 	}
 
-	while (read_line(buf, MAXBUF)) {
+	while (read_line(stream, buf, MAXBUF)) {
 		line_nr++;
 		strvec = alloc_strvec(buf);
 		if (!strvec)
@@ -616,7 +529,8 @@ process_stream(vector keywords, char *file)
 
 				if (keyword->sub) {
 					kw_level++;
-					r += process_stream(keyword->sub, file);
+					r += process_stream(stream,
+							    keyword->sub, file);
 					kw_level--;
 				}
 				break;
@@ -651,6 +565,7 @@ int
 process_file(char *file)
 {
 	int r;
+	FILE *stream;
 
 	if (!keywords) {
 		condlog(0, "No keywords alocated");
@@ -665,7 +580,7 @@ process_file(char *file)
 
 	/* Stream handling */
 	line_nr = 0;
-	r = process_stream(keywords, file);
+	r = process_stream(stream, keywords, file);
 	fclose(stream);
 	//free_keywords(keywords);
 
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index bfbb3ae..ba6859e 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -47,9 +47,6 @@ struct keyword {
 	int unique;
 };
 
-/* global var exported */
-FILE *stream;
-
 /* Reloading helpers */
 #define SET_RELOAD      (reload = 1)
 #define UNSET_RELOAD    (reload = 0)
@@ -72,9 +69,6 @@ extern int _install_keyword(char *string, int (*handler) (vector),
 extern void dump_keywords(vector keydump, int level);
 extern void free_keywords(vector keywords);
 extern vector alloc_strvec(char *string);
-extern int read_line(char *buf, int size);
-extern vector read_value_block(void);
-extern int alloc_value_block(vector strvec, void (*alloc_func) (vector));
 extern void *set_value(vector strvec);
 extern int alloc_keywords(void);
 extern int process_file(char *conf_file);
-- 
1.8.3.1

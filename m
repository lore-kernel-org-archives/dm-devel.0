From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 17/18] multipathd: use 64-bit int for command
	key
Date: Thu,  7 Apr 2016 18:20:11 -0500
Message-ID: <1460071212-21018-18-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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

There are now more than 32 keywords for the multipathd client commands.
Since these are represented by a bit flags, multipathd needs more than
32 bits for the client command keycodes. However, multipath is currently
using unsigned long for these. This makes some client commands work
incorrectly on 32-bit systems. This patch switches all the keys to use
uint64_t instead.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli.c | 22 +++++++++++-----------
 multipathd/cli.h | 20 +++++++++++---------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index e0a6bec..6a5c6db 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -26,7 +26,7 @@ alloc_handler (void)
 }
 
 static int
-add_key (vector vec, char * str, unsigned long code, int has_param)
+add_key (vector vec, char * str, uint64_t code, int has_param)
 {
 	struct key * kw;
 
@@ -57,7 +57,7 @@ out:
 }
 
 int
-add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *))
+add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *))
 {
 	struct handler * h;
 
@@ -79,7 +79,7 @@ add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *))
 }
 
 static struct handler *
-find_handler (unsigned long fp)
+find_handler (uint64_t fp)
 {
 	int i;
 	struct handler *h;
@@ -92,7 +92,7 @@ find_handler (unsigned long fp)
 }
 
 int
-set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *))
+set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
 {
 	struct handler * h = find_handler(fp);
 
@@ -293,11 +293,11 @@ out:
 	return r;
 }
 
-static unsigned long 
+static uint64_t
 fingerprint(vector vec)
 {
 	int i;
-	unsigned long fp = 0;
+	uint64_t fp = 0;
 	struct key * kw;
 
 	if (!vec)
@@ -343,7 +343,7 @@ static int
 do_genhelp(char *reply, int maxlen) {
 	int len = 0;
 	int i, j;
-	unsigned long fp;
+	uint64_t fp;
 	struct handler * h;
 	struct key * kw;
 
@@ -442,7 +442,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data)
 }
 
 char *
-get_keyparam (vector v, unsigned long code)
+get_keyparam (vector v, uint64_t code)
 {
 	struct key * kw;
 	int i;
@@ -516,7 +516,7 @@ void cli_exit(void)
 }
 
 static int
-key_match_fingerprint (struct key * kw, unsigned long fp)
+key_match_fingerprint (struct key * kw, uint64_t fp)
 {
 	if (!fp)
 		return 0;
@@ -531,7 +531,7 @@ char *
 key_generator (const char * str, int state)
 {
 	static int index, len, has_param;
-	static unsigned long rlfp;	
+	static uint64_t rlfp;
 	struct key * kw;
 	int i;
 	struct handler *h;
@@ -601,7 +601,7 @@ key_generator (const char * str, int state)
 			 * nfp is the candidate fingerprint we try to
 			 * validate against all known command fingerprints.
 			 */
-			unsigned long nfp = rlfp | kw->code;
+			uint64_t nfp = rlfp | kw->code;
 			vector_foreach_slot(handlers, h, i) {
 				if (!rlfp || ((h->fingerprint & nfp) == nfp)) {
 					/*
diff --git a/multipathd/cli.h b/multipathd/cli.h
index f6d2726..2aa19d5 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -1,3 +1,5 @@
+#include <stdint.h>
+
 enum {
 	__LIST,
 	__ADD,
@@ -68,10 +70,10 @@ enum {
 #define WILDCARDS	(1 << __WILDCARDS)
 #define QUIT		(1 << __QUIT)
 #define SHUTDOWN	(1 << __SHUTDOWN)
-#define GETPRSTATUS	(1UL << __GETPRSTATUS)
-#define SETPRSTATUS	(1UL << __SETPRSTATUS)
-#define UNSETPRSTATUS	(1UL << __UNSETPRSTATUS)
-#define FMT		(1UL << __FMT)
+#define GETPRSTATUS	(1ULL << __GETPRSTATUS)
+#define SETPRSTATUS	(1ULL << __SETPRSTATUS)
+#define UNSETPRSTATUS	(1ULL << __UNSETPRSTATUS)
+#define FMT		(1ULL << __FMT)
 
 #define INITIAL_REPLY_LEN	1200
 
@@ -92,21 +94,21 @@ enum {
 struct key {
 	char * str;
 	char * param;
-	unsigned long code;
+	uint64_t code;
 	int has_param;
 };
 
 struct handler {
-	unsigned long fingerprint;
+	uint64_t fingerprint;
 	int (*fn)(void *, char **, int *, void *);
 };
 
 int alloc_handlers (void);
-int add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *));
-int set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *));
+int add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *));
+int set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
 int parse_cmd (char * cmd, char ** reply, int * len, void *);
 int load_keys (void);
-char * get_keyparam (vector v, unsigned long code);
+char * get_keyparam (vector v, uint64_t code);
 void free_keys (vector vec);
 void free_handlers (void);
 int cli_init (void);
-- 
1.8.3.1

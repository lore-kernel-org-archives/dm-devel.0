From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [RFC][PATCH 3/3] persistent management feature for
	multipath-tools
Date: Mon, 19 Dec 2011 22:05:30 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D078966D3@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@free.fr
Cc: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>, "Dachepalli,
	Sudhir" <Sudhir.Dachepalli@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

This patch fixes the 32 fingerprint limit for multipathd cli.  

Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>

---
diff -uprN multipath-tools-patched2/multipathd/cli.c multipath-tools/multipathd/cli.c
--- multipath-tools-patched2/multipathd/cli.c	2011-12-18 02:25:43.000000000 -0500
+++ multipath-tools/multipathd/cli.c	2011-12-18 02:26:09.000000000 -0500
@@ -26,7 +26,7 @@ alloc_handler (void)
 }
 
 static int
-add_key (vector vec, char * str, int code, int has_param)
+add_key (vector vec, char * str, unsigned long code, int has_param)
 {
 	struct key * kw;
 
@@ -57,7 +57,7 @@ out:
 }
 
 int
-add_handler (int fp, int (*fn)(void *, char **, int *, void *))
+add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *))
 {
 	struct handler * h;
 
@@ -92,7 +92,7 @@ find_handler (int fp)
 }
 
 int
-set_handler_callback (int fp, int (*fn)(void *, char **, int *, void *))
+set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *))
 {
 	struct handler * h = find_handler(fp);
 
diff -uprN multipath-tools-patched2/multipathd/cli.h multipath-tools/multipathd/cli.h
--- multipath-tools-patched2/multipathd/cli.h	2011-12-18 02:25:43.000000000 -0500
+++ multipath-tools/multipathd/cli.h	2011-12-18 02:26:09.000000000 -0500
@@ -65,9 +65,9 @@ enum {
 #define WILDCARDS	(1 << __WILDCARDS)
 #define QUIT		(1 << __QUIT)
 #define SHUTDOWN	(1 << __SHUTDOWN)
-#define GETPRSTATUS    (1 << __GETPRSTATUS)
-#define SETPRSTATUS    (1 << __SETPRSTATUS)
-#define UNSETPRSTATUS  (1 << __UNSETPRSTATUS)
+#define GETPRSTATUS	(1 << __GETPRSTATUS)
+#define SETPRSTATUS	(1 << __SETPRSTATUS)
+#define UNSETPRSTATUS	(1UL << __UNSETPRSTATUS)
 
 #define INITIAL_REPLY_LEN 1000
 
@@ -84,8 +84,8 @@ struct handler {
 };
 
 int alloc_handlers (void);
-int add_handler (int fp, int (*fn)(void *, char **, int *, void *));
-int set_handler_callback (int fp, int (*fn)(void *, char **, int *, void *));
+int add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *));
+int set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *));
 int parse_cmd (char * cmd, char ** reply, int * len, void *);
 int load_keys (void);
 char * get_keyparam (vector v, int code);

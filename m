From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [PATCH 3/3][RESEND]multipath-tools: fix 32 fingerprint
	limit in multipathd and path discovery
Date: Fri, 20 Jan 2012 00:51:59 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B40D@BTCMVEXC2-PRD.hq.netapp.com>
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr, Mike Snitzer <snitzer@redhat.com>, Fil <lists@internyc.net>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
List-Id: dm-devel.ids

This patch has the fix for two issues reported by Fil<lists@internyc.net>. 
i.e path discovery issue and multipathd crash.

Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
Reviewed-by: Bob Stankey <Robert.stankey@netapp.com> 
Reviewed-by: Babu Moger <Babu.moger@netapp.com>
Reviewed-by: Yanling Q <Yanling.Q@netapp.com>

---
diff -uprN multipath-tools-14jan-upstream-patchedall-2nd/libmpathpersist/mpath_persist.c multipath-tools/libmpathpersist/mpath_persist.c
--- multipath-tools-14jan-upstream-patchedall-2nd/libmpathpersist/mpath_persist.c	2012-01-12 12:03:51.000000000 -0500
+++ multipath-tools/libmpathpersist/mpath_persist.c	2012-01-16 09:33:49.000000000 -0500
@@ -175,6 +175,9 @@ int mpath_persistent_reserve_in (int fd,
 		goto out;
 	}
 
+	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER))
+		goto out1;
+
 	/* get info of all paths from the dm device	*/
 	if (get_mpvec (curmp, pathvec, alias)){
 		condlog(0, "%s: failed to get device info.", alias);
@@ -260,11 +263,14 @@ int mpath_persistent_reserve_out ( int f
                 goto out;
         }
 
+	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER))
+		goto out1;
+
 	/* get info of all paths from the dm device     */
 	if (get_mpvec(curmp, pathvec, alias)){
 		condlog(0, "%s: failed to get device info.", alias);
 		ret = MPATH_PR_DMMP_ERROR;
-		goto out;
+		goto out1;
 	}
 
 	mpp = find_mp_by_alias(curmp, alias);
diff -uprN multipath-tools-14jan-upstream-patchedall-2nd/multipathd/cli.c multipath-tools/multipathd/cli.c
--- multipath-tools-14jan-upstream-patchedall-2nd/multipathd/cli.c	2012-01-12 12:23:15.000000000 -0500
+++ multipath-tools/multipathd/cli.c	2012-01-16 09:33:49.000000000 -0500
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
 
@@ -79,7 +79,7 @@ add_handler (int fp, int (*fn)(void *, c
 }
 
 static struct handler *
-find_handler (int fp)
+find_handler (unsigned long fp)
 {
 	int i;
 	struct handler *h;
@@ -92,7 +92,7 @@ find_handler (int fp)
 }
 
 int
-set_handler_callback (int fp, int (*fn)(void *, char **, int *, void *))
+set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *))
 {
 	struct handler * h = find_handler(fp);
 
@@ -291,11 +291,11 @@ out:
 	return r;
 }
 
-static int
+static unsigned long 
 fingerprint(vector vec)
 {
 	int i;
-	int fp = 0;
+	unsigned long fp = 0;
 	struct key * kw;
 
 	if (!vec)
@@ -335,7 +335,7 @@ static char *
 genhelp_handler (void)
 {
 	int i, j;
-	int fp;
+	unsigned long fp;
 	struct handler * h;
 	struct key * kw;
 	char * reply;
@@ -402,7 +402,7 @@ parse_cmd (char * cmd, char ** reply, in
 }
 
 char *
-get_keyparam (vector v, int code)
+get_keyparam (vector v, unsigned long code)
 {
 	struct key * kw;
 	int i;
@@ -471,7 +471,7 @@ void cli_exit(void)
 }
 
 static int
-key_match_fingerprint (struct key * kw, int fp)
+key_match_fingerprint (struct key * kw, unsigned long fp)
 {
 	if (!fp)
 		return 0;
@@ -485,7 +485,8 @@ key_match_fingerprint (struct key * kw, 
 char *
 key_generator (const char * str, int state)
 {
-	static int index, len, rlfp, has_param;
+	static int index, len, has_param;
+	static unsigned long rlfp;	
 	struct key * kw;
 	int i;
 	struct handler *h;
@@ -555,7 +556,7 @@ key_generator (const char * str, int sta
 			 * nfp is the candidate fingerprint we try to
 			 * validate against all known command fingerprints.
 			 */
-			int nfp = rlfp | kw->code;
+			unsigned long nfp = rlfp | kw->code;
 			vector_foreach_slot(handlers, h, i) {
 				if (!rlfp || ((h->fingerprint & nfp) == nfp)) {
 					/*
diff -uprN multipath-tools-14jan-upstream-patchedall-2nd/multipathd/cli.h multipath-tools/multipathd/cli.h
--- multipath-tools-14jan-upstream-patchedall-2nd/multipathd/cli.h	2012-01-12 12:24:09.000000000 -0500
+++ multipath-tools/multipathd/cli.h	2012-01-16 09:33:49.000000000 -0500
@@ -65,16 +65,16 @@ enum {
 #define WILDCARDS	(1 << __WILDCARDS)
 #define QUIT		(1 << __QUIT)
 #define SHUTDOWN	(1 << __SHUTDOWN)
-#define GETPRSTATUS	(1 << __GETPRSTATUS)
-#define SETPRSTATUS	(1 << __SETPRSTATUS)
-#define UNSETPRSTATUS	(1 << __UNSETPRSTATUS)
+#define GETPRSTATUS	(1UL << __GETPRSTATUS)
+#define SETPRSTATUS	(1UL << __SETPRSTATUS)
+#define UNSETPRSTATUS	(1UL << __UNSETPRSTATUS)
 
-#define INITIAL_REPLY_LEN 1000
+#define INITIAL_REPLY_LEN	1100
 
 struct key {
 	char * str;
 	char * param;
-	int code;
+	unsigned long code;
 	int has_param;
 };
 
@@ -84,11 +84,11 @@ struct handler {
 };
 
 int alloc_handlers (void);
-int add_handler (int fp, int (*fn)(void *, char **, int *, void *));
-int set_handler_callback (int fp, int (*fn)(void *, char **, int *, void *));
+int add_handler (unsigned long fp, int (*fn)(void *, char **, int *, void *));
+int set_handler_callback (unsigned long fp, int (*fn)(void *, char **, int *, void *));
 int parse_cmd (char * cmd, char ** reply, int * len, void *);
 int load_keys (void);
-char * get_keyparam (vector v, int code);
+char * get_keyparam (vector v, unsigned long code);
 void free_keys (vector vec);
 void free_handlers (void);
 int cli_init (void);

--  

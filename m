From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 51/57] multipathd: Provide standard error
	description on cli failure
Date: Wed, 27 Apr 2016 13:10:52 +0200
Message-ID: <1461755458-29225-52-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When the cli command fails we should be returning the error
in addition to the standard help text.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/cli.c | 53 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 6a5c6db..ab1365b 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  */
+#include <errno.h>
 #include <memory.h>
 #include <vector.h>
 #include <parser.h>
@@ -224,10 +225,14 @@ find_key (const char * str)
 	return foundkw;
 }
 
-#define E_SYNTAX	1
-#define E_NOPARM	2
-#define E_NOMEM		3
-
+/*
+ * get_cmdvec
+ *
+ * returns:
+ * ENOMEM: not enough memory to allocate command
+ * EAGAIN: command not found
+ * EINVAL: argument missing for command
+ */
 static int
 get_cmdvec (char * cmd, vector *v)
 {
@@ -241,13 +246,13 @@ get_cmdvec (char * cmd, vector *v)
 
 	strvec = alloc_strvec(cmd);
 	if (!strvec)
-		return E_NOMEM;
+		return ENOMEM;
 
 	cmdvec = vector_alloc();
 
 	if (!cmdvec) {
 		free_strvec(strvec);
-		return E_NOMEM;
+		return ENOMEM;
 	}
 
 	vector_foreach_slot(strvec, buff, i) {
@@ -260,17 +265,17 @@ get_cmdvec (char * cmd, vector *v)
 		}
 		kw = find_key(buff);
 		if (!kw) {
-			r = E_SYNTAX;
+			r = EAGAIN;
 			goto out;
 		}
 		cmdkw = alloc_key();
 		if (!cmdkw) {
-			r = E_NOMEM;
+			r = ENOMEM;
 			goto out;
 		}
 		if (!vector_alloc_slot(cmdvec)) {
 			FREE(cmdkw);
-			r = E_NOMEM;
+			r = ENOMEM;
 			goto out;
 		}
 		vector_set_slot(cmdvec, cmdkw);
@@ -280,7 +285,7 @@ get_cmdvec (char * cmd, vector *v)
 			get_param = 1;
 	}
 	if (get_param) {
-		r = E_NOPARM;
+		r = EINVAL;
 		goto out;
 	}
 	*v = cmdvec;
@@ -340,13 +345,29 @@ genhelp_sprint_aliases (char * reply, int maxlen, vector keys,
 }
 
 static int
-do_genhelp(char *reply, int maxlen) {
+do_genhelp(char *reply, int maxlen, const char *cmd, int error) {
 	int len = 0;
 	int i, j;
 	uint64_t fp;
 	struct handler * h;
 	struct key * kw;
 
+	switch(error) {
+	case ENOMEM:
+		len += snprintf(reply + len, maxlen - len,
+				"%s: Not enough memory\n", cmd);
+		break;
+	case EAGAIN:
+		len += snprintf(reply + len, maxlen - len,
+				"%s: not found\n", cmd);
+		break;
+	case EINVAL:
+		len += snprintf(reply + len, maxlen - len,
+				"%s: Missing argument\n", cmd);
+		break;
+	}
+	if (len >= maxlen)
+		goto out;
 	len += snprintf(reply + len, maxlen - len, VERSION_STRING);
 	if (len >= maxlen)
 		goto out;
@@ -388,7 +409,7 @@ out:
 
 
 static char *
-genhelp_handler (void)
+genhelp_handler (const char *cmd, int error)
 {
 	char * reply;
 	char * p = NULL;
@@ -401,7 +422,7 @@ genhelp_handler (void)
 		if (!reply)
 			return NULL;
 		p = reply;
-		p += do_genhelp(reply, maxlen);
+		p += do_genhelp(reply, maxlen, cmd, error);
 		again = ((p - reply) >= maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -418,7 +439,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data)
 	r = get_cmdvec(cmd, &cmdvec);
 
 	if (r) {
-		*reply = genhelp_handler();
+		*reply = genhelp_handler(cmd, r);
 		*len = strlen(*reply) + 1;
 		return 0;
 	}
@@ -426,7 +447,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data)
 	h = find_handler(fingerprint(cmdvec));
 
 	if (!h || !h->fn) {
-		*reply = genhelp_handler();
+		*reply = genhelp_handler(cmd, EINVAL);
 		*len = strlen(*reply) + 1;
 		free_keys(cmdvec);
 		return 0;
@@ -562,7 +583,7 @@ key_generator (const char * str, int state)
 		/*
 		 * If last keyword takes a param, don't even try to guess
 		 */
-		if (r == E_NOPARM) {
+		if (r == EINVAL) {
 			has_param = 1;
 			return (strdup("(value)"));
 		}
-- 
2.6.6

Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99D6C32774
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200924;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qgDET8VAdD0YW4wQSdSiFpqfEOL3lbV0HoD9nnWZnEI=;
	b=EAGX1ZPhYbRCfs3QWIr1Q239sPXeA+d22AS/BUwmSy1hCqNInN2GjP9zteaglhhh7QxktA
	+7ESkh+KAdsePeqBGYftZ1cYd1d5cF29vg+MThi+XdrzU/L7M0pE2o4HSINoP8Bpis5Qbu
	1wxhpW9vpQCGlymacPvBLUtfMK8+HPM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-XE9-o3wsPaqdGvJTmsGrEw-1; Mon, 22 Aug 2022 16:42:02 -0400
X-MC-Unique: XE9-o3wsPaqdGvJTmsGrEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 702A485A589;
	Mon, 22 Aug 2022 20:42:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B881C15BB3;
	Mon, 22 Aug 2022 20:42:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48F3F1946A47;
	Mon, 22 Aug 2022 20:42:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E4161946A52
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 629272166B29; Mon, 22 Aug 2022 20:41:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E9702166B26
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4401D3806709
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:54 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-482-FZhGOu2gN86OUXEv8TJqAA-1; Mon,
 22 Aug 2022 16:41:52 -0400
X-MC-Unique: FZhGOu2gN86OUXEv8TJqAA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 3ED80202B8;
 Mon, 22 Aug 2022 20:41:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E570F13523;
 Mon, 22 Aug 2022 20:41:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id mOBBNg7qA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:50 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:17 +0200
Message-Id: <20220822204119.20719-10-mwilck@suse.com>
In-Reply-To: <20220822204119.20719-1-mwilck@suse.com>
References: <20220822204119.20719-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 09/11] multipathc: add new interactive client
 program
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Add a new small program, multipathc, that acts as interactive
uxsock client for multipathd. multipathc is the only program
that has an interactive mode and can thus link to either libreadline
or libedit for command line history. All code depending on libreadline
is moved from uxclnt.c and cli.c to multipathc.c.

This patch breaks multipathd's interactive mode. It will be restored
in the next patch.

As multipathc doesn't link to libmultipath, it can link to libreadline
without license conflict.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore              |   1 +
 multipathd/Makefile     |  24 ++--
 multipathd/cli.c        | 130 ++------------------
 multipathd/cli.h        |   5 +-
 multipathd/multipathc.c | 254 ++++++++++++++++++++++++++++++++++++++++
 multipathd/uxclnt.c     | 126 +-------------------
 6 files changed, 293 insertions(+), 247 deletions(-)
 create mode 100644 multipathd/multipathc.c

diff --git a/.gitignore b/.gitignore
index b88608c..821c3e6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,6 +13,7 @@ cscope.out
 kpartx/kpartx
 multipath/multipath
 multipathd/multipathd
+multipathd/multipathc
 mpathpersist/mpathpersist
 abi.tar.gz
 abi
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 7128510..19ab2e9 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -27,12 +27,12 @@ LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
 
 
 ifeq ($(READLINE),libedit)
-CPPFLAGS += -DUSE_LIBEDIT
-LIBDEPS += -ledit
+RL_CPPFLAGS = -DUSE_LIBEDIT
+RL_LIBDEPS += -ledit
 endif
 ifeq ($(READLINE),libreadline)
-CPPFLAGS += -DUSE_LIBREADLINE
-LIBDEPS += -lreadline
+RL_CPPFLAGS += -DUSE_LIBREADLINE
+RL_LIBDEPS += -lreadline
 endif
 
 ifdef SYSTEMD
@@ -50,6 +50,8 @@ endif
 OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o waiter.o \
        dmevents.o init_unwinder.o
 
+CLI_OBJS = multipathc.o cli.o
+
 ifeq ($(FPIN_SUPPORT),1)
 OBJS += fpin_handlers.o
 endif
@@ -57,18 +59,26 @@ endif
 
 
 EXEC = multipathd
+CLI = multipathc
 
-all : $(EXEC)
+all : $(EXEC) $(CLI)
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
 
+multipathc.o:	multipathc.c
+	$(CC) $(CPPFLAGS) $(RL_CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
+
+$(CLI):  $(CLI_OBJS)
+	$(CC) $(CFLAGS) $(CLI_OBJS) $(LDFLAGS) -o $@ $(CLI_LIBDEPS) $(RL_LIBDEPS)
+
 cli_handlers.o:	cli_handlers.c
 	$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
+	$(INSTALL_PROGRAM) -m 755 $(CLI) $(DESTDIR)$(bindir)
 ifdef SYSTEMD
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(unitdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
@@ -78,13 +88,13 @@ endif
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
 
 uninstall:
-	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
+	$(RM) $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/$(CLI)
 	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean: dep_clean
-	$(RM) core *.o $(EXEC)
+	$(RM) core *.o $(EXEC) $(CLI)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/multipathd/cli.c b/multipathd/cli.c
index cc56950..d1bfeee 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -11,12 +11,6 @@
 #include "parser.h"
 #include "util.h"
 #include "version.h"
-#ifdef USE_LIBEDIT
-#include <editline/readline.h>
-#endif
-#ifdef USE_LIBREADLINE
-#include <readline/readline.h>
-#endif
 
 #include "mpath_cmd.h"
 #include "cli.h"
@@ -26,6 +20,16 @@
 static vector keys;
 static vector handlers;
 
+vector get_keys(void)
+{
+	return keys;
+}
+
+vector get_handlers(void)
+{
+	return handlers;
+}
+
 static struct key *
 alloc_key (void)
 {
@@ -225,8 +229,7 @@ load_keys (void)
 	return 0;
 }
 
-static struct key *
-find_key (const char * str)
+struct key *find_key (const char * str)
 {
 	int i;
 	int len, klen;
@@ -323,8 +326,7 @@ out:
 	return r;
 }
 
-static uint64_t
-fingerprint(const struct _vector *vec)
+uint64_t fingerprint(const struct _vector *vec)
 {
 	int i;
 	uint64_t fp = 0;
@@ -458,111 +460,3 @@ void cli_exit(void)
 	free_keys(keys);
 	keys = NULL;
 }
-
-#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
-static int
-key_match_fingerprint (struct key * kw, uint64_t fp)
-{
-	if (!fp)
-		return 0;
-
-	return ((fp & kw->code) == kw->code);
-}
-
-/*
- * This is the readline completion handler
- */
-char *
-key_generator (const char * str, int state)
-{
-	static int index, len, has_param;
-	static uint64_t rlfp;
-	struct key * kw;
-	int i;
-	struct handler *h;
-	vector v = NULL;
-
-	if (!state) {
-		index = 0;
-		has_param = 0;
-		rlfp = 0;
-		len = strlen(str);
-		int r = get_cmdvec(rl_line_buffer, &v);
-		/*
-		 * If a word completion is in progress, we don't want
-		 * to take an exact keyword match in the fingerprint.
-		 * For ex "show map[tab]" would validate "map" and discard
-		 * "maps" as a valid candidate.
-		 */
-		if (v && len)
-			vector_del_slot(v, VECTOR_SIZE(v) - 1);
-		/*
-		 * Clean up the mess if we dropped the last slot of a 1-slot
-		 * vector
-		 */
-		if (v && !VECTOR_SIZE(v)) {
-			vector_free(v);
-			v = NULL;
-		}
-		/*
-		 * If last keyword takes a param, don't even try to guess
-		 */
-		if (r == EINVAL) {
-			has_param = 1;
-			return (strdup("(value)"));
-		}
-		/*
-		 * Compute a command fingerprint to find out possible completions.
-		 * Once done, the vector is useless. Free it.
-		 */
-		if (v) {
-			rlfp = fingerprint(v);
-			free_keys(v);
-		}
-	}
-	/*
-	 * No more completions for parameter placeholder.
-	 * Brave souls might try to add parameter completion by walking paths and
-	 * multipaths vectors.
-	 */
-	if (has_param)
-		return ((char *)NULL);
-	/*
-	 * Loop through keywords for completion candidates
-	 */
-	vector_foreach_slot_after (keys, kw, index) {
-		if (!strncmp(kw->str, str, len)) {
-			/*
-			 * Discard keywords already in the command line
-			 */
-			if (key_match_fingerprint(kw, rlfp)) {
-				struct key * curkw = find_key(str);
-				if (!curkw || (curkw != kw))
-					continue;
-			}
-			/*
-			 * Discard keywords making syntax errors.
-			 *
-			 * nfp is the candidate fingerprint we try to
-			 * validate against all known command fingerprints.
-			 */
-			uint64_t nfp = rlfp | kw->code;
-			vector_foreach_slot(handlers, h, i) {
-				if (!rlfp || ((h->fingerprint & nfp) == nfp)) {
-					/*
-					 * At least one full command is
-					 * possible with this keyword :
-					 * Consider it validated
-					 */
-					index++;
-					return (strdup(kw->str));
-				}
-			}
-		}
-	}
-	/*
-	 * No more candidates
-	 */
-	return ((char *)NULL);
-}
-#endif
diff --git a/multipathd/cli.h b/multipathd/cli.h
index a6082ac..cb5bbe2 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -151,6 +151,9 @@ void free_keys (vector vec);
 void free_handlers (void);
 int cli_init (void);
 void cli_exit(void);
-char * key_generator (const char * str, int state);
+uint64_t fingerprint(const struct _vector *vec);
+vector get_keys(void);
+vector get_handlers(void);
+struct key *find_key (const char * str);
 
 #endif /* _CLI_H_ */
diff --git a/multipathd/multipathc.c b/multipathd/multipathc.c
new file mode 100644
index 0000000..571a182
--- /dev/null
+++ b/multipathd/multipathc.c
@@ -0,0 +1,254 @@
+/*
+ * Copyright (c) 2022 SUSE LLC
+ * SPDX-License-Identifier: GPL-3.0-or-later
+ */
+#include <string.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <errno.h>
+#include <ctype.h>
+
+#include "mpath_cmd.h"
+#include "uxclnt.h"
+#include "vector.h"
+#include "uxsock.h"
+#include "util.h"
+#include "cli.h"
+
+#ifdef USE_LIBEDIT
+#include <editline/readline.h>
+#endif
+#ifdef USE_LIBREADLINE
+#include <readline/readline.h>
+#include <readline/history.h>
+#endif
+/*
+ * Versions of libedit prior to 2016 were using a wrong
+ * prototype for rl_completion_entry_function in readline.h.
+ * Internally, libedit casts this to the correct type
+ * (char *)(*)(const char *, int).
+ * So we simply cast to the wrong prototype here.
+ * See http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/libedit/readline/readline.h.diff?r1=1.34&r2=1.35
+ * Unfortunately, this change isn't reflected in the libedit version.
+ */
+#ifdef BROKEN_RL_COMPLETION_FUNC
+#define RL_COMP_ENTRY_CAST(x) ((int (*)(const char *, int)) (x))
+#else
+#define RL_COMP_ENTRY_CAST(x) (x)
+#endif
+
+#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
+static int
+key_match_fingerprint (struct key * kw, uint64_t fp)
+{
+	if (!fp)
+		return 0;
+
+	return ((fp & kw->code) == kw->code);
+}
+
+/*
+ * This is the readline completion handler
+ */
+char *
+key_generator (const char * str, int state)
+{
+	static int index, len, has_param;
+	static uint64_t rlfp;
+	struct key * kw;
+	int i;
+	struct handler *h;
+	vector v = NULL;
+	const vector keys = get_keys();
+	const vector handlers = get_handlers();
+
+	if (!state) {
+		index = 0;
+		has_param = 0;
+		rlfp = 0;
+		len = strlen(str);
+		int r = get_cmdvec(rl_line_buffer, &v);
+		/*
+		 * If a word completion is in progress, we don't want
+		 * to take an exact keyword match in the fingerprint.
+		 * For ex "show map[tab]" would validate "map" and discard
+		 * "maps" as a valid candidate.
+		 */
+		if (v && len)
+			vector_del_slot(v, VECTOR_SIZE(v) - 1);
+		/*
+		 * Clean up the mess if we dropped the last slot of a 1-slot
+		 * vector
+		 */
+		if (v && !VECTOR_SIZE(v)) {
+			vector_free(v);
+			v = NULL;
+		}
+		/*
+		 * If last keyword takes a param, don't even try to guess
+		 */
+		if (r == EINVAL) {
+			has_param = 1;
+			return (strdup("(value)"));
+		}
+		/*
+		 * Compute a command fingerprint to find out possible completions.
+		 * Once done, the vector is useless. Free it.
+		 */
+		if (v) {
+			rlfp = fingerprint(v);
+			free_keys(v);
+		}
+	}
+	/*
+	 * No more completions for parameter placeholder.
+	 * Brave souls might try to add parameter completion by walking paths and
+	 * multipaths vectors.
+	 */
+	if (has_param)
+		return ((char *)NULL);
+	/*
+	 * Loop through keywords for completion candidates
+	 */
+	vector_foreach_slot_after (keys, kw, index) {
+		if (!strncmp(kw->str, str, len)) {
+			/*
+			 * Discard keywords already in the command line
+			 */
+			if (key_match_fingerprint(kw, rlfp)) {
+				struct key * curkw = find_key(str);
+				if (!curkw || (curkw != kw))
+					continue;
+			}
+			/*
+			 * Discard keywords making syntax errors.
+			 *
+			 * nfp is the candidate fingerprint we try to
+			 * validate against all known command fingerprints.
+			 */
+			uint64_t nfp = rlfp | kw->code;
+			vector_foreach_slot(handlers, h, i) {
+				if (!rlfp || ((h->fingerprint & nfp) == nfp)) {
+					/*
+					 * At least one full command is
+					 * possible with this keyword :
+					 * Consider it validated
+					 */
+					index++;
+					return (strdup(kw->str));
+				}
+			}
+		}
+	}
+	/*
+	 * No more candidates
+	 */
+	return ((char *)NULL);
+}
+#endif
+
+static void print_reply(char *s)
+{
+	if (!s)
+		return;
+
+	if (isatty(1)) {
+		printf("%s", s);
+		return;
+	}
+	/* strip ANSI color markers */
+	while (*s != '\0') {
+		if ((*s == 0x1b) && (*(s+1) == '['))
+			while ((*s++ != 'm') && (*s != '\0')) {};
+		putchar(*s++);
+	}
+}
+
+static int need_quit(char *str, size_t len)
+{
+	char *ptr, *start;
+	size_t trimed_len = len;
+
+	for (ptr = str; trimed_len && isspace(*ptr);
+	     trimed_len--, ptr++)
+		;
+
+	start = ptr;
+
+	for (ptr = str + len - 1; trimed_len && isspace(*ptr);
+	     trimed_len--, ptr--)
+		;
+
+	if ((trimed_len == 4 && !strncmp(start, "exit", 4)) ||
+	    (trimed_len == 4 && !strncmp(start, "quit", 4)))
+		return 1;
+
+	return 0;
+}
+
+/*
+ * process the client
+ */
+static void process(int fd, unsigned int timeout)
+{
+
+#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
+	rl_readline_name = "multipathd";
+	rl_completion_entry_function = RL_COMP_ENTRY_CAST(key_generator);
+#endif
+
+	cli_init();
+	for(;;)
+	{
+		char *line __attribute__((cleanup(cleanup_charp))) = NULL;
+		char *reply __attribute__((cleanup(cleanup_charp))) = NULL;
+		ssize_t llen;
+		int ret;
+
+#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
+		line = readline("multipathd> ");
+		if (!line)
+			break;
+		llen = strlen(line);
+		if (!llen)
+			continue;
+#else
+		size_t lsize = 0;
+
+		fputs("multipathd> ", stdout);
+		errno = 0;
+		llen = getline(&line, &lsize, stdin);
+		if (llen == -1) {
+			if (errno != 0)
+				fprintf(stderr, "Error in getline: %m");
+			break;
+		}
+		if (!llen || !strcmp(line, "\n"))
+			continue;
+#endif
+
+		if (need_quit(line, llen))
+			break;
+
+		if (send_packet(fd, line) != 0)
+			break;
+		ret = recv_packet(fd, &reply, timeout);
+		if (ret != 0)
+			break;
+
+		print_reply(reply);
+	}
+}
+
+int main (void)
+{
+	int fd = mpath_connect();
+
+	if (fd == -1)
+		return 1;
+
+	process(fd, DEFAULT_REPLY_TIMEOUT + 100);
+	mpath_disconnect(fd);
+	return 0;
+}
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index b817bea..15e1293 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -5,128 +5,14 @@
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  */
 #include <stdio.h>
+#include <string.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <stdarg.h>
-#include <ctype.h>
-#include <fcntl.h>
 #include <errno.h>
-#include <sys/ioctl.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <sys/un.h>
-#include <poll.h>
-
-#ifdef USE_LIBEDIT
-#include <editline/readline.h>
-#endif
-#ifdef USE_LIBREADLINE
-#include <readline/readline.h>
-#include <readline/history.h>
-#endif
 
 #include "mpath_cmd.h"
 #include "uxsock.h"
-#include "defaults.h"
-
-#include "vector.h"
-#include "util.h"
-#include "cli.h"
 #include "uxclnt.h"
 
-static void print_reply(char *s)
-{
-	if (!s)
-		return;
-
-	if (isatty(1)) {
-		printf("%s", s);
-		return;
-	}
-	/* strip ANSI color markers */
-	while (*s != '\0') {
-		if ((*s == 0x1b) && (*(s+1) == '['))
-			while ((*s++ != 'm') && (*s != '\0')) {};
-		putchar(*s++);
-	}
-}
-
-static int need_quit(char *str, size_t len)
-{
-	char *ptr, *start;
-	size_t trimed_len = len;
-
-	for (ptr = str; trimed_len && isspace(*ptr);
-	     trimed_len--, ptr++)
-		;
-
-	start = ptr;
-
-	for (ptr = str + len - 1; trimed_len && isspace(*ptr);
-	     trimed_len--, ptr--)
-		;
-
-	if ((trimed_len == 4 && !strncmp(start, "exit", 4)) ||
-	    (trimed_len == 4 && !strncmp(start, "quit", 4)))
-		return 1;
-
-	return 0;
-}
-
-/*
- * process the client
- */
-static void process(int fd, unsigned int timeout)
-{
-
-#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
-	rl_readline_name = "multipathd";
-	rl_completion_entry_function = key_generator;
-#endif
-
-	cli_init();
-	for(;;)
-	{
-		char *line __attribute__((cleanup(cleanup_charp))) = NULL;
-		char *reply __attribute__((cleanup(cleanup_charp))) = NULL;
-		ssize_t llen;
-		int ret;
-
-#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
-		line = readline("multipathd> ");
-		if (!line)
-			break;
-		llen = strlen(line);
-		if (!llen)
-			continue;
-#else
-		size_t lsize = 0;
-
-		fputs("multipathd> ", stdout);
-		errno = 0;
-		llen = getline(&line, &lsize, stdin);
-		if (llen == -1) {
-			if (errno != 0)
-				fprintf(stderr, "Error in getline: %m");
-			break;
-		}
-		if (!llen || !strcmp(line, "\n"))
-			continue;
-#endif
-
-		if (need_quit(line, llen))
-			break;
-
-		if (send_packet(fd, line) != 0)
-			break;
-		ret = recv_packet(fd, &reply, timeout);
-		if (ret != 0)
-			break;
-
-		print_reply(reply);
-	}
-}
-
 static int process_req(int fd, char * inbuf, unsigned int timeout)
 {
 	char *reply;
@@ -159,13 +45,11 @@ int uxclnt(char * inbuf, unsigned int timeout)
 	int fd, ret = 0;
 
 	fd = mpath_connect();
-	if (fd == -1)
-		exit(1);
+	if (fd == -1 || !inbuf)
+		return 1;
+
+	ret = process_req(fd, inbuf, timeout);
 
-	if (inbuf)
-		ret = process_req(fd, inbuf, timeout);
-	else
-		process(fd, timeout);
 	mpath_disconnect(fd);
 	return ret;
 }
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


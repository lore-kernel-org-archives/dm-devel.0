Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8084C32792
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200920;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8BnDvdlrSkSRkMPuEs5uT5OlMv5sCL2bwqkKKAda+GY=;
	b=eZzcRl1HQX3QOAVBbK2FQyavZCfexXPS/bTyq1csHD3hoKAM3pioe7zEkqBfTbgOR7AZdR
	UJarhkhtDpUEfqsUZARZS7RRVtshXKbh2sFGW5G6U45HWN5Q/l+BXekxlH0nJCzSEaOdGH
	UST151R0R/IoSjOCB62nUqAsNW6xrGk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-4ScJK6j6OtOEDgHwPihZSw-1; Mon, 22 Aug 2022 16:41:57 -0400
X-MC-Unique: 4ScJK6j6OtOEDgHwPihZSw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABEE1381494B;
	Mon, 22 Aug 2022 20:41:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88437492C3B;
	Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 51B7C1946A47;
	Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 555621946A47
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 090B0C15BBA; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 05827C15BB3
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E178E185A7BA
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:51 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-599-jCwh0E2-PhaQCb3F9b2kmQ-1; Mon,
 22 Aug 2022 16:41:50 -0400
X-MC-Unique: jCwh0E2-PhaQCb3F9b2kmQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id AA76237339;
 Mon, 22 Aug 2022 20:41:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 75A9813523;
 Mon, 22 Aug 2022 20:41:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id WDspGwzqA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:48 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:09 +0200
Message-Id: <20220822204119.20719-2-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 01/11] multipathd: replace libreadline with
 getline()
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Hannes Reinecke <hare@suse.de>

libreadline changed the license to be incompatible with multipath-tools
usage, so replace it with a simple getline().

mwilck: Make this the default option via Makefile.inc; it is used if
READLINE is unset. Compiling with READLINE=libreadline or READLINE=libedit
remains possible.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc        |  4 ++--
 multipathd/cli.c    |  2 ++
 multipathd/uxclnt.c | 50 ++++++++++++++++++++++++++++++---------------
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index ad7afd0..0653d21 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -9,10 +9,10 @@
 # Uncomment to disable dmevents polling support
 # ENABLE_DMEVENTS_POLL = 0
 #
-# Readline library to use, libedit or libreadline
+# Readline library to use, libedit, libreadline, or empty
 # Caution: Using libreadline may make the multipathd binary undistributable,
 # see https://github.com/opensvc/multipath-tools/issues/36
-READLINE = libedit
+READLINE := 
 
 # List of scsi device handler modules to load on boot, e.g.
 # SCSI_DH_MODULES_PRELOAD := scsi_dh_alua scsi_dh_rdac
diff --git a/multipathd/cli.c b/multipathd/cli.c
index fa482a6..cc56950 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -459,6 +459,7 @@ void cli_exit(void)
 	keys = NULL;
 }
 
+#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
 static int
 key_match_fingerprint (struct key * kw, uint64_t fp)
 {
@@ -564,3 +565,4 @@ key_generator (const char * str, int state)
 	 */
 	return ((char *)NULL);
 }
+#endif
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 251e7d7..b817bea 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -30,6 +30,7 @@
 #include "defaults.h"
 
 #include "vector.h"
+#include "util.h"
 #include "cli.h"
 #include "uxclnt.h"
 
@@ -77,35 +78,52 @@ static int need_quit(char *str, size_t len)
  */
 static void process(int fd, unsigned int timeout)
 {
-	char *line;
-	char *reply;
-	int ret;
 
-	cli_init();
+#if defined(USE_LIBREADLINE) || defined(USE_LIBEDIT)
 	rl_readline_name = "multipathd";
 	rl_completion_entry_function = key_generator;
-	while ((line = readline("multipathd> "))) {
-		size_t llen = strlen(line);
+#endif
 
-		if (!llen) {
-			free(line);
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
 			continue;
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
 		}
+		if (!llen || !strcmp(line, "\n"))
+			continue;
+#endif
 
 		if (need_quit(line, llen))
 			break;
 
-		if (send_packet(fd, line) != 0) break;
+		if (send_packet(fd, line) != 0)
+			break;
 		ret = recv_packet(fd, &reply, timeout);
-		if (ret != 0) break;
+		if (ret != 0)
+			break;
 
 		print_reply(reply);
-
-		if (line && *line)
-			add_history(line);
-
-		free(line);
-		free(reply);
 	}
 }
 
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


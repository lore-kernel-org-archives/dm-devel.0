Return-Path: <SRS0=U3zJ=MH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105ADC07E96
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:54:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 92E676136E
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92E676136E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-DPrymbZ1Ph-qAseQSEBuzw-1; Thu, 15 Jul 2021 06:54:45 -0400
X-MC-Unique: DPrymbZ1Ph-qAseQSEBuzw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31A5F101C8B4;
	Thu, 15 Jul 2021 10:54:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13F0B179E6;
	Thu, 15 Jul 2021 10:54:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EBF7A4EA2F;
	Thu, 15 Jul 2021 10:54:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16FAqjxb015579 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Jul 2021 06:52:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DA7A8208BDE9; Thu, 15 Jul 2021 10:52:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D433A208BDE6
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C37B18A01A9
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:43 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-317-oSNPfADFP1uEPT-u7xnU2g-1; Thu, 15 Jul 2021 06:52:41 -0400
X-MC-Unique: oSNPfADFP1uEPT-u7xnU2g-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B50F41FE0E;
	Thu, 15 Jul 2021 10:52:39 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 8799613D86;
	Thu, 15 Jul 2021 10:52:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id +NOMH3cT8GDQIAAAGKfGzw
	(envelope-from <mwilck@suse.com>); Thu, 15 Jul 2021 10:52:39 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 15 Jul 2021 12:52:23 +0200
Message-Id: <20210715105223.30463-10-mwilck@suse.com>
In-Reply-To: <20210715105223.30463-1-mwilck@suse.com>
References: <20210715105223.30463-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16FAqjxb015579
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 9/9] multipathd: use strbuf in cli.c
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Here, too, strbuf can be used to simplify code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c | 94 ++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 60 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index bdc9fb1..4d6c37c 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -16,6 +16,7 @@
 #include "mpath_cmd.h"
 #include "cli.h"
 #include "debug.h"
+#include "strbuf.h"
 
 static vector keys;
 static vector handlers;
@@ -354,107 +355,80 @@ alloc_handlers (void)
 }
 
 static int
-genhelp_sprint_aliases (char * reply, int maxlen, vector keys,
+genhelp_sprint_aliases (struct strbuf *reply, vector keys,
 			struct key * refkw)
 {
-	int i, len = 0;
+	int i;
 	struct key * kw;
+	size_t initial_len = get_strbuf_len(reply);
 
 	vector_foreach_slot (keys, kw, i) {
-		if (kw->code == refkw->code && kw != refkw) {
-			len += snprintf(reply + len, maxlen - len,
-					"|%s", kw->str);
-			if (len >= maxlen)
-				return len;
-		}
+		if (kw->code == refkw->code && kw != refkw &&
+		    print_strbuf(reply, "|%s", kw->str) < 0)
+			return -1;
 	}
 
-	return len;
+	return get_strbuf_len(reply) - initial_len;
 }
 
 static int
-do_genhelp(char *reply, int maxlen, const char *cmd, int error) {
-	int len = 0;
+do_genhelp(struct strbuf *reply, const char *cmd, int error) {
 	int i, j;
 	uint64_t fp;
 	struct handler * h;
 	struct key * kw;
+	int rc = 0;
+	size_t initial_len = get_strbuf_len(reply);
 
 	switch(error) {
 	case ENOMEM:
-		len += snprintf(reply + len, maxlen - len,
-				"%s: Not enough memory\n", cmd);
+		rc = print_strbuf(reply, "%s: Not enough memory\n", cmd);
 		break;
 	case EAGAIN:
-		len += snprintf(reply + len, maxlen - len,
-				"%s: not found\n", cmd);
+		rc = print_strbuf(reply, "%s: not found\n", cmd);
 		break;
 	case EINVAL:
-		len += snprintf(reply + len, maxlen - len,
-				"%s: Missing argument\n", cmd);
+		rc = print_strbuf(reply, "%s: Missing argument\n", cmd);
 		break;
 	}
-	if (len >= maxlen)
-		goto out;
-	len += snprintf(reply + len, maxlen - len, VERSION_STRING);
-	if (len >= maxlen)
-		goto out;
-	len += snprintf(reply + len, maxlen - len, "CLI commands reference:\n");
-	if (len >= maxlen)
-		goto out;
+	if (rc < 0)
+		return -1;
+
+	if (print_strbuf(reply, VERSION_STRING) < 0 ||
+	    append_strbuf_str(reply, "CLI commands reference:\n") < 0)
+		return -1;
 
 	vector_foreach_slot (handlers, h, i) {
 		fp = h->fingerprint;
 		vector_foreach_slot (keys, kw, j) {
 			if ((kw->code & fp)) {
 				fp -= kw->code;
-				len += snprintf(reply + len , maxlen - len,
-						" %s", kw->str);
-				if (len >= maxlen)
-					goto out;
-				len += genhelp_sprint_aliases(reply + len,
-							      maxlen - len,
-							      keys, kw);
-				if (len >= maxlen)
-					goto out;
+				if (print_strbuf(reply, " %s", kw->str) < 0 ||
+				    genhelp_sprint_aliases(reply, keys, kw) < 0)
+					return -1;
 
 				if (kw->has_param) {
-					len += snprintf(reply + len,
-							maxlen - len,
-							" $%s", kw->str);
-					if (len >= maxlen)
-						goto out;
+					if (print_strbuf(reply, " $%s",
+							 kw->str) < 0)
+						return -1;
 				}
 			}
 		}
-		len += snprintf(reply + len, maxlen - len, "\n");
-		if (len >= maxlen)
-			goto out;
+		if (append_strbuf_str(reply, "\n") < 0)
+			return -1;
 	}
-out:
-	return len;
+	return get_strbuf_len(reply) - initial_len;
 }
 
 
 static char *
 genhelp_handler (const char *cmd, int error)
 {
-	char * reply;
-	char * p = NULL;
-	int maxlen = INITIAL_REPLY_LEN;
-	int again = 1;
-
-	reply = MALLOC(maxlen);
-
-	while (again) {
-		if (!reply)
-			return NULL;
-		p = reply;
-		p += do_genhelp(reply, maxlen, cmd, error);
-		again = ((p - reply) >= maxlen);
-		REALLOC_REPLY(reply, again, maxlen);
-	}
-	return reply;
+	STRBUF_ON_STACK(reply);
+
+	if (do_genhelp(&reply, cmd, error) == -1)
+		condlog(0, "genhelp_handler: out of memory");
+	return steal_strbuf_str(&reply);
 }
 
 int
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC360CA0FF3
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591416;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8vDcUikOh1VAwLWn1WRHLbzQ5JwCFd4DAXWO1ZJ8yYs=;
	b=bsAfHLDjP2A3kl+t/etiwcDHPDjBjj1sVE5kBCedypmFkouZif9p/PminKEYGSmruEj/kH
	ldxqHNOpcxPVvQ6cUE9dgDow87dVr+/W8nIVWAAIJ30pBYsYSpExNSfSinALJsDK0eGvKs
	j+VETZtStdbOKxAQwexF/egWcZY11HY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-cETJWyV7O0mL8P5t8eTSEg-1; Fri, 01 Sep 2023 14:03:33 -0400
X-MC-Unique: cETJWyV7O0mL8P5t8eTSEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46E9729DD997;
	Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34D8F1460FF2;
	Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0347F1946A46;
	Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96E8519465B7
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 87A0FD4781A; Fri,  1 Sep 2023 18:03:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 805E4D47819
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 671AA1817908
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:24 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-6E5dRmv6PWCJ0612dE065g-1; Fri,
 01 Sep 2023 14:03:22 -0400
X-MC-Unique: 6E5dRmv6PWCJ0612dE065g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id AD53121865;
 Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7EB0813582;
 Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2LhRHWkn8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:21 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:30 +0200
Message-ID: <20230901180235.23980-18-mwilck@suse.com>
In-Reply-To: <20230901180235.23980-1-mwilck@suse.com>
References: <20230901180235.23980-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 17/21] libmultipath: alias.c: factor out
 read_binding()
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This way we can test the parsing of input lines from the bindings
file more easily.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 58 ++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 9ca5da8..2f9bc82 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -647,6 +647,43 @@ void cleanup_bindings(void)
 	free_bindings(&global_bindings);
 }
 
+enum {
+	READ_BINDING_OK,
+	READ_BINDING_SKIP,
+};
+
+static int read_binding(char *line, unsigned int linenr, char **alias,
+			char **wwid) {
+	char *c, *saveptr;
+
+	c = strpbrk(line, "#\n\r");
+	if (c)
+		*c = '\0';
+
+	*alias = strtok_r(line, " \t", &saveptr);
+	if (!*alias) /* blank line */
+		return READ_BINDING_SKIP;
+
+	*wwid = strtok_r(NULL, " \t", &saveptr);
+	if (!*wwid) {
+		condlog(1, "invalid line %u in bindings file, missing WWID",
+			linenr);
+		return READ_BINDING_SKIP;
+	}
+	if (strlen(*wwid) > WWID_SIZE - 1) {
+		condlog(3,
+			"Ignoring too large wwid at %u in bindings file",
+			linenr);
+		return READ_BINDING_SKIP;
+	}
+	c = strtok_r(NULL, " \t", &saveptr);
+	if (c)
+		/* This is non-fatal */
+		condlog(1, "invalid line %d in bindings file, extra args \"%s\"",
+			linenr, c);
+	return READ_BINDING_OK;
+}
+
 static int _check_bindings_file(const struct config *conf, FILE *file,
 				 Bindings *bindings)
 {
@@ -658,27 +695,12 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
 
 	pthread_cleanup_push(cleanup_free_ptr, &line);
 	while ((n = getline(&line, &line_len, file)) >= 0) {
-		char *c, *alias, *wwid, *saveptr;
+		char *alias, *wwid;
 		const char *mpe_wwid;
 
-		linenr++;
-		c = strpbrk(line, "#\n\r");
-		if (c)
-			*c = '\0';
-		alias = strtok_r(line, " \t", &saveptr);
-		if (!alias) /* blank line */
+		if (read_binding(line, ++linenr, &alias, &wwid)
+		    == READ_BINDING_SKIP)
 			continue;
-		wwid = strtok_r(NULL, " \t", &saveptr);
-		if (!wwid) {
-			condlog(1, "invalid line %d in bindings file, missing WWID",
-				linenr);
-			continue;
-		}
-		c = strtok_r(NULL, " \t", &saveptr);
-		if (c)
-			/* This is non-fatal */
-			condlog(1, "invalid line %d in bindings file, extra args \"%s\"",
-				linenr, c);
 
 		mpe_wwid = get_mpe_wwid(conf->mptable, alias);
 		if (mpe_wwid && strcmp(mpe_wwid, wwid)) {
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


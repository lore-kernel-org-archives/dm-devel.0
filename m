Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A18EEB58F
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-AiHbL9qsN5qTXssSa_UZbg-1; Mon, 11 Sep 2023 12:39:29 -0400
X-MC-Unique: AiHbL9qsN5qTXssSa_UZbg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C52D928B91;
	Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27E1644029;
	Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1786619465A2;
	Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D83D61946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7E8540C6EBF; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0A2840C6EC0
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90F26181A6FC
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-F5tKlEw5PYKn66EgHHXNpQ-1; Mon,
 11 Sep 2023 12:39:20 -0400
X-MC-Unique: F5tKlEw5PYKn66EgHHXNpQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id D7A4021863;
 Mon, 11 Sep 2023 16:39:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A9F44139CC;
 Mon, 11 Sep 2023 16:39:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2N/KJ7ZC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:18 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:26 +0200
Message-ID: <20230911163846.27197-18-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 17/37] libmultipath: alias.c: factor out
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This way we can test the parsing of input lines from the bindings
file more easily.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 58 ++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index de21f52..ad83ca0 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -636,6 +636,43 @@ void cleanup_bindings(void)
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
@@ -647,27 +684,12 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
 
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
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


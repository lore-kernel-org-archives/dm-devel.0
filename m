Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7DC4EEB57E
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450391;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/VZJpo+0BefmtxVapXRxXHaGGaYL0nrY46GhwKNAWtc=;
	b=e55ZLP0Ecudidaqr+zZK6yqKnH/VZb8PkJDUfqscdNiQVx7vuuDdQhi91KABBkX3u6vPpb
	5ID8Q2UIFi7SfuRDZKZwBdxroNcxBqm+TijAtRj002cEAqfiO1YEcv8aFsK51GaO84fxga
	vyHpt7UOO4M4mtNk1VIPF2zKPjiu+8M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-T1roCxUJM8-xfMI0CHplww-1; Mon, 11 Sep 2023 12:39:47 -0400
X-MC-Unique: T1roCxUJM8-xfMI0CHplww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B63E43815EFC;
	Mon, 11 Sep 2023 16:39:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E89640C200A;
	Mon, 11 Sep 2023 16:39:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7FA9E19466DF;
	Mon, 11 Sep 2023 16:39:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA4EE1946A61
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BFAF840C6ECA; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7CAC40C6EA8
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9808090F842
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-zVbqZIPVMgGs1PXXt7VObQ-1; Mon,
 11 Sep 2023 12:39:23 -0400
X-MC-Unique: zVbqZIPVMgGs1PXXt7VObQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 5775C21847;
 Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 28FA0139CC;
 Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id mM5eCLhC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:20 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:31 +0200
Message-ID: <20230911163846.27197-23-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 22/37] libmultipath: sort aliases by length
 and strcmp
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The current sort order of aliases is alphabetical, which is does not match
the actual order of aliases, where "mpathaa" > "mpathz". Change the ordering as
follows: first sort by string length, then alphabetically. This will make
sure that for aliases with the same prefix, alias order is correct ("mpathaaa"
will be sorted after "mpathzz", etc). Even for mixed prefixes, the alias
order will be correct for every individual prefix, even though aliases with
different prefixes may alternate in the file.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 45 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 58436ec..af6565b 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -117,6 +117,35 @@ static const struct binding *get_binding_for_wwid(const Bindings *bindings,
 	return NULL;
 }
 
+/*
+ * Sort order for aliases.
+ *
+ * The "numeric" ordering of aliases for a given prefix P is
+ * Pa, ..., Pz, Paa, ..., Paz, Pba, ... , Pzz, Paaa, ..., Pzzz, Paaaa, ...
+ * We use the fact that for equal prefix, longer strings are always
+ * higher than shorter ones. Strings of equal length are sorted alphabetically.
+ * This is achieved by sorting be length first, then using strcmp().
+ * If multiple prefixes are in use, the aliases with a given prefix will
+ * not necessarily be in a contiguous range of the vector, but they will
+ * be ordered such that for a given prefix, numercally higher aliases will
+ * always be sorted after lower ones.
+ */
+static int alias_compar(const void *p1, const void *p2)
+{
+	const char *alias1 = *((char * const *)p1);
+	const char *alias2 = *((char * const *)p2);
+
+	if (alias1 && alias2) {
+		ssize_t ldif = strlen(alias1) - strlen(alias2);
+
+		if (ldif)
+			return ldif;
+		return strcmp(alias1, alias2);
+	} else
+		/* Move NULL alias to the end */
+		return alias1 ? -1 : alias2 ? 1 : 0;
+}
+
 static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
 {
 	struct binding *bdg;
@@ -128,7 +157,7 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
 	 * sorted already.
 	 */
 	vector_foreach_slot_backwards(bindings, bdg, i) {
-		if ((cmp = strcmp(bdg->alias, alias)) <= 0)
+		if ((cmp = alias_compar(&bdg->alias, &alias)) <= 0)
 			break;
 	}
 
@@ -657,16 +686,10 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
 	return rc;
 }
 
-static int alias_compar(const void *p1, const void *p2)
+static int mp_alias_compar(const void *p1, const void *p2)
 {
-	const char *alias1 = (*(struct mpentry * const *)p1)->alias;
-	const char *alias2 = (*(struct mpentry * const *)p2)->alias;
-
-	if (alias1 && alias2)
-		return strcmp(alias1, alias2);
-	else
-		/* Move NULL alias to the end */
-		return alias1 ? -1 : alias2 ? 1 : 0;
+	return alias_compar(&((*(struct mpentry * const *)p1)->alias),
+			    &((*(struct mpentry * const *)p2)->alias));
 }
 
 /*
@@ -700,7 +723,7 @@ int check_alias_settings(const struct config *conf)
 	pthread_cleanup_push_cast(free_bindings, &bindings);
 	pthread_cleanup_push(cleanup_vector_free, mptable);
 
-	vector_sort(mptable, alias_compar);
+	vector_sort(mptable, mp_alias_compar);
 	vector_foreach_slot(mptable, mpe, i) {
 		if (!mpe->alias)
 			/*
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


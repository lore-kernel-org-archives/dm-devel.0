Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A80C00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 08:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661328745;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KgCf74O+B1v7DJGNDzBXOnR0tBE/+CjyZL44W+8yxa4=;
	b=Sd1EQg8ouCpU5DCGwicQCLrSqDfccmX69MovsIRFfo960mCz+PfS2+6meKDvIuSSkNjRwR
	7H95q7SqnsdpXgJ6p/r6m4GGbiYV8qOmpoxOXq1H9eamzyskCUNQJ3fvu2V1kPzRQf2sjX
	92dIR+VG6jJ9kHrU94QuJIeM3gHEvKg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-sLcG_Y7gOHGDV3_Tun827A-1; Wed, 24 Aug 2022 04:12:22 -0400
X-MC-Unique: sLcG_Y7gOHGDV3_Tun827A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09692185A7B2;
	Wed, 24 Aug 2022 08:12:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB4A9C15BCA;
	Wed, 24 Aug 2022 08:12:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C4BEF1946A42;
	Wed, 24 Aug 2022 08:12:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A07C21946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 08:12:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95FFD1415137; Wed, 24 Aug 2022 08:12:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9270C1415133
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:12:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77C75811130
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 08:12:19 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-461-QfuvAy8NMZGhTIaonvW8VA-1; Wed,
 24 Aug 2022 04:12:11 -0400
X-MC-Unique: QfuvAy8NMZGhTIaonvW8VA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 46E3633D36;
 Wed, 24 Aug 2022 08:12:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 05F6E13AC0;
 Wed, 24 Aug 2022 08:12:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id eE9DO1ndBWNqXwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 24 Aug 2022 08:12:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 24 Aug 2022 10:11:46 +0200
Message-Id: <20220824081147.29270-3-mwilck@suse.com>
In-Reply-To: <20220824081147.29270-1-mwilck@suse.com>
References: <20220824081147.29270-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 2/3] libmultipath: check_alias_settings():
 pre-sort mptable by alias
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

add_binding() contains an optimization; it assumes that the list of
bindings is alphabetically sorted by alias, and tries to maintain
this order.

But conf->mptable is sorted by wwid. Therefore check_alias_settings() may take
a long time if the mptable is large.

Create a copy of the mptable, sorted by alias, and use it for add_bindings().
This speeds up check_alias_settings by roughly a factor of 10 (0.1s vs. 1s)
for my test setup with 10000 entries in the mptable.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 548a118..284092b 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -672,6 +672,31 @@ static void cleanup_fclose(void *p)
 	fclose(p);
 }
 
+static int alias_compar(const void *p1, const void *p2)
+{
+	const char *alias1 = (*(struct mpentry * const *)p1)->alias;
+	const char *alias2 = (*(struct mpentry * const *)p2)->alias;
+	int cmp;
+
+	if (alias1 && alias2)
+		cmp = strcmp(alias1, alias2);
+	else
+		/* Move NULL alias to the end */
+		cmp = alias1 ? -1 : alias2 ? 1 : 0;
+
+	if (cmp)
+		return cmp;
+
+	/* Ensure stable sort, see wwid_compar() in config.c */
+	return  p1 < p2 ? -1 : p1 > p2 ? 1 : 0;
+}
+
+static void cleanup_vector_free(void *arg)
+{
+	if  (arg)
+		vector_free((vector)arg);
+}
+
 /*
  * check_alias_settings(): test for inconsistent alias configuration
  *
@@ -693,12 +718,24 @@ int check_alias_settings(const struct config *conf)
 	int can_write;
 	int rc = 0, i, fd;
 	Bindings bindings = {.allocated = 0, };
+	vector mptable = NULL;
 	struct mpentry *mpe;
 
+	mptable = vector_convert(NULL, conf->mptable, struct mpentry *, identity);
+	if (!mptable)
+		return -1;
+
 	pthread_cleanup_push_cast(free_bindings, &bindings);
-	vector_foreach_slot(conf->mptable, mpe, i) {
-		if (!mpe->wwid || !mpe->alias)
-			continue;
+	pthread_cleanup_push(cleanup_vector_free, mptable);
+
+	vector_sort(mptable, alias_compar);
+	vector_foreach_slot(mptable, mpe, i) {
+		if (!mpe->alias)
+			/*
+			 * alias_compar() sorts NULL alias at the end,
+			 * so we can stop if we encounter this.
+			 */
+			break;
 		if (add_binding(&bindings, mpe->alias, mpe->wwid) ==
 		    BINDING_CONFLICT) {
 			condlog(0, "ERROR: alias \"%s\" bound to multiple wwids in multipath.conf, "
@@ -710,6 +747,7 @@ int check_alias_settings(const struct config *conf)
 	}
 	/* This clears the bindings */
 	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
 
 	pthread_cleanup_push_cast(free_bindings, &bindings);
 	fd = open_file(conf->bindings_file, &can_write, BINDINGS_FILE_HEADER);
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


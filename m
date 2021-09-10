Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED6DC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 29A02611C0
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 29A02611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-pKSZNoCCPcSZwR2I4b7qIw-1; Fri, 10 Sep 2021 07:43:22 -0400
X-MC-Unique: pKSZNoCCPcSZwR2I4b7qIw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0911980124F;
	Fri, 10 Sep 2021 11:43:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDA5219D9B;
	Fri, 10 Sep 2021 11:43:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B85141806D03;
	Fri, 10 Sep 2021 11:43:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABgw4d010169 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:42:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B5CE7210FE24; Fri, 10 Sep 2021 11:42:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B125320C180E
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9903C800B36
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:58 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-287-fAd-iJlUMkmtjFvdZ0lsIw-1; Fri, 10 Sep 2021 07:42:54 -0400
X-MC-Unique: fAd-iJlUMkmtjFvdZ0lsIw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8FE5322435;
	Fri, 10 Sep 2021 11:42:53 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3854713D34;
	Fri, 10 Sep 2021 11:42:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id sKORC71EO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:53 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:40:55 +0200
Message-Id: <20210910114120.13665-11-mwilck@suse.com>
In-Reply-To: <20210910114120.13665-1-mwilck@suse.com>
References: <20210910114120.13665-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABgw4d010169
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 10/35] multipathd: add prototype for cli_handler
	functions
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Use a typedef instead of spelling out the function type everywhere.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c |  6 +++---
 multipathd/cli.h | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 4d6c37c..5213813 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -65,7 +65,7 @@ out:
 }
 
 int
-add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *))
+add_handler (uint64_t fp, cli_handler *fn)
 {
 	struct handler * h;
 
@@ -100,7 +100,7 @@ find_handler (uint64_t fp)
 }
 
 int
-set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
+set_handler_callback (uint64_t fp, cli_handler *fn)
 {
 	struct handler * h = find_handler(fp);
 
@@ -112,7 +112,7 @@ set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
 }
 
 int
-set_unlocked_handler_callback (uint64_t fp,int (*fn)(void *, char **, int *, void *))
+set_unlocked_handler_callback (uint64_t fp, cli_handler *fn)
 {
 	struct handler * h = find_handler(fp);
 
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 1e8948a..3dac1b4 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -124,16 +124,18 @@ struct key {
 	int has_param;
 };
 
+typedef int (cli_handler)(void *keywords, char **reply, int *len, void *data);
+
 struct handler {
 	uint64_t fingerprint;
 	int locked;
-	int (*fn)(void *, char **, int *, void *);
+	cli_handler *fn;
 };
 
 int alloc_handlers (void);
-int add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *));
-int set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
-int set_unlocked_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
+int add_handler (uint64_t fp, cli_handler *fn);
+int set_handler_callback (uint64_t fp, cli_handler *fn);
+int set_unlocked_handler_callback (uint64_t fp, cli_handler *fn);
 int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
 int load_keys (void);
 char * get_keyparam (vector v, uint64_t code);
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


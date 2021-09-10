Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F1CC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B7F0611B0
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B7F0611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-NWLeoLFzM8SienzWEUmnow-1; Fri, 10 Sep 2021 07:43:37 -0400
X-MC-Unique: NWLeoLFzM8SienzWEUmnow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA306802947;
	Fri, 10 Sep 2021 11:43:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FCE75C25A;
	Fri, 10 Sep 2021 11:43:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 694CB4EA3F;
	Fri, 10 Sep 2021 11:43:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh4Kt010336 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1077A20807F4; Fri, 10 Sep 2021 11:43:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B55D20807EA
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7D3F800C00
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:03 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-225-IWcbAADpNKeVEPubopIacg-1; Fri, 10 Sep 2021 07:43:02 -0400
X-MC-Unique: IWcbAADpNKeVEPubopIacg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1E6B22432;
	Fri, 10 Sep 2021 11:43:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 746BE13D34;
	Fri, 10 Sep 2021 11:43:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 4JTQGcREO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:43:00 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:14 +0200
Message-Id: <20210910114120.13665-30-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh4Kt010336
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 29/35] multipathd: uxlsnr: use parser to
	determine non-root commands
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Rather than using a separate poor-man's parser for checking root
commands, use the real parser. It will return "LIST" as first verb
for the read-only commands that non-root users may execute.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index cfff0ae..ff9604f 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -362,16 +362,15 @@ static int uxsock_trigger(struct client *c, void *trigger_data)
 
 	vecs = (struct vectors *)trigger_data;
 
-
-	if (!c->is_root &&
-	    (strncmp(c->cmd, "list", strlen("list")) != 0) &&
-	    (strncmp(c->cmd, "show", strlen("show")) != 0)) {
-		append_strbuf_str(&c->reply, "permission deny: need to be root");
-		return r;
-	}
-
 	r = parse_cmd(c);
 
+	if (r == 0 && c->cmdvec && VECTOR_SIZE(c->cmdvec) > 0) {
+		struct key *kw = VECTOR_SLOT(c->cmdvec, 0);
+
+		if (!c->is_root && kw->code != LIST)
+			r = EPERM;
+	}
+
 	if (r == 0 && c->handler)
 		r = execute_handler(c, vecs, uxsock_timeout / 1000);
 
@@ -381,10 +380,18 @@ static int uxsock_trigger(struct client *c, void *trigger_data)
 	}
 
 	if (r > 0) {
-		if (r == ETIMEDOUT)
+		switch(r) {
+		case ETIMEDOUT:
 			append_strbuf_str(&c->reply, "timeout\n");
-		else
+			break;
+		case EPERM:
+			append_strbuf_str(&c->reply,
+					  "permission deny: need to be root\n");
+			break;
+		default:
 			append_strbuf_str(&c->reply, "fail\n");
+			break;
+		}
 	}
 	else if (!r && get_strbuf_len(&c->reply) == 0) {
 		append_strbuf_str(&c->reply, "ok\n");
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


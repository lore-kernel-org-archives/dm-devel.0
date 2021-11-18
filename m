Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E13C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 195B56128E
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 195B56128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-vo4UQgHVMN6XH5q4R36cyA-1; Thu, 18 Nov 2021 18:06:10 -0500
X-MC-Unique: vo4UQgHVMN6XH5q4R36cyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3B6A802E64;
	Thu, 18 Nov 2021 23:06:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC1701980E;
	Thu, 18 Nov 2021 23:06:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 87D53181A1D1;
	Thu, 18 Nov 2021 23:06:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxD38002283 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFB881121315; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB9181121314
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D33BC800C00
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-125-puOEDRJUMnCmfpdCZa4LvQ-1; Thu, 18 Nov 2021 17:59:07 -0500
X-MC-Unique: puOEDRJUMnCmfpdCZa4LvQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE4EC2177B;
	Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66B0513B11;
	Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id cAkfF7ralmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:06 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:20 +0100
Message-Id: <20211118225840.19810-29-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxD38002283
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 28/48] multipathd: uxlsnr: use parser to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


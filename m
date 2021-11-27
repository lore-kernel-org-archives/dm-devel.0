Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21316C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-fwobokT5PNyez5xQl3Ei6Q-1; Sat, 27 Nov 2021 10:20:47 -0500
X-MC-Unique: fwobokT5PNyez5xQl3Ei6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC7F2393A8;
	Sat, 27 Nov 2021 15:20:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6ECF72FA5;
	Sat, 27 Nov 2021 15:20:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B4C334A70A;
	Sat, 27 Nov 2021 15:20:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJuDw000360 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E4CCA404727A; Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E10F34047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8D8B808784
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-21-3YM4Jfd_PJ-Wiz_0sPo0eA-1; Sat, 27 Nov 2021 10:19:53 -0500
X-MC-Unique: 3YM4Jfd_PJ-Wiz_0sPo0eA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55D8321637;
	Sat, 27 Nov 2021 15:19:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09E0213AAD;
	Sat, 27 Nov 2021 15:19:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id OJAeAJhMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:52 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:21 +0100
Message-Id: <20211127151929.7727-29-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJuDw000360
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 28/35] multipathd: uxlsnr: use parser to
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
index 2c434cd..62b9fe5 100644
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


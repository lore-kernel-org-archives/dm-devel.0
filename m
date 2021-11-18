Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0977C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:19:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C1926141B
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C1926141B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-FZudi6S0PGWo3z8mf8-Mhg-1; Thu, 18 Nov 2021 18:19:47 -0500
X-MC-Unique: FZudi6S0PGWo3z8mf8-Mhg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 993E2A40C6;
	Thu, 18 Nov 2021 23:19:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AA7B3AEF;
	Thu, 18 Nov 2021 23:19:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 572681832DD7;
	Thu, 18 Nov 2021 23:19:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINE8ij005128 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E1C7B40CFD11; Thu, 18 Nov 2021 23:14:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBD2C4010E8A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3930833A3A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:07 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-193-NuztPLyuPCeU1s0ZirXyEA-1; Thu, 18 Nov 2021 18:14:01 -0500
X-MC-Unique: NuztPLyuPCeU1s0ZirXyEA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C81D1FD3B;
	Thu, 18 Nov 2021 23:14:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0BA7413AA8;
	Thu, 18 Nov 2021 23:14:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id oCF6ADjelmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:00 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:21 +0100
Message-Id: <20211118231338.22358-5-mwilck@suse.com>
In-Reply-To: <20211118231338.22358-1-mwilck@suse.com>
References: <20211118231338.22358-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINE8ij005128
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 04/21] libmultipath: strbuf: add
	__get_strbuf_buf()
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

Add a function for internal use that allows direct manipulation
of the strbuf's content.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/strbuf.c |  5 +++++
 libmultipath/strbuf.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/libmultipath/strbuf.c b/libmultipath/strbuf.c
index a24a57d..f654594 100644
--- a/libmultipath/strbuf.c
+++ b/libmultipath/strbuf.c
@@ -15,6 +15,11 @@
 
 static const char empty_str[] = "";
 
+char *__get_strbuf_buf(struct strbuf *buf)
+{
+	return buf->buf;
+}
+
 const char *get_strbuf_str(const struct strbuf *buf)
 {
 	return buf->buf ? buf->buf : empty_str;
diff --git a/libmultipath/strbuf.h b/libmultipath/strbuf.h
index 5903572..41d7d54 100644
--- a/libmultipath/strbuf.h
+++ b/libmultipath/strbuf.h
@@ -54,6 +54,20 @@ void free_strbuf(struct strbuf *buf);
  */
 struct strbuf *new_strbuf(void);
 
+/**
+ * get_strbuf_buf(): retrieve a pointer to the strbuf's buffer
+ * @param buf: a struct strbuf
+ * @returns: pointer to the string written to the strbuf so far.
+ *
+ * INTERNAL ONLY.
+ * DANGEROUS: Unlike the return value of get_strbuf_str(),
+ * this string can be written to, modifying the strbuf's content.
+ * USE WITH CAUTION.
+ * If @strbuf was never written to, the function returns NULL.
+ * The return value of this function must not be free()d.
+ */
+char *__get_strbuf_buf(struct strbuf *buf);
+
 /**
  * get_strbuf_str(): retrieve string from strbuf
  * @param buf: a struct strbuf
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


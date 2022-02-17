Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B0DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 19:56:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-l_RODNmgPreattviNhiXPQ-1; Thu, 17 Feb 2022 14:56:01 -0500
X-MC-Unique: l_RODNmgPreattviNhiXPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F094801AC5;
	Thu, 17 Feb 2022 19:55:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22C3056A81;
	Thu, 17 Feb 2022 19:55:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F20344CA9B;
	Thu, 17 Feb 2022 19:55:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HJthYO005156 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 14:55:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3EF776EE; Thu, 17 Feb 2022 19:55:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF34D76E9
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F864100E658
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-638-rNmN1zaXPxi1fNrxzljo9Q-1; Thu, 17 Feb 2022 14:55:38 -0500
X-MC-Unique: rNmN1zaXPxi1fNrxzljo9Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 390F31F76A;
	Thu, 17 Feb 2022 19:55:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE85B13476;
	Thu, 17 Feb 2022 19:55:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id EC/8NzioDmLBVgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 17 Feb 2022 19:55:36 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Feb 2022 20:55:32 +0100
Message-Id: <20220217195533.4251-4-mwilck@suse.com>
In-Reply-To: <20220217195533.4251-1-mwilck@suse.com>
References: <20220217195533.4251-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21HJthYO005156
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/4] libmultipath: enable defining a static
	bitfield
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The STATIC_BITFIELD macro allows defining a static variable holding
a bitfield of constant length.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libmultipath/util.h b/libmultipath/util.h
index 79d9f32..5a44018 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -82,6 +82,16 @@ struct bitfield {
 	bitfield_t bits[];
 };
 
+#define STATIC_BITFIELD(name, length)					\
+	static struct {							\
+		unsigned int len;					\
+		bitfield_t bits[((length) - 1) / bits_per_slot + 1];	\
+	} __static__ ## name = {					\
+		.len = (length),					\
+		.bits = { 0, },						\
+	}; \
+	struct bitfield *name = (struct bitfield *)& __static__ ## name
+
 struct bitfield *alloc_bitfield(unsigned int maxbit);
 
 void _log_bitfield_overflow(const char *f, unsigned int bit, unsigned int len);
-- 
2.35.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


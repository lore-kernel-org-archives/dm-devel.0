Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA68C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B25476128E
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B25476128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-4MUQLrZyOGamiPoOM_F_Xw-1; Thu, 18 Nov 2021 18:03:32 -0500
X-MC-Unique: 4MUQLrZyOGamiPoOM_F_Xw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75E811018720;
	Thu, 18 Nov 2021 23:03:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B8A11017E35;
	Thu, 18 Nov 2021 23:03:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 384841832DD9;
	Thu, 18 Nov 2021 23:03:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxJt4002400 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 24BBD404727A; Thu, 18 Nov 2021 22:59:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 209294047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD138022F4
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:18 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-230-EQr2n3UbP3apaqyIbROH7g-1; Thu, 18 Nov 2021 17:59:15 -0500
X-MC-Unique: EQr2n3UbP3apaqyIbROH7g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C19F71FD3A;
	Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A8F813B11;
	Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id iGHIG8HalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:13 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:40 +0100
Message-Id: <20211118225840.19810-49-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxJt4002400
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 48/48] libmultipath: add path wildcard "%I"
	for init state
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Enable printing pp->initialized with 'multipathd show paths format "%I"'.
This is supposed to go on top of Ben's "multipathd: remove udev settle
dependency" series, to simplify checking multipathd's state.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c   | 21 +++++++++++++++++++++
 libmultipath/structs.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index d2ef010..e61349f 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -504,6 +504,26 @@ snprint_dm_path_state (struct strbuf *buff, const struct path * pp)
 	}
 }
 
+static int snprint_initialized(struct strbuf *buff, const struct path * pp)
+{
+	static const char *init_state_name[] = {
+		[INIT_NEW] = "new",
+		[INIT_FAILED] = "failed",
+		[INIT_MISSING_UDEV] = "udev-missing",
+		[INIT_REQUESTED_UDEV] = "udev-requested",
+		[INIT_OK] = "ok",
+		[INIT_REMOVED] = "removed",
+		[INIT_PARTIAL] = "partial",
+	};
+	const char *str;
+
+	if (pp->initialized < INIT_NEW || pp->initialized >= __INIT_LAST)
+		str = "undef";
+	else
+		str = init_state_name[pp->initialized];
+	return append_strbuf_str(buff, str);
+}
+
 static int
 snprint_vpr (struct strbuf *buff, const struct path * pp)
 {
@@ -804,6 +824,7 @@ struct path_data pd[] = {
 	{'g', "vpd page data", 0, snprint_path_vpd_data},
 	{'0', "failures",      0, snprint_path_failures},
 	{'P', "protocol",      0, snprint_path_protocol},
+	{'I', "init_st",       0, snprint_initialized},
 	{0, NULL, 0 , NULL}
 };
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c21d1ed..c0f8929 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -206,6 +206,7 @@ enum initialized_states {
 	 * change uevent is received.
 	 */
 	INIT_PARTIAL,
+	__INIT_LAST,
 };
 
 enum prkey_sources {
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FC2C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5B96E61A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5B96E61A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-Nv-5lkB9Na2bPWpcyVDusg-1; Thu, 18 Nov 2021 18:04:29 -0500
X-MC-Unique: Nv-5lkB9Na2bPWpcyVDusg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 851DA802C96;
	Thu, 18 Nov 2021 23:04:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AC9160CC9;
	Thu, 18 Nov 2021 23:04:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E55111832E07;
	Thu, 18 Nov 2021 23:04:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx3X6002017 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A2A8940CFD12; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D81F40CFD11
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8472D811E7A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-305-Fn-h1HeXM_2x6m6OMAYBoA-1; Thu, 18 Nov 2021 17:58:59 -0500
X-MC-Unique: Fn-h1HeXM_2x6m6OMAYBoA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 344EC218B8;
	Thu, 18 Nov 2021 22:58:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E279013B11;
	Thu, 18 Nov 2021 22:58:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id qMVSNbHalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:58:57 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:57:56 +0100
Message-Id: <20211118225840.19810-5-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx3X6002017
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 04/48] libmultipath: print: add
	__snprint_config()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

exactly like snprint_config(), but takes a struct strbuf * as argument.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version |  5 +++++
 libmultipath/print.c              | 34 +++++++++++++++++++++----------
 libmultipath/print.h              |  2 ++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 98ec502..2fb2547 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -293,3 +293,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_10.1.0 {
+global:
+	__snprint_config;
+} LIBMULTIPATH_10.0.0;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 2fb9f4e..d2ef010 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1756,24 +1756,36 @@ static int snprint_blacklist_except(const struct config *conf,
 	return get_strbuf_len(buff) - initial_len;
 }
 
+int __snprint_config(const struct config *conf, struct strbuf *buff,
+		     const struct _vector *hwtable, const struct _vector *mpvec)
+{
+	int rc;
+
+	if ((rc = snprint_defaults(conf, buff)) < 0 ||
+	    (rc = snprint_blacklist(conf, buff)) < 0 ||
+	    (rc = snprint_blacklist_except(conf, buff)) < 0 ||
+	    (rc = snprint_hwtable(conf, buff,
+				  hwtable ? hwtable : conf->hwtable)) < 0 ||
+	    (rc = snprint_overrides(conf, buff, conf->overrides)) < 0)
+		return rc;
+
+	if (VECTOR_SIZE(conf->mptable) > 0 ||
+	    (mpvec != NULL && VECTOR_SIZE(mpvec) > 0))
+		if ((rc = snprint_mptable(conf, buff, mpvec)) < 0)
+			return rc;
+
+	return 0;
+}
+
 char *snprint_config(const struct config *conf, int *len,
 		     const struct _vector *hwtable, const struct _vector *mpvec)
 {
 	STRBUF_ON_STACK(buff);
 	char *reply;
-	int rc;
+	int rc = __snprint_config(conf, &buff, hwtable, mpvec);
 
-	if ((rc = snprint_defaults(conf, &buff)) < 0 ||
-	    (rc = snprint_blacklist(conf, &buff)) < 0 ||
-	    (rc = snprint_blacklist_except(conf, &buff)) < 0 ||
-	    (rc = snprint_hwtable(conf, &buff,
-				  hwtable ? hwtable : conf->hwtable)) < 0 ||
-	    (rc = snprint_overrides(conf, &buff, conf->overrides)) < 0)
+	if (rc < 0)
 		return NULL;
-	if (VECTOR_SIZE(conf->mptable) > 0 ||
-	    (mpvec != NULL && VECTOR_SIZE(mpvec) > 0))
-		if ((rc = snprint_mptable(conf, &buff, mpvec)) < 0)
-			return NULL;
 
 	if (len)
 		*len = get_strbuf_len(&buff);
diff --git a/libmultipath/print.h b/libmultipath/print.h
index c6674a5..b149275 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -54,6 +54,8 @@ int _snprint_multipath_topology (const struct gen_multipath *, struct strbuf *,
 #define snprint_multipath_topology(buf, mpp, v) \
 	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, v)
 int snprint_multipath_topology_json(struct strbuf *, const struct vectors *vecs);
+int __snprint_config(const struct config *conf, struct strbuf *buff,
+		     const struct _vector *hwtable, const struct _vector *mpvec);
 char *snprint_config(const struct config *conf, int *len,
 		     const struct _vector *hwtable,
 		     const struct _vector *mpvec);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


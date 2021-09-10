Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB5FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 678A461153
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 678A461153
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-qCiSc0tbOKOdx8w5tcdJFA-1; Fri, 10 Sep 2021 07:43:21 -0400
X-MC-Unique: qCiSc0tbOKOdx8w5tcdJFA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78246802C87;
	Fri, 10 Sep 2021 11:43:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B798188E4;
	Fri, 10 Sep 2021 11:43:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 272384EA29;
	Fri, 10 Sep 2021 11:43:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABgwbf010161 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:42:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 70E6720807F0; Fri, 10 Sep 2021 11:42:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ACB020BC8F5
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 880A88934E0
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:54 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-283-6raRnfzGPiSATbI7zC7fIg-1; Fri, 10 Sep 2021 07:42:52 -0400
X-MC-Unique: 6raRnfzGPiSATbI7zC7fIg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 475D422433;
	Fri, 10 Sep 2021 11:42:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F11D513D34;
	Fri, 10 Sep 2021 11:42:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 8O3eOLpEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:50 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:40:49 +0200
Message-Id: <20210910114120.13665-5-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABgwbf010161
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 04/35] libmultipath: print: add __snprint_config()
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

exactly like snprint_config(), but takes a struct strbuf * as argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version |  5 +++++
 libmultipath/print.c              | 34 +++++++++++++++++++++----------
 libmultipath/print.h              |  2 ++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 2107c51..b2feee2 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -297,3 +297,8 @@ LIBMULTIPATH_9.2.0 {
 global:
 	set_wakeup_fn;
 } LIBMULTIPATH_9.1.0;
+
+LIBMULTIPATH_9.3.0 {
+global:
+	__snprint_config;
+} LIBMULTIPATH_9.2.0;
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
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


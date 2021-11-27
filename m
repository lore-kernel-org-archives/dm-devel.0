Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184C6C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:22:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-182L-TYLOQO2QJF8N8p4BQ-1; Sat, 27 Nov 2021 10:22:36 -0500
X-MC-Unique: 182L-TYLOQO2QJF8N8p4BQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AA8A801B17;
	Sat, 27 Nov 2021 15:22:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 625E71007625;
	Sat, 27 Nov 2021 15:22:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F71E473D1;
	Sat, 27 Nov 2021 15:22:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJorE032715 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A93291121319; Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FFDC112131E
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A79F808784
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:46 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-378-AmhRTuAnO76y8fFk_-2VTQ-1; Sat, 27 Nov 2021 10:19:44 -0500
X-MC-Unique: AmhRTuAnO76y8fFk_-2VTQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B8871FCA3;
	Sat, 27 Nov 2021 15:19:43 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C478313AAD;
	Sat, 27 Nov 2021 15:19:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +Eq3LY5MomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:42 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:18:57 +0100
Message-Id: <20211127151929.7727-5-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJorE032715
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 04/35] libmultipath: print: add
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 83aaa83..547a71c 100644
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


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB30C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:23:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-X4pvxR9APd-4Vydx5pFP2w-1; Sat, 27 Nov 2021 10:23:02 -0500
X-MC-Unique: X4pvxR9APd-4Vydx5pFP2w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 531663E774;
	Sat, 27 Nov 2021 15:22:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39FB91E6;
	Sat, 27 Nov 2021 15:22:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 10BE050485;
	Sat, 27 Nov 2021 15:22:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFKeht000647 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A2DA94047272; Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E5B8404727C
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84C3F811E84
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-589-IFGatR15OHCdUBqpEJjj_A-1; Sat, 27 Nov 2021 10:20:36 -0500
X-MC-Unique: IFGatR15OHCdUBqpEJjj_A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 692B1212CA;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2FCED13AAD;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kOWFCcNMomFrFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:20:35 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:58 +0100
Message-Id: <20211127152006.8035-4-mwilck@suse.com>
In-Reply-To: <20211127152006.8035-1-mwilck@suse.com>
References: <20211127152006.8035-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFKeht000647
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 03/11] libmultipath: make pd_lookup() etc. return
	an index
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

This will allow us to remove the mutable width field from path_data.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 64 ++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 4992cc8..37222bf 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -976,73 +976,70 @@ _get_multipath_layout (const struct _vector *gmvec,
 	}
 }
 
-static struct multipath_data *
-mpd_lookup(char wildcard)
+static int mpd_lookup(char wildcard)
 {
 	int i;
 
 	for (i = 0; mpd[i].header; i++)
 		if (mpd[i].wildcard == wildcard)
-			return &mpd[i];
+			return i;
 
-	return NULL;
+	return -1;
 }
 
 int snprint_multipath_attr(const struct gen_multipath* gm,
 			   struct strbuf *buf, char wildcard)
 {
 	const struct multipath *mpp = gen_multipath_to_dm(gm);
-	struct multipath_data *mpd = mpd_lookup(wildcard);
+	int i = mpd_lookup(wildcard);
 
-	if (mpd == NULL)
+	if (i == -1)
 		return 0;
-	return mpd->snprint(buf, mpp);
+	return mpd[i].snprint(buf, mpp);
 }
 
-static struct path_data *
-pd_lookup(char wildcard)
+static int pd_lookup(char wildcard)
 {
 	int i;
 
 	for (i = 0; pd[i].header; i++)
 		if (pd[i].wildcard == wildcard)
-			return &pd[i];
+			return i;
 
-	return NULL;
+	return -1;
 }
 
 int snprint_path_attr(const struct gen_path* gp,
 		      struct strbuf *buf, char wildcard)
 {
 	const struct path *pp = gen_path_to_dm(gp);
-	struct path_data *pd = pd_lookup(wildcard);
+	int i = pd_lookup(wildcard);
 
-	if (pd == NULL)
+	if (i == -1)
 		return 0;
-	return pd->snprint(buf, pp);
+	return pd[i].snprint(buf, pp);
 }
 
-static struct pathgroup_data *
-pgd_lookup(char wildcard)
+static int pgd_lookup(char wildcard)
 {
 	int i;
 
 	for (i = 0; pgd[i].header; i++)
 		if (pgd[i].wildcard == wildcard)
-			return &pgd[i];
+			return i;
 
-	return NULL;
+	return -1;
 }
 
 int snprint_pathgroup_attr(const struct gen_pathgroup* gpg,
 			   struct strbuf *buf, char wildcard)
 {
 	const struct pathgroup *pg = gen_pathgroup_to_dm(gpg);
-	struct pathgroup_data *pdg = pgd_lookup(wildcard);
+	int i = pgd_lookup(wildcard);
 
-	if (pdg == NULL)
+	if (i == -1)
 		return 0;
-	return pdg->snprint(buf, pg);
+	return pgd[i].snprint(buf, pg);
 }
 
 int snprint_multipath_header(struct strbuf *line, const char *format)
@@ -1053,12 +1050,15 @@ int snprint_multipath_header(struct strbuf *line, const char *format)
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
+		int iwc;
+
 		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
-		if (!(data = mpd_lookup(*format)))
+		if ((iwc = mpd_lookup(*format)) == -1)
 			continue; /* unknown wildcard */
+		data = &mpd[iwc];
 
 		if ((rc = append_strbuf_str(line, data->header)) < 0)
 			return rc;
@@ -1081,12 +1081,15 @@ int _snprint_multipath(const struct gen_multipath *gmp,
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
+		int iwc;
+
 		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
-		if (!(data = mpd_lookup(*format)))
+		if ((iwc = mpd_lookup(*format)) == -1)
 			continue; /* unknown wildcard */
+		data = &mpd[iwc];
 
 		if ((rc = gmp->ops->snprint(gmp, line, *format)) < 0)
 			return rc;
@@ -1108,12 +1111,15 @@ int snprint_path_header(struct strbuf *line, const char *format)
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
+		int iwc;
+
 		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
-		if (!(data = pd_lookup(*format)))
+		if ((iwc = pd_lookup(*format)) == -1)
 			continue; /* unknown wildcard */
+		data = &pd[iwc];
 
 		if ((rc = append_strbuf_str(line, data->header)) < 0)
 			return rc;
@@ -1136,12 +1142,15 @@ int _snprint_path(const struct gen_path *gp, struct strbuf *line,
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
+		int iwc;
+
 		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
-		if (!(data = pd_lookup(*format)))
+		if ((iwc = pd_lookup(*format)) == -1)
 			continue; /* unknown wildcard */
+		data = &pd[iwc];
 
 		if ((rc = gp->ops->snprint(gp, line, *format)) < 0)
 			return rc;
@@ -1164,12 +1173,15 @@ int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
+		int iwc;
+
 		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
-		if (!(data = pgd_lookup(*format)))
+		if ((iwc = pgd_lookup(*format)) == -1)
 			continue; /* unknown wildcard */
+		data = &pgd[iwc];
 
 		if ((rc = ggp->ops->snprint(ggp, line, *format)) < 0)
 			return rc;
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


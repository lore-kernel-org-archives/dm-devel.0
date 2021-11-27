Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8AD5C4332F
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:21:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-11-jVvUVCNSPiWSqdAhNzSC-A-1; Sat, 27 Nov 2021 10:20:58 -0500
X-MC-Unique: jVvUVCNSPiWSqdAhNzSC-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DE1A814331;
	Sat, 27 Nov 2021 15:20:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 657BE5D6D7;
	Sat, 27 Nov 2021 15:20:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 43AA3180C667;
	Sat, 27 Nov 2021 15:20:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFKdNj000638 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5D10C40CFD13; Sat, 27 Nov 2021 15:20:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 581D840CFD07
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F25480122B
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-598-b-DVk1hUPieuN8-b9CjcFg-1; Sat, 27 Nov 2021 10:20:36 -0500
X-MC-Unique: b-DVk1hUPieuN8-b9CjcFg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AEF7B212CB;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 76C9513AAD;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id GG3dGsNMomFrFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:20:35 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:59 +0100
Message-Id: <20211127152006.8035-5-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFKdNj000638
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 04/11] libmultipath: use ARRAY_SIZE for iterating
	over wildcard arrays
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

Avoid the extra empty element at the end of the array, and use the
ARRAY_SIZE paradigm that we've adopted elsewhere in multipath-tools.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 37222bf..fcbaa5a 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -817,7 +817,6 @@ static struct multipath_data mpd[] = {
 	{'e', "rev",           0, snprint_multipath_rev},
 	{'G', "foreign",       0, snprint_multipath_foreign},
 	{'g', "vpd page data", 0, snprint_multipath_vpd_data},
-	{0, NULL, 0 , NULL}
 };
 
 static struct path_data pd[] = {
@@ -846,7 +845,6 @@ static struct path_data pd[] = {
 	{'0', "failures",      0, snprint_path_failures},
 	{'P', "protocol",      0, snprint_path_protocol},
 	{'I', "init_st",       0, snprint_initialized},
-	{0, NULL, 0 , NULL}
 };
 
 static struct pathgroup_data pgd[] = {
@@ -854,31 +852,31 @@ static struct pathgroup_data pgd[] = {
 	{'p', "pri",           0, snprint_pg_pri},
 	{'t', "dm_st",         0, snprint_pg_state},
 	{'M', "marginal_st",   0, snprint_pg_marginal},
-	{0, NULL, 0 , NULL}
 };
 
 int snprint_wildcards(struct strbuf *buff)
 {
 	int initial_len = get_strbuf_len(buff);
-	int i, rc;
+	unsigned int i;
+	int rc;
 
 	if ((rc = append_strbuf_str(buff, "multipath format wildcards:\n")) < 0)
 		return rc;
-	for (i = 0; mpd[i].header; i++)
+	for (i = 0; i < ARRAY_SIZE(mpd); i++)
 		if ((rc = print_strbuf(buff, "%%%c  %s\n",
 				       mpd[i].wildcard, mpd[i].header)) < 0)
 			return rc;
 
 	if ((rc = append_strbuf_str(buff, "\npath format wildcards:\n")) < 0)
 		return rc;
-	for (i = 0; pd[i].header; i++)
+	for (i = 0; i < ARRAY_SIZE(pd); i++)
 		if ((rc = print_strbuf(buff, "%%%c  %s\n",
 				       pd[i].wildcard, pd[i].header)) < 0)
 			return rc;
 
 	if ((rc = append_strbuf_str(buff, "\npathgroup format wildcards:\n")) < 0)
 		return rc;
-	for (i = 0; pgd[i].header; i++)
+	for (i = 0; i < ARRAY_SIZE(pgd); i++)
 		if ((rc = print_strbuf(buff, "%%%c  %s\n",
 				       pgd[i].wildcard, pgd[i].header)) < 0)
 			return rc;
@@ -915,10 +913,10 @@ reset_width(unsigned int *width, enum layout_reset reset, const char *header)
 void
 _get_path_layout (const struct _vector *gpvec, enum layout_reset reset)
 {
-	int i, j;
+	unsigned int i, j;
 	const struct gen_path *gp;
 
-	for (j = 0; pd[j].header; j++) {
+        for (j = 0; j < ARRAY_SIZE(pd); j++) {
 		STRBUF_ON_STACK(buff);
 
 		reset_width(&pd[j].width, reset, pd[j].header);
@@ -937,9 +935,9 @@ _get_path_layout (const struct _vector *gpvec, enum layout_reset reset)
 static void
 reset_multipath_layout (void)
 {
-	int i;
+	unsigned int i;
 
-	for (i = 0; mpd[i].header; i++)
+	for (i = 0; i < ARRAY_SIZE(mpd); i++)
 		mpd[i].width = 0;
 }
 
@@ -956,10 +954,10 @@ void
 _get_multipath_layout (const struct _vector *gmvec,
 			    enum layout_reset reset)
 {
-	int i, j;
+	unsigned int i, j;
 	const struct gen_multipath * gm;
 
-	for (j = 0; mpd[j].header; j++) {
+	for (j = 0; j < ARRAY_SIZE(mpd); j++) {
 		STRBUF_ON_STACK(buff);
 
 		reset_width(&mpd[j].width, reset, mpd[j].header);
@@ -978,9 +976,9 @@ _get_multipath_layout (const struct _vector *gmvec,
 
 static int mpd_lookup(char wildcard)
 {
-	int i;
+	unsigned int i;
 
-	for (i = 0; mpd[i].header; i++)
+	for (i = 0; i < ARRAY_SIZE(mpd); i++)
 		if (mpd[i].wildcard == wildcard)
 			return i;
 
@@ -1000,9 +998,9 @@ int snprint_multipath_attr(const struct gen_multipath* gm,
 
 static int pd_lookup(char wildcard)
 {
-	int i;
+	unsigned int i;
 
-	for (i = 0; pd[i].header; i++)
+	for (i = 0; i < ARRAY_SIZE(pd); i++)
 		if (pd[i].wildcard == wildcard)
 			return i;
 
@@ -1022,9 +1020,9 @@ int snprint_path_attr(const struct gen_path* gp,
 
 static int pgd_lookup(char wildcard)
 {
-	int i;
+	unsigned int i;
 
-	for (i = 0; pgd[i].header; i++)
+	for (i = 0; i < ARRAY_SIZE(pgd); i++)
 		if (pgd[i].wildcard == wildcard)
 			return i;
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


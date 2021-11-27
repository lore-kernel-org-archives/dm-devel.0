Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95CE0C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:21:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-LaMtyuQ-PA2OVUlB97sZcA-1; Sat, 27 Nov 2021 10:21:05 -0500
X-MC-Unique: LaMtyuQ-PA2OVUlB97sZcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1EC381CCB8;
	Sat, 27 Nov 2021 15:20:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACEED6C350;
	Sat, 27 Nov 2021 15:20:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B4BB1802FEA;
	Sat, 27 Nov 2021 15:20:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFKf7a000682 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A05C02026D69; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C3192026D65
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83F28101AA64
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-142-l7VhbEbBNGGxXPECMxCFaw-1; Sat, 27 Nov 2021 10:20:37 -0500
X-MC-Unique: l7VhbEbBNGGxXPECMxCFaw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 006FA1FD2A;
	Sat, 27 Nov 2021 15:20:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC54513AAD;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kDzkK8NMomFrFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:20:35 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:20:00 +0100
Message-Id: <20211127152006.8035-6-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFKf7a000682
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 05/11] libmultipath: drop padding code in
	_snprint_pathgroup()
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

We don't use padding for pathgroup fields, field width is always 0.
Remove this dead code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index fcbaa5a..924bca3 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1167,25 +1167,16 @@ int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
 {
 	int initial_len = get_strbuf_len(line);
 	const char *f;
-	struct pathgroup_data *data;
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
-		int iwc;
-
 		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
-		if ((iwc = pgd_lookup(*format)) == -1)
-			continue; /* unknown wildcard */
-		data = &pgd[iwc];
 
 		if ((rc = ggp->ops->snprint(ggp, line, *format)) < 0)
 			return rc;
-		else if ((unsigned int)rc < data->width)
-			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
-				return rc;
 	}
 
 	if ((rc = print_strbuf(line, "%s\n", format)) < 0)
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


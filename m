Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639B8C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:21:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-6q00EkxeMuisyKojObmClw-1; Sat, 27 Nov 2021 10:20:55 -0500
X-MC-Unique: 6q00EkxeMuisyKojObmClw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E5491006AA2;
	Sat, 27 Nov 2021 15:20:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 082122B178;
	Sat, 27 Nov 2021 15:20:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DAD06180BAD1;
	Sat, 27 Nov 2021 15:20:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFKfDx000661 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 02D582026D11; Sat, 27 Nov 2021 15:20:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F27D92026D69
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 789B4811E78
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:39 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-302-h06ND8TFPyqxXX82PaugZw-1; Sat, 27 Nov 2021 10:20:37 -0500
X-MC-Unique: h06ND8TFPyqxXX82PaugZw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 45C6F1FD36;
	Sat, 27 Nov 2021 15:20:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C73413AAD;
	Sat, 27 Nov 2021 15:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id MKoGAcRMomFrFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:20:36 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:20:01 +0100
Message-Id: <20211127152006.8035-7-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFKfDx000661
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 06/11] libmultipath: snprint_foreign_topology():
	split out lockless variant
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

Factor out the lockless part, which we'll call from elsewhere in a
future patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index e091a1d..cb8765c 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -498,19 +498,12 @@ void foreign_multipath_layout(void)
 	pthread_cleanup_pop(1);
 }
 
-int snprint_foreign_topology(struct strbuf *buf, int verbosity)
+static int __snprint_foreign_topology(struct strbuf *buf, int verbosity)
 {
 	struct foreign *fgn;
 	int i;
 	size_t initial_len = get_strbuf_len(buf);
 
-	rdlock_foreigns();
-	if (foreigns == NULL) {
-		unlock_foreigns(NULL);
-		return 0;
-	}
-	pthread_cleanup_push(unlock_foreigns, NULL);
-
 	vector_foreach_slot(foreigns, fgn, i) {
 		const struct _vector *vec;
 		const struct gen_multipath *gm;
@@ -531,10 +524,24 @@ int snprint_foreign_topology(struct strbuf *buf, int verbosity)
 		pthread_cleanup_pop(1);
 	}
 
-	pthread_cleanup_pop(1);
 	return get_strbuf_len(buf) - initial_len;
 }
 
+int snprint_foreign_topology(struct strbuf *buf, int verbosity)
+{
+	int rc;
+
+        rdlock_foreigns();
+	if (foreigns == NULL) {
+		unlock_foreigns(NULL);
+		return 0;
+	}
+	pthread_cleanup_push(unlock_foreigns, NULL);
+	rc = __snprint_foreign_topology(buf, verbosity);
+	pthread_cleanup_pop(1);
+	return rc;
+}
+
 void print_foreign_topology(int verbosity)
 {
 	STRBUF_ON_STACK(buf);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7FCC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:23:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-pvVRGh0TNrG9Msfn5Vi2fA-1; Sat, 27 Nov 2021 10:22:59 -0500
X-MC-Unique: pvVRGh0TNrG9Msfn5Vi2fA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7DA01006AA8;
	Sat, 27 Nov 2021 15:22:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1B8C19C79;
	Sat, 27 Nov 2021 15:22:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9F49150483;
	Sat, 27 Nov 2021 15:22:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFKeCU000643 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:20:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6C6D3404727A; Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 687794047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E61B80A0AC
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:20:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-379-D2O1d1deNEWYBN53vqGv0g-1; Sat, 27 Nov 2021 10:20:36 -0500
X-MC-Unique: D2O1d1deNEWYBN53vqGv0g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 228D71FD26;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DC5AB13AAD;
	Sat, 27 Nov 2021 15:20:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 2L+xM8JMomFrFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:20:34 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:57 +0100
Message-Id: <20211127152006.8035-3-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFKeCU000643
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 02/11] libmultipath: move path_data etc. to
	print.c
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

These structs are only used in print.c

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 21 +++++++++++++++++++++
 libmultipath/print.h | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 938eaad..4992cc8 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -100,6 +100,27 @@
 
 #define PROGRESS_LEN  10
 
+struct path_data {
+	char wildcard;
+	char * header;
+	unsigned int width;
+	int (*snprint)(struct strbuf *, const struct path * pp);
+};
+
+struct multipath_data {
+	char wildcard;
+	char * header;
+	unsigned int width;
+	int (*snprint)(struct strbuf *, const struct multipath * mpp);
+};
+
+struct pathgroup_data {
+	char wildcard;
+	char * header;
+	unsigned int width;
+	int (*snprint)(struct strbuf *, const struct pathgroup * pgp);
+};
+
 #define MAX(x,y) (((x) > (y)) ? (x) : (y))
 #define MIN(x,y) (((x) > (y)) ? (y) : (x))
 /*
diff --git a/libmultipath/print.h b/libmultipath/print.h
index b149275..4322f6e 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -9,27 +9,6 @@
 
 struct strbuf;
 
-struct path_data {
-	char wildcard;
-	char * header;
-	unsigned int width;
-	int (*snprint)(struct strbuf *, const struct path * pp);
-};
-
-struct multipath_data {
-	char wildcard;
-	char * header;
-	unsigned int width;
-	int (*snprint)(struct strbuf *, const struct multipath * mpp);
-};
-
-struct pathgroup_data {
-	char wildcard;
-	char * header;
-	unsigned int width;
-	int (*snprint)(struct strbuf *, const struct pathgroup * pgp);
-};
-
 enum layout_reset {
 	LAYOUT_RESET_NOT,
 	LAYOUT_RESET_ZERO,
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


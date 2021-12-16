Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9C5C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:58:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-Fj4ljBlMPA6G-LXAcSsVQw-1; Thu, 16 Dec 2021 07:58:20 -0500
X-MC-Unique: Fj4ljBlMPA6G-LXAcSsVQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF7EE100C660;
	Thu, 16 Dec 2021 12:58:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 912195BE0C;
	Thu, 16 Dec 2021 12:58:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 568584CA9B;
	Thu, 16 Dec 2021 12:58:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BGCtLui020368 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Dec 2021 07:55:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2BAAD492D4E; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27820492D4D
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DE788001E9
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-606-EUQqk1O8PAyJWD9b4_frxA-1; Thu, 16 Dec 2021 07:55:19 -0500
X-MC-Unique: EUQqk1O8PAyJWD9b4_frxA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4053021637;
	Thu, 16 Dec 2021 12:55:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 099A013E3B;
	Thu, 16 Dec 2021 12:55:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id aMV8ADU3u2FVYQAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Dec 2021 12:55:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Dec 2021 13:55:02 +0100
Message-Id: <20211216125502.15867-6-mwilck@suse.com>
In-Reply-To: <20211216125502.15867-1-mwilck@suse.com>
References: <20211216125502.15867-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BGCtLui020368
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 5/5] libmpathpersist: cleanup mpathpr.h
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

>From now on this header contains only symbols that need to be
accessed from multiple sources of libmpathpersist, but not from
libmultipath or other source files (those go into
libmpathpersist_int.h).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 14 +++++++++++
 libmpathpersist/mpathpr.h           | 37 ++++-------------------------
 2 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 91bc35a..c6fc287 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -33,7 +33,21 @@
 #include "mpathpr.h"
 #include "mpath_pr_ioctl.h"
 
+struct prout_param {
+	char dev[FILE_NAME_SIZE];
+	int rq_servact;
+	int rq_scope;
+	unsigned int rq_type;
+	struct prout_param_descriptor  *paramp;
+	int noisy;
+	int status;
+};
 
+struct threadinfo {
+	int status;
+	pthread_t id;
+	struct prout_param param;
+};
 
 static int mpath_send_prin_activepath (char * dev, int rq_servact,
 				struct prin_resp * resp, int noisy)
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 59411e6..39a7d8e 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -1,42 +1,13 @@
 #ifndef MPATHPR_H
 #define MPATHPR_H
 
-#include "structs.h" /* FILE_NAME_SIZE */
-
-struct prin_param {
-	char dev[FILE_NAME_SIZE];
-	int rq_servact;
-	struct prin_resp *resp;
-	int noisy;
-	int status;
-};
-
-struct prout_param {
-	char dev[FILE_NAME_SIZE];
-	int rq_servact;
-	int rq_scope;
-	unsigned int rq_type;
-	struct prout_param_descriptor  *paramp;
-	int noisy;
-	int status;
-};
-
-struct threadinfo {
-	int status;
-	pthread_t id;
-	struct prout_param param;
-};
-
-int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy);
-int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
-		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
-void * _mpath_pr_update (void *arg);
-void dumpHex(const char* , int len, int no_ascii);
+/*
+ * This header file contains symbols that are only used by
+ * libmpathpersist internally.
+ */
 
 int update_prflag(char *mapname, int set);
 int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t sa_flags);
 #define update_prkey(mapname, prkey) update_prkey_flags(mapname, prkey, 0)
-void * mpath_alloc_prin_response(int prin_sa);
-int update_map_pr(struct multipath *mpp);
 
 #endif
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


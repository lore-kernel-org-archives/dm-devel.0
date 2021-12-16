Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D4DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:56:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-kDel3FXMN2S3mXwzqB4i5w-1; Thu, 16 Dec 2021 07:56:10 -0500
X-MC-Unique: kDel3FXMN2S3mXwzqB4i5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E54E31015DC8;
	Thu, 16 Dec 2021 12:56:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BA46E2C7;
	Thu, 16 Dec 2021 12:56:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F8661809CB8;
	Thu, 16 Dec 2021 12:56:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BGCtLFK020377 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Dec 2021 07:55:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A4EBD141DEE4; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0F81141DEE3
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 883011C8C283
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-173-uNrpPPiKNaCihpIzM7SKSA-1; Thu, 16 Dec 2021 07:55:17 -0500
X-MC-Unique: uNrpPPiKNaCihpIzM7SKSA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FF8F212C8;
	Thu, 16 Dec 2021 12:55:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29C5913E3B;
	Thu, 16 Dec 2021 12:55:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id uCJeCDQ3u2FVYQAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Dec 2021 12:55:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Dec 2021 13:54:59 +0100
Message-Id: <20211216125502.15867-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BGCtLFK020377
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/5] multipathd: remove duplicate definitions
	from main.h
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

We shouldn't define function prototypes in more than a single place.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.h | 10 +++++++++-
 multipathd/main.c                   |  3 +++
 multipathd/main.h                   | 15 +--------------
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.h b/libmpathpersist/mpath_persist_int.h
index 58d9c33..3145753 100644
--- a/libmpathpersist/mpath_persist_int.h
+++ b/libmpathpersist/mpath_persist_int.h
@@ -1,7 +1,10 @@
 #ifndef _MPATH_PERSIST_INT_H
 #define _MPATH_PERSIST_INT_H
 
-struct multipath;
+/*
+ * This header file contains symbols that are used by multipath-tools
+ * but aren't part of the public libmpathpersist API.
+ */
 
 void * mpath_alloc_prin_response(int prin_sa);
 int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
@@ -13,5 +16,10 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 				    unsigned int rq_type,
 				    struct prout_param_descriptor *paramp,
 				    int noisy);
+int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy);
+int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
+			 unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
+void dumpHex(const char* , int len, int no_ascii);
+int update_map_pr(struct multipath *mpp);
 
 #endif /* _MPATH_PERSIST_INT_H */
diff --git a/multipathd/main.c b/multipathd/main.c
index 1db34ac..8926cbb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -89,6 +89,9 @@
 #define CMDSIZE 160
 #define MSG_SIZE 32
 
+int mpath_pr_event_handle(struct path *pp);
+void * mpath_pr_event_handler_fn (void * );
+
 #define LOG_MSG(lvl, pp)					\
 do {								\
 	if (pp->mpp && checker_selected(&pp->checker) &&	\
diff --git a/multipathd/main.h b/multipathd/main.h
index 8356b25..459c734 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -27,9 +27,6 @@ enum remove_path_result {
 				      * because the path was also removed */
 };
 
-struct prout_param_descriptor;
-struct prin_resp;
-
 extern pid_t daemon_pid;
 extern int uxsock_timeout;
 
@@ -44,17 +41,7 @@ int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 int flush_map(struct multipath *, struct vectors *, int);
-void * mpath_alloc_prin_response(int prin_sa);
-int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
-		       int noisy);
-void dumpHex(const char * , int len, int no_ascii);
-int prout_do_scsi_ioctl(char * , int rq_servact, int rq_scope,
-			unsigned int rq_type,
-			struct prout_param_descriptor *param, int noisy);
-int mpath_pr_event_handle(struct path *pp);
-void * mpath_pr_event_handler_fn (void * );
-int update_map_pr(struct multipath *mpp);
-void * mpath_pr_event_handler_fn (void * pathp );
+
 void handle_signals(bool);
 int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 		       int reset);
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


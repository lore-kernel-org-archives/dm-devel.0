Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D61C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-OaY9eaBcOE-oNmGILjdBEA-1; Wed, 01 Dec 2021 07:37:43 -0500
X-MC-Unique: OaY9eaBcOE-oNmGILjdBEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74A3B84BA51;
	Wed,  1 Dec 2021 12:37:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31203100AE22;
	Wed,  1 Dec 2021 12:37:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0BD7F1809CB8;
	Wed,  1 Dec 2021 12:37:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbChi008722 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5E5E24047279; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 597904047272
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41FA21066681
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-461-gbo-AUurPh6NcjeYEacXsA-1; Wed, 01 Dec 2021 07:37:08 -0500
X-MC-Unique: gbo-AUurPh6NcjeYEacXsA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4BCF41FD60;
	Wed,  1 Dec 2021 12:37:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 15E4213FF5;
	Wed,  1 Dec 2021 12:37:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kGp/A3Nsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:38 +0100
Message-Id: <20211201123650.16240-10-mwilck@suse.com>
In-Reply-To: <20211201123650.16240-1-mwilck@suse.com>
References: <20211201123650.16240-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbChi008722
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 09/21] multipath,
	multipathd: exit if bindings file is broken
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

If check_alias_settings() returns error, the bindings file is
inconsistent and proceeding is potentially dangerous. Abort.

Found by coverity.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c  |  5 ++++-
 multipathd/main.c | 15 ++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index cd234ac..2a42748 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -958,7 +958,10 @@ main (int argc, char *argv[])
 		exit(RTVL_FAIL);
 	}
 
-	check_alias_settings(conf);
+	if (check_alias_settings(conf)) {
+		fprintf(stderr, "fatal configuration error, aborting");
+		exit(RTVL_FAIL);
+	}
 
 	if (optind < argc) {
 		dev = calloc(1, FILE_NAME_SIZE);
diff --git a/multipathd/main.c b/multipathd/main.c
index 4c7bcf2..1be42c5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2819,7 +2819,9 @@ reconfigure (struct vectors * vecs)
 	reset_checker_classes();
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
-	check_alias_settings(conf);
+
+	if (check_alias_settings(conf))
+		return 1;
 
 	uxsock_timeout = conf->uxsock_timeout;
 
@@ -3332,15 +3334,22 @@ child (__attribute__((unused)) void *param)
 		if (state == DAEMON_SHUTDOWN)
 			break;
 		if (state == DAEMON_CONFIGURE) {
+			int rc = 0;
+
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
 			if (!need_to_delay_reconfig(vecs))
-				reconfigure(vecs);
+				rc = reconfigure(vecs);
 			else
 				enable_delayed_reconfig();
 			lock_cleanup_pop(vecs->lock);
-			post_config_state(DAEMON_IDLE);
+			if (!rc)
+				post_config_state(DAEMON_IDLE);
+			else {
+				condlog(0, "fatal error applying configuration - aborting");
+				exit_daemon();
+			}
 		}
 	}
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


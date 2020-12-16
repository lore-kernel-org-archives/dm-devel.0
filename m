Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472BCC4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C18FD25CA8
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C18FD25CA8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-Tl9Z7g-APf6W-2F0S3Plyw-1; Wed, 16 Dec 2020 13:18:59 -0500
X-MC-Unique: Tl9Z7g-APf6W-2F0S3Plyw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F4BE8144E1;
	Wed, 16 Dec 2020 18:18:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 220D119172;
	Wed, 16 Dec 2020 18:18:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EE86F5002C;
	Wed, 16 Dec 2020 18:18:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIIbv6018023 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:18:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A8D6ACF628; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3E72CF62B
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90F2A811E85
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-428-qzRdWwimOtqjm6TBvtA6yA-1;
	Wed, 16 Dec 2020 13:18:34 -0500
X-MC-Unique: qzRdWwimOtqjm6TBvtA6yA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9EA91B152;
	Wed, 16 Dec 2020 18:18:32 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Dec 2020 19:16:56 +0100
Message-Id: <20201216181708.22224-18-mwilck@suse.com>
In-Reply-To: <20201216181708.22224-1-mwilck@suse.com>
References: <20201216181708.22224-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGIIbv6018023
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 17/29] multipathd: add cleanup_child() exit
	handler
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

cleanup_child() calls all cleanups in the right order, in an
exit handler.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4c4e2ea..50cc335 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3024,6 +3024,27 @@ static void cleanup_rcu(void)
 	rcu_unregister_thread();
 }
 
+static void cleanup_child(void)
+{
+	cleanup_threads();
+	cleanup_vecs();
+	cleanup_foreign();
+	cleanup_checkers();
+	cleanup_prio();
+	if (poll_dmevents)
+		cleanup_dmevent_waiter();
+
+	cleanup_pidfile();
+	if (logsink == 1)
+		log_thread_stop();
+
+	cleanup_conf();
+
+#ifdef _DEBUG_
+	dbg_free_final(NULL);
+#endif
+}
+
 static int sd_notify_exit(int err)
 {
 #ifdef USE_SYSTEMD
@@ -3049,7 +3070,9 @@ child (__attribute__((unused)) void *param)
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
 	mp_rcu_data = setup_rcu();
-	atexit(cleanup_rcu);
+
+	if (atexit(cleanup_rcu) || atexit(cleanup_child))
+		fprintf(stderr, "failed to register cleanup handlers\n");
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
@@ -3063,8 +3086,6 @@ child (__attribute__((unused)) void *param)
 	pid_fd = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
 	if (pid_fd < 0) {
 		condlog(1, "failed to create pidfile");
-		if (logsink == 1)
-			log_thread_stop();
 		exit(1);
 	}
 
@@ -3212,24 +3233,8 @@ child (__attribute__((unused)) void *param)
 
 	exit_code = 0;
 failed:
-	cleanup_threads();
-	cleanup_vecs();
-	cleanup_foreign();
-	cleanup_checkers();
-	cleanup_prio();
-	if (poll_dmevents)
-		cleanup_dmevent_waiter();
-
-	/* We're done here */
-	cleanup_pidfile();
 	condlog(2, "--------shut down-------");
-
-	if (logsink == 1)
-		log_thread_stop();
-	cleanup_conf();
-#ifdef _DEBUG_
-	dbg_free_final(NULL);
-#endif
+	/* All cleanup is done in the cleanup_child() exit handler */
 	return sd_notify_exit(exit_code);
 }
 
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


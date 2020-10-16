Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBABC35271
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DAEB82084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAEB82084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-a2XH0A85MwGeG1JF-YUVrg-1; Fri, 16 Oct 2020 06:45:49 -0400
X-MC-Unique: a2XH0A85MwGeG1JF-YUVrg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 949BF101962F;
	Fri, 16 Oct 2020 10:45:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AA6B60C11;
	Fri, 16 Oct 2020 10:45:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F73058137;
	Fri, 16 Oct 2020 10:45:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjMWl020813 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 35DB62011559; Fri, 16 Oct 2020 10:45:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30E0E2011557
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1680F80018D
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:22 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-103-wWa5PnygMnG4Ls8_CKSVRw-1;
	Fri, 16 Oct 2020 06:45:17 -0400
X-MC-Unique: wWa5PnygMnG4Ls8_CKSVRw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 32FD8AF57;
	Fri, 16 Oct 2020 10:45:15 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:49 +0200
Message-Id: <20201016104501.8700-18-mwilck@suse.com>
In-Reply-To: <20201016104501.8700-1-mwilck@suse.com>
References: <20201016104501.8700-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjMWl020813
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 17/29] multipathd: add cleanup_child() exit
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 multipathd/main.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 45fc3f0..0578445 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3023,6 +3023,27 @@ static void cleanup_rcu(int dummy __attribute__((unused)), void *arg)
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
@@ -3049,7 +3070,11 @@ child (__attribute__((unused)) void *param)
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
 	crdp = setup_rcu();
-	on_exit(cleanup_rcu, crdp);
+
+	if (on_exit(cleanup_rcu, crdp) ||
+	    atexit(cleanup_child)) {
+		fprintf(stderr, "failed to register cleanup handlers\n");
+	}
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
@@ -3063,8 +3088,6 @@ child (__attribute__((unused)) void *param)
 	pid_fd = pidfile_create(DEFAULT_PIDFILE, daemon_pid);
 	if (pid_fd < 0) {
 		condlog(1, "failed to create pidfile");
-		if (logsink == 1)
-			log_thread_stop();
 		exit(1);
 	}
 
@@ -3212,24 +3235,8 @@ child (__attribute__((unused)) void *param)
 
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
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


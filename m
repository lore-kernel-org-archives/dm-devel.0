Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7863BC2BBCD
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D440825CA5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D440825CA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-noGPVBawMiWwBUXn_ox33A-1; Wed, 16 Dec 2020 13:18:58 -0500
X-MC-Unique: noGPVBawMiWwBUXn_ox33A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F7E41005513;
	Wed, 16 Dec 2020 18:18:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23E4B5D722;
	Wed, 16 Dec 2020 18:18:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E5EB31809CA1;
	Wed, 16 Dec 2020 18:18:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIIbBc018014 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:18:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7666E2026D76; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 704E22026D11
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CDB38007DF
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:34 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-310-8ntq4MFHN26FzhfSieWV0w-1;
	Wed, 16 Dec 2020 13:18:29 -0500
X-MC-Unique: 8ntq4MFHN26FzhfSieWV0w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 51187AF4C;
	Wed, 16 Dec 2020 18:18:28 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Dec 2020 19:16:41 +0100
Message-Id: <20201216181708.22224-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGIIbBc018014
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 02/29] multipathd: Fix liburcu memory leak
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Fix this leak in multipathd, reported by valgrind, that messes up
multipathd's otherwise clean leak report:

==23823== 336 bytes in 1 blocks are possibly lost in loss record 3 of 3
==23823==    at 0x483AB65: calloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==23823==    by 0x4012F16: _dl_allocate_tls (in /lib64/ld-2.31.so)
==23823==    by 0x493BB8E: pthread_create@@GLIBC_2.2.5 (in /lib64/libpthread-2.31.so)
==23823==    by 0x492A9A9: call_rcu_data_init (urcu-call-rcu-impl.h:437)
==23823==    by 0x492AD2F: UnknownInlinedFun (urcu-call-rcu-impl.h:492)
==23823==    by 0x492AD2F: create_call_rcu_data_memb (urcu-call-rcu-impl.h:504)
==23823==    by 0x1164E3: child.constprop.0.isra.0 (main.c:2915)
==23823==    by 0x10F50C: main (main.c:3335)
==23823==
==23823== LEAK SUMMARY:
==23823==    definitely lost: 0 bytes in 0 blocks
==23823==    indirectly lost: 0 bytes in 0 blocks
==23823==      possibly lost: 336 bytes in 1 blocks

The problem is caused by using liburcu's default RCU call handler,
which liburcu refuses to stop/join. See comments in the code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c5c374b..ce14bb6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2889,6 +2889,48 @@ set_oom_adj (void)
 	condlog(0, "couldn't adjust oom score");
 }
 
+/*
+ * Use a non-default call_rcu_data for child().
+ *
+ * We do this to avoid a memory leak from liburcu.
+ * liburcu never frees the default rcu handler (see comments on
+ * call_rcu_data_free() in urcu-call-rcu-impl.h), its thread
+ * can't be joined with pthread_join(), leaving a memory leak.
+ *
+ * Therefore we create our own, which can be destroyed and joined.
+ */
+static struct call_rcu_data *setup_rcu(void)
+{
+	struct call_rcu_data *crdp;
+
+	rcu_init();
+	rcu_register_thread();
+	crdp = create_call_rcu_data(0UL, -1);
+	if (crdp != NULL)
+		set_thread_call_rcu_data(crdp);
+	return crdp;
+}
+
+static struct call_rcu_data *mp_rcu_data;
+
+static void cleanup_rcu(void)
+{
+	pthread_t rcu_thread;
+
+	/* Wait for any pending RCU calls */
+	rcu_barrier();
+	if (mp_rcu_data != NULL) {
+		rcu_thread = get_call_rcu_thread(mp_rcu_data);
+		/* detach this thread from the RCU thread */
+		set_thread_call_rcu_data(NULL);
+		synchronize_rcu();
+		/* tell RCU thread to exit */
+		call_rcu_data_free(mp_rcu_data);
+		pthread_join(rcu_thread, NULL);
+	}
+	rcu_unregister_thread();
+}
+
 static int
 child (__attribute__((unused)) void *param)
 {
@@ -2906,7 +2948,8 @@ child (__attribute__((unused)) void *param)
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
-	rcu_init();
+	mp_rcu_data = setup_rcu();
+	atexit(cleanup_rcu);
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


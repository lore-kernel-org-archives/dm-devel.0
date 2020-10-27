Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBB6C388F9
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 22:51:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1EC0B20728
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 22:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EC0B20728
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-ze_SFez4OKmB8r9xb9LHmg-1; Tue, 27 Oct 2020 18:51:43 -0400
X-MC-Unique: ze_SFez4OKmB8r9xb9LHmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1DCD186843F;
	Tue, 27 Oct 2020 22:51:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99F5B6EF71;
	Tue, 27 Oct 2020 22:51:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7190958112;
	Tue, 27 Oct 2020 22:51:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09RMk3W5009002 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 18:46:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B16182086F62; Tue, 27 Oct 2020 22:46:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC78B201156B
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 22:46:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0751B85828D
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 22:46:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-567-F2qYxLZxOQGnlgcfzKyttA-1;
	Tue, 27 Oct 2020 18:45:56 -0400
X-MC-Unique: F2qYxLZxOQGnlgcfzKyttA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A97B6B1F8;
	Tue, 27 Oct 2020 22:45:54 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Tue, 27 Oct 2020 23:45:33 +0100
Message-Id: <20201027224536.11662-3-mwilck@suse.com>
In-Reply-To: <20201027224536.11662-1-mwilck@suse.com>
References: <20201027224536.11662-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09RMk3W5009002
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>,
	Leonardo Arena <rnalrd@alpinelinux.org>
Subject: [dm-devel] [PATCH 2/5] multipath-tools: fix -Wformat errors with
	musl libc
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

rlim_t type is different on musl libc. A cast to unsigned long
should be fine. Also, in musl, pthread_t is a pointer.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.c | 6 ++++--
 multipathd/waiter.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 1dad90f..39ccace 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -378,11 +378,13 @@ void set_max_fds(rlim_t max_fds)
 		if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0) {
 			condlog(0, "can't set open fds limit to "
 				"%lu/%lu : %s",
-				fd_limit.rlim_cur, fd_limit.rlim_max,
+				(unsigned long)fd_limit.rlim_cur,
+				(unsigned long)fd_limit.rlim_max,
 				strerror(errno));
 		} else {
 			condlog(3, "set open fds limit to %lu/%lu",
-				fd_limit.rlim_cur, fd_limit.rlim_max);
+				(unsigned long)fd_limit.rlim_cur,
+				(unsigned long)fd_limit.rlim_max);
 		}
 	}
 }
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 16fbdc8..3bc6980 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -64,7 +64,7 @@ void stop_waiter_thread (struct multipath *mpp)
 		return;
 
 	condlog(3, "%s: stop event checker thread (%lu)", mpp->alias,
-		mpp->waiter);
+		(unsigned long)mpp->waiter);
 	thread = mpp->waiter;
 	mpp->waiter = (pthread_t)0;
 	pthread_cleanup_push(cleanup_lock, &waiter_lock);
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


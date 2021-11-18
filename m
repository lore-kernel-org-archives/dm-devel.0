Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2190FC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3EAC61A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B3EAC61A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-4bwkt0aKMuCJER_S1-UBAw-1; Thu, 18 Nov 2021 18:04:33 -0500
X-MC-Unique: 4bwkt0aKMuCJER_S1-UBAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 161781923766;
	Thu, 18 Nov 2021 23:04:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF07156A96;
	Thu, 18 Nov 2021 23:04:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C97851832E08;
	Thu, 18 Nov 2021 23:04:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx6LP002058 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 21E01404727A; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E3D44047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07CB785A5AA
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-304-mtaS_zZDMEK1Q1KeS1YRKg-1; Thu, 18 Nov 2021 17:59:03 -0500
X-MC-Unique: mtaS_zZDMEK1Q1KeS1YRKg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 758A91FD41;
	Thu, 18 Nov 2021 22:59:02 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2FD3D13B11;
	Thu, 18 Nov 2021 22:59:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id qOWuCbbalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:02 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:08 +0100
Message-Id: <20211118225840.19810-17-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx6LP002058
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 16/48] multipathd: uxlsnr: use symbolic values
	for pollfd indices
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

Avoid hardcoding the indices as 0, 1, 2...

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 7e88538..6506109 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -46,8 +46,13 @@ struct client {
 	int fd;
 };
 
-/* The number of fds we poll on, other than individual client connections */
-#define POLLFDS_BASE 2
+/* Indices for array of poll fds */
+enum {
+	POLLFD_UX = 0,
+	POLLFD_NOTIFY,
+	POLLFDS_BASE,
+};
+
 #define POLLFD_CHUNK (4096 / sizeof(struct pollfd))
 /* Minimum mumber of pollfds to reserve for clients */
 #define MIN_POLLS (POLLFD_CHUNK - POLLFDS_BASE)
@@ -339,8 +344,8 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 			}
 		}
 		if (num_clients < MAX_CLIENTS) {
-			polls[0].fd = ux_sock;
-			polls[0].events = POLLIN;
+			polls[POLLFD_UX].fd = ux_sock;
+			polls[POLLFD_UX].events = POLLIN;
 		} else {
 			/*
 			 * New clients can't connect, num_clients won't grow
@@ -348,15 +353,15 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 			 */
 			condlog(1, "%s: max client connections reached, pausing polling",
 				__func__);
-			polls[0].fd = -1;
+			polls[POLLFD_UX].fd = -1;
 		}
 
 		reset_watch(notify_fd, &wds, &sequence_nr);
 		if (notify_fd == -1 || (wds.conf_wd == -1 && wds.dir_wd == -1))
-			polls[1].fd = -1;
+			polls[POLLFD_NOTIFY].fd = -1;
 		else
-			polls[1].fd = notify_fd;
-		polls[1].events = POLLIN;
+			polls[POLLFD_NOTIFY].fd = notify_fd;
+		polls[POLLFD_NOTIFY].events = POLLIN;
 
 		/* setup the clients */
 		i = POLLFDS_BASE;
@@ -454,12 +459,12 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 		handle_signals(true);
 
 		/* see if we got a new client */
-		if (polls[0].revents & POLLIN) {
+		if (polls[POLLFD_UX].revents & POLLIN) {
 			new_client(ux_sock);
 		}
 
 		/* handle inotify events on config files */
-		if (polls[1].revents & POLLIN)
+		if (polls[POLLFD_NOTIFY].revents & POLLIN)
 			handle_inotify(notify_fd, &wds);
 	}
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


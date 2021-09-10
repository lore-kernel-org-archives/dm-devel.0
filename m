Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DADBC43217
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC249611B0
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EC249611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-1uWbpNi3NcCV7vjy_wPp8w-1; Fri, 10 Sep 2021 07:43:31 -0400
X-MC-Unique: 1uWbpNi3NcCV7vjy_wPp8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CA3E36314;
	Fri, 10 Sep 2021 11:43:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53DD81009962;
	Fri, 10 Sep 2021 11:43:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DCA31818480;
	Fri, 10 Sep 2021 11:43:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABgxVp010196 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:42:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3C77C10BC29D; Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38A9210BFD62
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2190F8934E8
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-30-vckbkHJ-N4mAsve_MkplYg-1; Fri, 10 Sep 2021 07:42:57 -0400
X-MC-Unique: vckbkHJ-N4mAsve_MkplYg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FD5622432;
	Fri, 10 Sep 2021 11:42:56 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CDC1113D34;
	Fri, 10 Sep 2021 11:42:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YHsrML9EO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:55 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:02 +0200
Message-Id: <20210910114120.13665-18-mwilck@suse.com>
In-Reply-To: <20210910114120.13665-1-mwilck@suse.com>
References: <20210910114120.13665-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABgxVp010196
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 17/35] multipathd: uxlsnr: use symbolic values
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Avoid hardcoding the indices as 0, 1, 2...

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
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817DEC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 291D461A8C
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 291D461A8C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-N38XGoMWPuSVD6Y7mmdGMg-1; Thu, 18 Nov 2021 18:20:31 -0500
X-MC-Unique: N38XGoMWPuSVD6Y7mmdGMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA6821808304;
	Thu, 18 Nov 2021 23:20:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0CEB60C05;
	Thu, 18 Nov 2021 23:20:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C90D1832DDF;
	Thu, 18 Nov 2021 23:20:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINE603005114 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B893E404727C; Thu, 18 Nov 2021 23:14:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B48BF404727A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C8948556FE
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:06 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-532-CE-ASq0ANdCZ6Q4PM_OP4Q-1; Thu, 18 Nov 2021 18:14:05 -0500
X-MC-Unique: CE-ASq0ANdCZ6Q4PM_OP4Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B5290212CC;
	Thu, 18 Nov 2021 23:14:03 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 75D9813AA8;
	Thu, 18 Nov 2021 23:14:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YCVqGjvelmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:03 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:31 +0100
Message-Id: <20211118231338.22358-15-mwilck@suse.com>
In-Reply-To: <20211118231338.22358-1-mwilck@suse.com>
References: <20211118231338.22358-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINE603005114
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 14/21] kpartx: open /dev/loop-control only once
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Opening the same file repeatedly in a loop seems wrong.

For unknown reason, this patch caused gcc to diagnose a possible buffer
overflow for the device name, and I had to increase the buffer by
one byte.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/lopart.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 9b65255..2661940 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -159,26 +159,28 @@ char *find_loop_by_file(const char *filename)
 
 char *find_unused_loop_device(void)
 {
-	char dev[20], *next_loop_dev = NULL;
+	char dev[21], *next_loop_dev = NULL;
 	int fd, next_loop = 0, somedev = 0, someloop = 0, loop_known = 0;
+	int next_loop_fd;
 	struct stat statbuf;
 	struct loop_info loopinfo;
 	FILE *procdev;
 
+	next_loop_fd = open("/dev/loop-control", O_RDWR);
+	if (next_loop_fd < 0)
+		return NULL;
+
+	if (!(fstat(next_loop_fd, &statbuf) == 0 && S_ISCHR(statbuf.st_mode))) {
+		close(next_loop_fd);
+		return NULL;
+	}
+
 	while (next_loop_dev == NULL) {
-		if (stat("/dev/loop-control", &statbuf) == 0 &&
-		    S_ISCHR(statbuf.st_mode)) {
-			int next_loop_fd;
-
-			next_loop_fd = open("/dev/loop-control", O_RDWR);
-			if (next_loop_fd < 0)
-				return NULL;
-			next_loop = ioctl(next_loop_fd, LOOP_CTL_GET_FREE);
+		next_loop = ioctl(next_loop_fd, LOOP_CTL_GET_FREE);
+		if (next_loop < 0) {
 			close(next_loop_fd);
-			if (next_loop < 0)
-				return NULL;
+			return NULL;
 		}
-
 		sprintf(dev, "/dev/loop%d", next_loop);
 
 		fd = open (dev, O_RDONLY);
@@ -199,6 +201,9 @@ char *find_unused_loop_device(void)
 		}
 		break;
 	}
+
+	close(next_loop_fd);
+
 	if (next_loop_dev)
 		return next_loop_dev;
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


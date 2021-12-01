Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C7E6C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-7Z0JSLzJOGmXhF8EDyLSRw-1; Wed, 01 Dec 2021 07:37:34 -0500
X-MC-Unique: 7Z0JSLzJOGmXhF8EDyLSRw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 020CD10144E2;
	Wed,  1 Dec 2021 12:37:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5C5A5F4E7;
	Wed,  1 Dec 2021 12:37:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0A184CA9B;
	Wed,  1 Dec 2021 12:37:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbEAA008793 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 944EA1121314; Wed,  1 Dec 2021 12:37:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 902121121315
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE650811E76
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-155-baGz6i_uNc2wfwghMFB-5w-1; Wed, 01 Dec 2021 07:37:09 -0500
X-MC-Unique: baGz6i_uNc2wfwghMFB-5w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A25D01FD5C;
	Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6DAC813FF5;
	Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id aE7lGHRsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:08 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:43 +0100
Message-Id: <20211201123650.16240-15-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbEAA008793
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 14/21] kpartx: open /dev/loop-control only once
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

Opening the same file repeatedly in a loop seems wrong.

For unknown reason, this patch caused gcc to diagnose a possible buffer
overflow for the device name, and I had to increase the buffer by
one byte.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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


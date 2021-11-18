Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEE7C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE6FA6141B
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE6FA6141B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-lp7sa5APOq-caRuab-jm0Q-1; Thu, 18 Nov 2021 18:20:36 -0500
X-MC-Unique: lp7sa5APOq-caRuab-jm0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A9301006AA4;
	Thu, 18 Nov 2021 23:20:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3031160C17;
	Thu, 18 Nov 2021 23:20:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DED201832DDE;
	Thu, 18 Nov 2021 23:20:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINEAX4005148 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0DCDE404727A; Thu, 18 Nov 2021 23:14:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09D754047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5347811E84
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:09 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-200-7r6tnJttOjWQrqZK5pWrew-1; Thu, 18 Nov 2021 18:14:05 -0500
X-MC-Unique: 7r6tnJttOjWQrqZK5pWrew-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 69A7D2170E;
	Thu, 18 Nov 2021 23:14:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2ABB613AA8;
	Thu, 18 Nov 2021 23:14:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id uCf1BzzelmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:04 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:33 +0100
Message-Id: <20211118231338.22358-17-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINEAX4005148
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 16/21] kpartx: find_unused_loop_device(): add
	newlines
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

... to avoid these messages being joined with the error message
from the caller.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/lopart.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 7041ddf..512a59f 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -210,26 +210,26 @@ no_loop_fd:
 	}
 
 	if (!somedev)
-		fprintf(stderr, "mount: could not find any device /dev/loop#");
+		fprintf(stderr, "mount: could not find any device /dev/loop#\n");
 
 	else if (!someloop) {
 		if (loop_known == 1)
 			fprintf(stderr,
 				"mount: Could not find any loop device.\n"
-				"       Maybe /dev/loop# has a wrong major number?");
+				"       Maybe /dev/loop# has a wrong major number?\n");
 		else if (loop_known == -1)
 			fprintf(stderr,
 				"mount: Could not find any loop device, and, according to %s,\n"
 				"       this kernel does not know about the loop device.\n"
-				"       (If so, then recompile or `modprobe loop'.)",
+				"       (If so, then recompile or `modprobe loop'.)\n",
 				PROC_DEVICES);
 		else
 			fprintf(stderr,
 				"mount: Could not find any loop device. Maybe this kernel does not know\n"
 				"       about the loop device (then recompile or `modprobe loop'), or\n"
-				"       maybe /dev/loop# has the wrong major number?");
+				"       maybe /dev/loop# has the wrong major number?\n");
 	} else
-		fprintf(stderr, "mount: could not find any free loop device");
+		fprintf(stderr, "mount: could not find any free loop device\n");
 	return NULL;
 }
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


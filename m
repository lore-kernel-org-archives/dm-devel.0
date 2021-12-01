Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A9EC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-aAftOuJMOD-4Yi4ftteFqw-1; Wed, 01 Dec 2021 07:37:48 -0500
X-MC-Unique: aAftOuJMOD-4Yi4ftteFqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96B1E1006AA3;
	Wed,  1 Dec 2021 12:37:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B9CA5D9DE;
	Wed,  1 Dec 2021 12:37:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 565331809CB9;
	Wed,  1 Dec 2021 12:37:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbCRg008724 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9963B492CA3; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95565492C3B
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A0F885A5AA
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-142-90dMnBr1PbqAzHMscYpxrQ-1; Wed, 01 Dec 2021 07:37:10 -0500
X-MC-Unique: 90dMnBr1PbqAzHMscYpxrQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32CE5212CB;
	Wed,  1 Dec 2021 12:37:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F3DC413FF5;
	Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id UOXCOXRsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:08 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:45 +0100
Message-Id: <20211201123650.16240-17-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbCRg008724
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 16/21] kpartx: find_unused_loop_device(): add
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

... to avoid these messages being joined with the error message
from the caller.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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


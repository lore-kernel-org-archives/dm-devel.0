Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F040C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 08:31:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-RwMdH-WwP4OkhJc1oVJjvg-1; Mon, 31 Jan 2022 03:31:01 -0500
X-MC-Unique: RwMdH-WwP4OkhJc1oVJjvg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 630C91083F60;
	Mon, 31 Jan 2022 08:30:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E53BF1F42F;
	Mon, 31 Jan 2022 08:30:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD2AA1809CBF;
	Mon, 31 Jan 2022 08:30:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20TExF3C018508 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 29 Jan 2022 09:59:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CA9551121325; Sat, 29 Jan 2022 14:59:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C68701121315
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 14:59:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DC463C01C1E
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 14:59:10 +0000 (UTC)
Received: from h4.fbrelay.privateemail.com (h4.fbrelay.privateemail.com
	[131.153.2.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-10-0uox-FTON7qNqBMtP9W5qw-1; Sat, 29 Jan 2022 09:59:08 -0500
X-MC-Unique: 0uox-FTON7qNqBMtP9W5qw-1
Received: from MTA-15-3.privateemail.com (MTA-15-1.privateemail.com
	[198.54.118.208])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 3AB9018000B2;
	Sat, 29 Jan 2022 09:59:08 -0500 (EST)
Received: from mta-15.privateemail.com (localhost [127.0.0.1])
	by mta-15.privateemail.com (Postfix) with ESMTP id 0C82F18000A1;
	Sat, 29 Jan 2022 09:59:05 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.152])
	by mta-15.privateemail.com (Postfix) with ESMTPA id A85C118000BC;
	Sat, 29 Jan 2022 09:59:03 -0500 (EST)
From: Jordy Zomer <jordy@jordyzomer.github.io>
To: linux-kernel@vger.kernel.org
Date: Sat, 29 Jan 2022 15:58:39 +0100
Message-Id: <20220129145839.3461330-1-jordy@pwning.systems>
In-Reply-To: <20220129143722.3460829-1-jordy@pwning.systems>
References: <20220129143722.3460829-1-jordy@pwning.systems>
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20TExF3C018508
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 31 Jan 2022 03:30:51 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	Alasdair Kergon <agk@redhat.com>, Jordy Zomer <jordy@jordyzomer.github.io>
Subject: [dm-devel] [PATCH v2] dm ioct: prevent potential specter v1 gadget
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

It appears like cmd could be a Spectre v1 gadget as it's supplied by a
user and used as an array index. Prevent the contents
of kernel memory from being leaked to userspace via speculative
execution by using array_index_nospec.

Forgot to add the nospec include, that's the reason for the v2 :)

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 drivers/md/dm-ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 21fe8652b095..901abd6dea41 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -18,6 +18,7 @@
 #include <linux/dm-ioctl.h>
 #include <linux/hdreg.h>
 #include <linux/compat.h>
+#include <linux/nospec.h>
 
 #include <linux/uaccess.h>
 #include <linux/ima.h>
@@ -1788,6 +1789,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
 		return NULL;
 
+	cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
 	*ioctl_flags = _ioctls[cmd].flags;
 	return _ioctls[cmd].fn;
 }
-- 
2.27.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


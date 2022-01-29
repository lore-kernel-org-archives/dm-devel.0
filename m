Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21288C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 08:31:23 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-lo_MEe2fMkGId7nGJBzHuQ-1; Mon, 31 Jan 2022 03:31:18 -0500
X-MC-Unique: lo_MEe2fMkGId7nGJBzHuQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EC8F1083F61;
	Mon, 31 Jan 2022 08:31:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 503D673151;
	Mon, 31 Jan 2022 08:31:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 292EC1806D1C;
	Mon, 31 Jan 2022 08:31:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20TEkaBn018091 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 29 Jan 2022 09:46:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4F77653DB; Sat, 29 Jan 2022 14:46:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B11F76E9
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 14:46:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0D9B802E5E
	for <dm-devel@redhat.com>; Sat, 29 Jan 2022 14:46:32 +0000 (UTC)
Received: from h4.fbrelay.privateemail.com (h4.fbrelay.privateemail.com
	[131.153.2.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-639-np3QkKibNTWeoqQnimPeHw-1; Sat, 29 Jan 2022 09:46:29 -0500
X-MC-Unique: np3QkKibNTWeoqQnimPeHw-1
Received: from MTA-12-4.privateemail.com (mta-12-1.privateemail.com
	[198.54.122.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id E191518007F1;
	Sat, 29 Jan 2022 09:37:45 -0500 (EST)
Received: from mta-12.privateemail.com (localhost [127.0.0.1])
	by mta-12.privateemail.com (Postfix) with ESMTP id 722A818000AE;
	Sat, 29 Jan 2022 09:37:41 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.157])
	by mta-12.privateemail.com (Postfix) with ESMTPA id 168591800350;
	Sat, 29 Jan 2022 09:37:39 -0500 (EST)
From: Jordy Zomer <jordy@jordyzomer.github.io>
To: linux-kernel@vger.kernel.org
Date: Sat, 29 Jan 2022 15:37:22 +0100
Message-Id: <20220129143722.3460829-1-jordy@pwning.systems>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20TEkaBn018091
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 31 Jan 2022 03:30:51 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	Alasdair Kergon <agk@redhat.com>, Jordy Zomer <jordy@jordyzomer.github.io>
Subject: [dm-devel] [PATCH] dm ioct: prevent potential specter v1 gadget
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 drivers/md/dm-ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 21fe8652b095..0c1f9983f080 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1788,6 +1788,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
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


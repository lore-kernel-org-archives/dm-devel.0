Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88529C4321E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 10:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669890801;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SHhIbw5IRRo+q2IWORyKgIJYuM8CIVlKv6B0syp964E=;
	b=EIXCsppfyK0c3noPlvPU5Cr2oh5Gq5p7//ZpEyE0IZXUJimiXzGSDV17CT+DBrgDI42tI4
	V/I/J/LsMLyrkYvH8hvV4Nx/l0uduhBQDlbVsP1rbtqVWzo26bKb0CWrFJDA0BxCi0DsYo
	IZs2ytgHAHWDlZ8RXD+dDsmbiXpCivE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-c4RK-Yc4NpC3gT9A2mB--w-1; Thu, 01 Dec 2022 05:33:15 -0500
X-MC-Unique: c4RK-Yc4NpC3gT9A2mB--w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 923971C09B65;
	Thu,  1 Dec 2022 10:33:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B82A483EFB;
	Thu,  1 Dec 2022 10:33:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9C38519465A8;
	Thu,  1 Dec 2022 10:33:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5467219465A0
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 10:33:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6E702024CC5; Thu,  1 Dec 2022 10:33:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E00232024CBE
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 10:33:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C25DF101A528
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 10:33:08 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-7-SZu6yWO0MMOvX9gejAygfw-1; Thu,
 01 Dec 2022 05:33:05 -0500
X-MC-Unique: SZu6yWO0MMOvX9gejAygfw-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 5EAF621B1C;
 Thu,  1 Dec 2022 10:33:03 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2108613503;
 Thu,  1 Dec 2022 10:33:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id qbFoBt+CiGN5MAAAGKfGzw
 (envelope-from <mwilck@suse.com>); Thu, 01 Dec 2022 10:33:03 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  1 Dec 2022 11:32:37 +0100
Message-Id: <20221201103238.2601-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 1/2] multipath.conf(5): remove deprecated note
 for san_path_err algorithm
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>, dm-devel@redhat.com,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The paragraph stating that the san_path_err algorithm is deprecated
has been moved into the FPIN section by mistake.

Move it upward, and use a weaker wording. While the san_path_err algorithm is
technical inferior to the marginal_path approach, it is also easier to
understand and set up.  Furthermore, we documented that it's the replacement
for the delay_check algorithm. Therefore the strong "deprecated" wording is
exaggerated.

Fixes: cfff03e ("multipathd: handle fpin events")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>
---
 multipath/multipath.conf.5 | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index bd7d778..41a0112 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1877,18 +1877,19 @@ increase and the threshold is never reached. Ticks are the time between
 path checks by multipathd, which is variable and controlled by the
 \fIpolling_interval\fR and \fImax_polling_interval\fR parameters.
 .
+.RS 8
+.LP
+This algorithm is superseded by the \(dqmarginal_path\(dq failure tracking,
+but remains supported for backward compatibility.
+.
+.RE
 .TP
-.B \(dqFPIN \(dq failure tracking
+.B \(dqFPIN\(dq failure tracking
 Fibre channel fabrics can notify hosts about fabric-level issues such
 as integrity failures or congestion with so-called Fabric Performance
 Impact Notifications (FPINs).On receiving the fpin notifications through ELS
 multipathd will move the affected path and port states to marginal.
 .
-.RS 8
-.LP
-This method is \fBdeprecated\fR in favor of the \(dqmarginal_path\(dq failure
-tracking method, and only offered for backward compatibility.
-.
 .RE
 .LP
 See the documentation
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


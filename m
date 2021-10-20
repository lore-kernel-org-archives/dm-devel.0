Return-Path: <SRS0=0/yZ=PI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92592C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 01:15:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9391F60FED
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 01:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9391F60FED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-UupvFfq9MxKJmo_FN6juQQ-1; Tue, 19 Oct 2021 21:15:42 -0400
X-MC-Unique: UupvFfq9MxKJmo_FN6juQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B19F1006AA5;
	Wed, 20 Oct 2021 01:15:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAC7460BF1;
	Wed, 20 Oct 2021 01:15:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F9D64A703;
	Wed, 20 Oct 2021 01:15:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19K1FUjm021309 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Oct 2021 21:15:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E325640D1B9E; Wed, 20 Oct 2021 01:15:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DED3540C1257
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 01:15:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C667C811E76
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 01:15:29 +0000 (UTC)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com
	[209.85.222.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-221-bKz-G0-zNyqSgpMbK9kaJQ-1; Tue, 19 Oct 2021 21:15:28 -0400
X-MC-Unique: bKz-G0-zNyqSgpMbK9kaJQ-1
Received: by mail-qk1-f177.google.com with SMTP id 77so1760758qkh.6
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 18:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
	:mime-version:content-transfer-encoding;
	bh=o0IrOi9ZFbkp+trcof1Alr47Gp9JxCKIeM6Eh/usZ0g=;
	b=TeebkWfcY10n7QE29tB+6BX0QRn6YsmHRiebKkMGTqI/r4BpMISlb4ffT6wR3klgtc
	KLYAWTbMy32JfqfnJi72uV33Wl8pdy8ov6FSbNdS80EDYAuXVKdt18ljvHuEv0j/O/pf
	JuPkU5kwxA9Y6f9rn+zLHdKUqebZLSOMW+1/041yr1/3S03h1NWShwmxXzOUZkuxKKBu
	yBW4JCvF2FLYbVcafefeFP/jiBRDRt3M6lpsLjezf0duKqlAmHHcVA7TkBkUyNNQUoI9
	jsFbmViIfa6oGEjVPNT81emPj6Ord0A4o0ODMsxahpttYs0dHz0elWfwqW3PxRWBX2LJ
	Teog==
X-Gm-Message-State: AOAM532g4DnBGyDOmRNyqa5NKAFDK5E6AGTVyHZ1CelbN1KhHq6w0aJ4
	lNLthcZyOPBZvoyUOUNZBYhbPDrHiOvG
X-Google-Smtp-Source: ABdhPJwSAJqudSFkQQKZd6jWheSXnID6A/Gs9U/qv9zqHE/gRR8RC92diBxpZxwqWDo/CKQKR4tQjQ==
X-Received: by 2002:a37:8244:: with SMTP id e65mr2932672qkd.141.1634692527273; 
	Tue, 19 Oct 2021 18:15:27 -0700 (PDT)
Received: from localhost (pool-96-237-52-46.bstnma.fios.verizon.net.
	[96.237.52.46]) by smtp.gmail.com with ESMTPSA id
	u10sm356122qke.104.2021.10.19.18.15.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 19 Oct 2021 18:15:25 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: dm-devel@redhat.com, linux-audit@redhat.com
Date: Tue, 19 Oct 2021 21:15:24 -0400
Message-ID: <163469252421.3058604.4246950335082826987.stgit@olly>
User-Agent: StGit/1.3
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
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH] audit: correct the AUDIT_DM_CTRL and
	AUDIT_DM_EVENT numbering
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

Due to conflict with the audit and SELinux trees the device mapper
audit record types need to be renumbered before landing in Linus'
tree.

Link: https://lore.kernel.org/lkml/CAHC9VhTLmzDQPqsj+vyBNua1X13UK_tTcixKZ7WWYEqMXVOXdQ@mail.gmail.com/
Fixes: c1d7fa96e74b ("dm: introduce audit event module for device mapper")
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 include/uapi/linux/audit.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 6650ab6def2a..809e4c2041b3 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -118,8 +118,8 @@
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
 #define AUDIT_BPF		1334	/* BPF subsystem */
 #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
-#define AUDIT_DM_CTRL		1336	/* Device Mapper target control */
-#define AUDIT_DM_EVENT		1337	/* Device Mapper events */
+#define AUDIT_DM_CTRL		1338	/* Device Mapper target control */
+#define AUDIT_DM_EVENT		1339	/* Device Mapper events */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


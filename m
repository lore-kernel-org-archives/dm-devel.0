Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13797C678D5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678229383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o3JdsKdhKu0iDPi8LNV3rOmKPkjIUbNxGQtcJXfTEAM=;
	b=XRM6pNhMwFSJ91T5bKX9sOnRLGugNQPvTUBxC6GTCVQb2w72S0Lol7ZoOh/rm8AYRWRCwW
	u4wrQow7sZPf0mYGVMdlIhHwmluJ61Duu77joqSFbDTylg20c5QaF5EyKqNj5yKKt8sywZ
	N5ZORcGbzP/0tZDmGFiyKTxH6S4HaaU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-VpG0tk0ONcy0YK-tBAWIbA-1; Tue, 07 Mar 2023 17:49:41 -0500
X-MC-Unique: VpG0tk0ONcy0YK-tBAWIbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8991281722F;
	Tue,  7 Mar 2023 22:49:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 33E3644002;
	Tue,  7 Mar 2023 22:49:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E812C19465A4;
	Tue,  7 Mar 2023 22:49:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DDC3A1946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 22:49:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 668432026D68; Tue,  7 Mar 2023 22:49:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43A582026D4B;
 Tue,  7 Mar 2023 22:49:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 327MnYqs018826;
 Tue, 7 Mar 2023 16:49:34 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 327MnYmC018825;
 Tue, 7 Mar 2023 16:49:34 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  7 Mar 2023 16:49:31 -0600
Message-Id: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 0/3] handle transitioning devices in TUR checker
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Brian Bunker <brian@purestorage.com>, Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is based on Brian Bunker's "libmultipath: return
'ghost' state when port is in transition" patch:

https://listman.redhat.com/archives/dm-devel/2023-February/053344.html
https://github.com/opensvc/multipath-tools/pull/60

Instead of setting the state to PATH_GHOST, it uses PATH_PENDING. The
other two patches are small cleanups to the TUR checker that I noticed
while writing the first patch.

Benjamin Marzinski (3):
  libmultipath: return 'pending' state when port is in transition
  libmultipath: set init failure message when init fails
  libmultipath: reset nr_timeouts if we freed the context

 libmultipath/checkers/tur.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


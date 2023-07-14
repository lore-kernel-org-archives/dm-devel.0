Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFFAC001DC
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jul 2023 20:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689368064;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e3UOsjdYWgx/7VgHL2m1WZOPnqR6x7vuSG9jsVx6tOM=;
	b=NzkYA0ALZh6wQGc2DTD/ZsLAylXhMGXWwMEzkoeGSip9ZgSDPM+0oJeJtqAkToAtZrnodk
	9XAxHekzHzx/lgsvlfBbe/wyiy3B+z15aAcydkG9Q84omHZ0uLL67jgvU0h9oa/Oe1L0y6
	4D5g6MSQUbgAIVBJ2rpH57rhBDjqMsc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-Sn4_QQ7SPPa_ATMr_ytCbg-1; Fri, 14 Jul 2023 16:54:22 -0400
X-MC-Unique: Sn4_QQ7SPPa_ATMr_ytCbg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4283185A795;
	Fri, 14 Jul 2023 20:54:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE5A8492B03;
	Fri, 14 Jul 2023 20:54:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6303D1946A42;
	Fri, 14 Jul 2023 20:54:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 408B819465BA
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Jul 2023 20:54:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C3D61454142; Fri, 14 Jul 2023 20:54:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 23C0A1454143
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 20:54:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 389C1858EED
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 20:54:08 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-V1z5on5hMPSbHrQgeTtSdQ-1; Fri, 14 Jul 2023 16:54:06 -0400
X-MC-Unique: V1z5on5hMPSbHrQgeTtSdQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA7A61DF7;
 Fri, 14 Jul 2023 20:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F03C433C8;
 Fri, 14 Jul 2023 20:54:04 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	heinzm@redhat.com
Date: Fri, 14 Jul 2023 16:54:02 -0400
Message-Id: <20230714205402.1301836-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] Patch "dm ioctl: have constant on the right side of the
 test" has been added to the 6.1-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm ioctl: have constant on the right side of the test

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-ioctl-have-constant-on-the-right-side-of-the-test.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 052a2a7fb71535990d598215ed59df6f3f877b93
Author: Heinz Mauelshagen <heinzm@redhat.com>
Date:   Tue Feb 7 21:47:45 2023 +0100

    dm ioctl: have constant on the right side of the test
    
    [ Upstream commit 5cae0aa77397015f530aeb34f3ced32db6ac2875 ]
    
    Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Stable-dep-of: 249bed821b4d ("dm ioctl: Avoid double-fetch of version")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2ced382cdd70b..6aeae095086d7 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1819,8 +1819,8 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 	if (copy_from_user(version, user->version, sizeof(version)))
 		return -EFAULT;
 
-	if ((DM_VERSION_MAJOR != version[0]) ||
-	    (DM_VERSION_MINOR < version[1])) {
+	if ((version[0] != DM_VERSION_MAJOR) ||
+	    (version[1] > DM_VERSION_MINOR)) {
 		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
 		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
 		      DM_VERSION_PATCHLEVEL,

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


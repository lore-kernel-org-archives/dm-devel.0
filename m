Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99362CA0FEC
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 21:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693603494;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uuffIhdedEQpHYwSOg8DXoJq8GaJ2oIblHPJX2mu344=;
	b=QKclXFYfDIK3GZdzO0rRacWh8qTnR8aoY6j2uFnyfPPJ2pq4hg/DLHHAk3FLVSjkr09cbb
	o3WUPHaU08ArSsZQAAsOqvCvGsW0WDToiuLWvvMbFqimep5OgRejLXTehxxktYqcrV+cth
	a6VLiLqD18Px+oj4rSZeDCL6bXq8jYk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-t1rGWCuPM_KdLDbFdqedCQ-1; Fri, 01 Sep 2023 17:24:51 -0400
X-MC-Unique: t1rGWCuPM_KdLDbFdqedCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CB5D1817903;
	Fri,  1 Sep 2023 21:24:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 691BA201B07A;
	Fri,  1 Sep 2023 21:24:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B45A1946A46;
	Fri,  1 Sep 2023 21:24:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7E9B19465B7
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 21:24:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A7D03404754A; Fri,  1 Sep 2023 21:24:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A067E4069775
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 21:24:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81A8990A7E3
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 21:24:45 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-Nvn9iknwMvuBQ9qrjwyS2g-1; Fri,
 01 Sep 2023 17:24:44 -0400
X-MC-Unique: Nvn9iknwMvuBQ9qrjwyS2g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 667CA1F74B;
 Fri,  1 Sep 2023 21:24:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 347F01358B;
 Fri,  1 Sep 2023 21:24:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gWgRC5pW8mRwEwAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 21:24:42 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 23:24:39 +0200
Message-ID: <20230901212439.11880-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH] Fix hwtable test after "libmultipath: don't
 bother to recheck timeout"
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The previous patch  "libmultipath: don't bother to recheck timeout"
causes sysfs_get_timeout() to be called less frequently. Adapt the
tests.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/test-lib.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tests/test-lib.c b/tests/test-lib.c
index 0bc49d5..f75ea31 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -342,12 +342,6 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 			    mp->wwid);
 	}
 
-	if (mask & DI_CHECKER) {
-		/* get_state -> sysfs_get_timeout  */
-		will_return(__wrap_udev_device_get_subsystem, "scsi");
-		will_return(__wrap_udev_device_get_sysattr_value, "180");
-	}
-
 	if (mask & DI_PRIO && mp->flags & NEED_SELECT_PRIO) {
 
 		/* sysfs_get_timeout, again (!?) */
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


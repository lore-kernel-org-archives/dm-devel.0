Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E5DDC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 27 Oct 2022 01:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666835366;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vsCaoOljHMvksfr8yaEsvbMMANbc2McnigtQ+p9YmYk=;
	b=D2k3aSyXiLsoO5XOZcF9CuPpZCLDv5tZSNALD/rIuAMo4esOffZ4UhTnGLmsadBPoDzDxQ
	rjvTvBT7e/P5RrAA2qku9agUXg+5sR39mrNFn+e7vH4FfD826RUAin9639seed5hY1lGiW
	Bpn99jnzf9Ulp24ptaEvZHQVzvXoXis=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-Pd223I-_NUCbXvwrABTs7w-1; Wed, 26 Oct 2022 21:49:22 -0400
X-MC-Unique: Pd223I-_NUCbXvwrABTs7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF353C0ED4F;
	Thu, 27 Oct 2022 01:49:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66F4A40C83D9;
	Thu, 27 Oct 2022 01:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BADC119465A4;
	Thu, 27 Oct 2022 01:48:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C4C0B1946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Oct 2022 01:48:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8E37111E3E6; Thu, 27 Oct 2022 01:48:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1E46111F3D9
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 01:48:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C61885A583
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 01:48:53 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-_nRtGuQINJmMHGq-j3m6fg-1; Wed, 26 Oct 2022 21:48:44 -0400
X-MC-Unique: _nRtGuQINJmMHGq-j3m6fg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 8CB01B82485;
 Thu, 27 Oct 2022 01:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A5FC433C1;
 Thu, 27 Oct 2022 01:48:41 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	zhanggenjian@kylinos.cn
Date: Wed, 26 Oct 2022 21:48:39 -0400
Message-Id: <20221027014840.381423-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] Patch "dm: remove unnecessary assignment statement in
 alloc_dev()" has been added to the 6.0-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: remove unnecessary assignment statement in alloc_dev()

to the 6.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-remove-unnecessary-assignment-statement-in-alloc_.patch
and it can be found in the queue-6.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2394d36dd4d89dff7510443876e611eb9b97a2bb
Author: Genjian Zhang <zhanggenjian@kylinos.cn>
Date:   Thu Sep 29 16:20:36 2022 +0800

    dm: remove unnecessary assignment statement in alloc_dev()
    
    [ Upstream commit 99f4f5bcb975527508eb7a5e3e34bdb91d576746 ]
    
    Fixes: 74fe6ba923949 ("dm: convert to blk_alloc_disk/blk_cleanup_disk")
    Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..b4a2cb5333fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2065,7 +2065,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->minors = 1;
 	md->disk->flags |= GENHD_FL_NO_PART;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


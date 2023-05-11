Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CBA0C7EE23
	for <dm-devel@archiver.kernel.org>; Thu, 11 May 2023 15:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683820695;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hkaJU6VjZpkGoH4IJ15EbTxmGfP2FdL3skfSWDuIIu0=;
	b=Ut//GDWtIlWpohD9BDf9RQl8jydRy9GpSHo4NRbIiEQIlTAbfydO++u1/Tqjfh0nYn2p93
	ZwvLBMwhh5dX+n0OmefybbxWaB1waV5HXQZCIqugwa1UdlYaY1CJyc0swD4sW+BmSlcSHH
	e8ZUS4do9H9d1nWl4EfUx85kuwGcFxg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-hizspi-sN66-Rr-ugGXqXg-1; Thu, 11 May 2023 11:58:12 -0400
X-MC-Unique: hizspi-sN66-Rr-ugGXqXg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D06303813F51;
	Thu, 11 May 2023 15:58:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17B3A400E89;
	Thu, 11 May 2023 15:58:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D091219451D2;
	Thu, 11 May 2023 15:58:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFF7E19451C7
 for <dm-devel@listman.corp.redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AFECB40C2077; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8DF840C2076
 for <dm-devel@redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DFAB85A5A3
 for <dm-devel@redhat.com>; Thu, 11 May 2023 15:58:03 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-uJoTaBVsPYSu4WhGgjm7FQ-1; Thu, 11 May 2023 11:58:01 -0400
X-MC-Unique: uJoTaBVsPYSu4WhGgjm7FQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 25B4F64F60;
 Thu, 11 May 2023 15:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FEFC433D2;
 Thu, 11 May 2023 15:52:43 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	youngjin.gil@samsung.com
Date: Thu, 11 May 2023 11:52:42 -0400
Message-Id: <20230511155242.574592-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] Patch "dm verity: fix error handling for
 check_at_most_once on FEC" has been added to the 5.4-stable tree
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

    dm verity: fix error handling for check_at_most_once on FEC

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-fix-error-handling-for-check_at_most_once-.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 979171f8a48bdd2007e9640deef1b184a1f9bf63
Author: Yeongjin Gil <youngjin.gil@samsung.com>
Date:   Mon Mar 20 15:59:32 2023 +0900

    dm verity: fix error handling for check_at_most_once on FEC
    
    [ Upstream commit e8c5d45f82ce0c238a4817739892fe8897a3dcc3 ]
    
    In verity_end_io(), if bi_status is not BLK_STS_OK, it can be return
    directly. But if FEC configured, it is desired to correct the data page
    through verity_verify_io. And the return value will be converted to
    blk_status and passed to verity_finish_io().
    
    BTW, when a bit is set in v->validated_blocks, verity_verify_io() skips
    verification regardless of I/O error for the corresponding bio. In this
    case, the I/O error could not be returned properly, and as a result,
    there is a problem that abnormal data could be read for the
    corresponding block.
    
    To fix this problem, when an I/O error occurs, do not skip verification
    even if the bit related is set in v->validated_blocks.
    
    Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
    Cc: stable@vger.kernel.org
    Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
    Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index aad0018cc7b2d..965b5139c8970 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -478,7 +478,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 		sector_t cur_block = io->block + b;
 		struct ahash_request *req = verity_io_hash_req(v, io);
 
-		if (v->validated_blocks &&
+		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
 		    likely(test_bit(cur_block, v->validated_blocks))) {
 			verity_bv_skip_block(v, io, &io->iter);
 			continue;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


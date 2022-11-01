Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B7DC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 11:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667301705;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j1fSLBYEiFRBdywJ5GkzLo5PBs+wR3nEXhPXtbsGSs0=;
	b=VW/nziLOVS8Keo/T70rRxuNUM60w3a28wHqFsCUKWlE212x7Hhp85uVi+3buEv2gDF1kqs
	Qq02pi48gy3+AmefKERPF3+FLL2Ju0Dy4KMz/nhbpwEJzSDBBKb90Rg9aBW80bLDiUFnWR
	KJZwGtH4fKNWIPK3I45CfLyU4wcLGdA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-hV5mE0cHOIau7p37eedNLA-1; Tue, 01 Nov 2022 07:21:42 -0400
X-MC-Unique: hV5mE0cHOIau7p37eedNLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4BE7101A588;
	Tue,  1 Nov 2022 11:21:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C17882024CB7;
	Tue,  1 Nov 2022 11:21:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 898DE19465B3;
	Tue,  1 Nov 2022 11:21:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2FC621946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 11:21:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F32152166B33; Tue,  1 Nov 2022 11:21:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EBB9C2166B2D
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 11:21:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCCEB29AA2E7
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 11:21:37 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-IwJbcWuHPOGTkm5s00XCWQ-1; Tue, 01 Nov 2022 07:21:36 -0400
X-MC-Unique: IwJbcWuHPOGTkm5s00XCWQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 3AD4D6732D; Tue,  1 Nov 2022 12:21:32 +0100 (CET)
Date: Tue, 1 Nov 2022 12:21:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <20221101112131.GA14379@lst.de>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-8-hch@lst.de>
 <fd409996-e5e1-d7af-b31d-87db943eaa25@huaweicloud.com>
 <20221101104927.GA13823@lst.de>
 <d3f6ec1d-8141-19d1-ce4c-d42710f4a636@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <d3f6ec1d-8141-19d1-ce4c-d42710f4a636@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 7/7] block: store the holder kobject in
 bd_holder_disk
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 01, 2022 at 07:12:51PM +0800, Yu Kuai wrote:
>> But how could the reference be 0 here?  The driver that calls
>> bd_link_disk_holder must have the block device open and thus hold a
>> reference to it.
>
> Like I said before, the caller of bd_link_disk_holder() get bdev by
> blkdev_get_by_dev(), which do not grab reference of holder_dir, and
> grab disk reference can only prevent disk_release() to be called, not
> del_gendisk() while holder_dir reference is dropped in del_gendisk()
> and can be decreased to 0.

Oh, the bd_holder_dir reference, not the block_device one.  So yes,
I agree.

> If you agree with above explanation, I tried to fix this:
>
> 1) move kobject_put(bd_holder_dir) from del_gendisk to disk_release,
> there seems to be a lot of other dependencies.
>
> 2) protect bd_holder_dir reference by open_mutex.

I think simply switching the kobject_get in bd_link_disk_holder
into a kobject_get_unless_zero and unwinding if there is no reference
should be enough:

diff --git a/block/holder.c b/block/holder.c
index a8c355b9d0806..cd18064f6ff80 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -83,7 +83,11 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 
 	INIT_LIST_HEAD(&holder->list);
 	holder->refcnt = 1;
-	holder->holder_dir = kobject_get(bdev->bd_holder_dir);
+	if (!kobject_get_unless_zero(bdev->bd_holder_dir)) {
+		ret = -EBUSY;
+		goto out_free_holder;
+	}
+	holder->holder_dir = bdev->bd_holder_dir;
 
 	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
 	if (ret)
@@ -100,6 +104,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	del_symlink(disk->slave_dir, bdev_kobj(bdev));
 out_put_holder_dir:
 	kobject_put(holder->holder_dir);
+out_free_holder:
 	kfree(holder);
 out_unlock:
 	mutex_unlock(&disk->open_mutex);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


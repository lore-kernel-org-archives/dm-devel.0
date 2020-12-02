Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9939C6369E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 21:53:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02195217A0
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 21:53:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02195217A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-BvI8tnVMPbODQMlfO8HNUA-1; Wed, 02 Dec 2020 16:53:29 -0500
X-MC-Unique: BvI8tnVMPbODQMlfO8HNUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2AF91074641;
	Wed,  2 Dec 2020 21:53:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCBF25C1B4;
	Wed,  2 Dec 2020 21:53:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 38BB3180954D;
	Wed,  2 Dec 2020 21:53:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2LrGa0010047 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 16:53:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C352E2026D13; Wed,  2 Dec 2020 21:53:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE6E32026D47
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 21:53:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A6ED811E84
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 21:53:13 +0000 (UTC)
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
	[209.85.160.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-18-Q_UP7qqyMNa6nQIjXDnSTw-1; Wed, 02 Dec 2020 16:53:10 -0500
X-MC-Unique: Q_UP7qqyMNa6nQIjXDnSTw-1
Received: by mail-qt1-f195.google.com with SMTP id k4so2251532qtj.10;
	Wed, 02 Dec 2020 13:53:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=xaDA1tsZ1ItmC2prDcKEEQmNvQ5Pv10Cm/ao+ODU+y4=;
	b=K7+dePjnQ2TW7hVmuH70wUzqkE+aH/8dx1LnVlTjofZ4ZNFSLghDAnUc0jyK0OUmyy
	3Xrwrfp6C0JKaPrYUiTEcetY/mVmMM0UmNJSuefKsWIqO6/HjuZzxTgNaScjOKCiYCrp
	xsT1ROI+JPK8PDwQI02ZJcMJ9hcc5Ai77MErpPzUlQCyAgybLgvT1wtZHAp/tlh/qegP
	RNNrpCeDBj4nOxCY/nsqEAHiTOQZ34eKyXJzU1PVtLtFGsRMhUXDm7VN7tahrg2qUU8x
	adn2vqD1tI7pAVswy8c+0eISJdQyl/38zfCm8aMgg8GYEAJ49uh8i34Go0QPQSgOBcah
	0QQw==
X-Gm-Message-State: AOAM531+KdQtSVNKD0iliLoSa5/7E/P6HvEPO3mIm60kdffE1Miu9ctO
	+G9kMgMfk/r81t7e4IJkuAY=
X-Google-Smtp-Source: ABdhPJx+RZ46UqXMazYzX5t9mfQ+j0OHEii8+THVYT62PhwFjG1kvFR63pEZgW/b3qE/vRtSjzPEFg==
X-Received: by 2002:ac8:5b82:: with SMTP id a2mr245806qta.178.1606945989605;
	Wed, 02 Dec 2020 13:53:09 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id n41sm223753qtb.18.2020.12.02.13.53.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 13:53:08 -0800 (PST)
Date: Wed, 2 Dec 2020 16:52:40 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gMqKKmG2WE2wqk@mtj.duckdns.org>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-26-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-26-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 25/45] block: simplify bdev/disk lookup in
	blkdev_get
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Nov 28, 2020 at 05:14:50PM +0100, Christoph Hellwig wrote:
> To simplify block device lookup and a few other upcoming areas, make sure
> that we always have a struct block_device available for each disk and
> each partition, and only find existing block devices in bdget.  The only
> downside of this is that each device and partition uses a little more
> memory.  The upside will be that a lot of code can be simplified.
> 
> With that all we need to look up the block device is to lookup the inode
> and do a few sanity checks on the gendisk, instead of the separate lookup
> for the gendisk.  For blk-cgroup which wants to access a gendisk without
> opening it, a new blkdev_{get,put}_no_open low-level interface is added
> to replace the previous get_gendisk use.
> 
> Note that the change to look up block device directly instead of the two
> step lookup using struct gendisk causes a subtile change in behavior:
> accessing a non-existing partition on an existing block device can now
> cause a call to request_module.  That call is harmless, and in practice
> no recent system will access these nodes as they aren't created by udev
> and static /dev/ setups are unusual.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It's already merged but FWIW looks great to me.

Thank you.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


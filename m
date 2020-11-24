Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CBAC64E7A
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 21:19:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C39492083E
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 21:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C39492083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-rMJj6pBIPmi2FtNpxB0lPw-1; Tue, 24 Nov 2020 16:19:33 -0500
X-MC-Unique: rMJj6pBIPmi2FtNpxB0lPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 760E11006C86;
	Tue, 24 Nov 2020 21:19:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCC635D9CA;
	Tue, 24 Nov 2020 21:19:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 26953180954D;
	Tue, 24 Nov 2020 21:19:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOLJMQS021103 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 16:19:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3F5312026D35; Tue, 24 Nov 2020 21:19:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AADB2026D46
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 21:19:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC3B4811E76
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 21:19:19 +0000 (UTC)
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com
	[209.85.219.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-79-emXumMNLP0O3UJxM-da9_g-1; Tue, 24 Nov 2020 16:19:14 -0500
X-MC-Unique: emXumMNLP0O3UJxM-da9_g-1
Received: by mail-qv1-f65.google.com with SMTP id ek7so11368334qvb.6;
	Tue, 24 Nov 2020 13:19:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=sg9SO3UStMfqHkCvNI1YBGGkjTmKJ7UaheqYby9uxnM=;
	b=klg7mjLlTsQi6qqkQCfiMfO9pD9LzevwajDROxsazRjVIkPbPAS4AWzcRGW/LfEaIb
	331p2jLnzF7KasoW6t2YIIcEtl8sbSRnEOs3vRpDWI1O3Ee+eoeXAVXFrONO1G1a+vye
	qq+l8e50FSCUOav8t/4XFpw6ZyQcU8XyRHi2eisNC3aHcknAVKoIQkCZNOjnSvhn0Tfp
	cYRnWs2Y/7whZQMpBPIEMlRw0aKG49AN+f+/DvVEhNx6y3vP49/PHPgnah/lTQwycYlG
	HLwqEqEqcetcNaHIORc1rVb0ljK+lGJUIi3A0PI7WeXlrwCvxG3TxDr1UkXUgbSLQxTX
	qX1A==
X-Gm-Message-State: AOAM531U9/g+gmCaUhUGGMEmI9zfQGOYtjZ76hwotrK7CAT8xnT24glg
	+WVaNqkYIbD3rJOaucO2fDg=
X-Google-Smtp-Source: ABdhPJymsM7t3QC8HGlAx0p+5Wt4X/uLuUZsX3zmVjKyK1/8swtwKOE7/+uzSFJWv6qwdRjGjoCR5w==
X-Received: by 2002:a0c:fa08:: with SMTP id q8mr548456qvn.25.1606252753574;
	Tue, 24 Nov 2020 13:19:13 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id c27sm387614qkk.57.2020.11.24.13.19.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 13:19:12 -0800 (PST)
Date: Tue, 24 Nov 2020 16:18:49 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X714udEyPuGarVYp@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-26-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-26-hch@lst.de>
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
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 25/45] block: reference struct block_device
 from struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

Please see lkml.kernel.org/r/X708BTJ5njtbC2z1@mtj.duckdns.org for a few nits
on the previous version.

On Tue, Nov 24, 2020 at 02:27:31PM +0100, Christoph Hellwig wrote:
> To simplify block device lookup and a few other upcoming areas, make sure
> that we always have a struct block_device available for each disk and
> each partition.  The only downside of this is that each device and
> partition uses a little more memory.  The upside will be that a lot of
> code can be simplified.
> 
> With that all we need to look up the block device is to lookup the inode
> and do a few sanity checks on the gendisk, instead of the separate lookup
> for the gendisk.  These checks are in a new RCU critical section and
> the disk is now freed using kfree_rcu().

I might be confused but am wondering whether RCU is needed. It's currently
used to ensure that gendisk is accessible in the blkdev_get path but
wouldn't it be possible to simply pin gendisk from block_devices? The
gendisk and hd_structs hold the base refs of the block_devices and in turn
the block_devices pin the gendisk. When the gendisk gets deleted, it puts
the base refs of the block devices but stays around while the block devices
are being accessed.

Also, would it make sense to separate out lookup_sem removal? I *think* it's
there to ensure that the same bdev doesn't get associated with old and new
gendisks at the same time but can't wrap my head around how it works
exactly. I can see that this may not be needed once the lifetimes of gendisk
and block_devices are tied together but that may warrant a bit more
explanation.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


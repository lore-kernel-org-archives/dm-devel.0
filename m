Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D3FC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:57:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 54DBD61056
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 54DBD61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-iiJ48cDDMyS018lT0dJyzA-1; Fri, 15 Oct 2021 12:57:29 -0400
X-MC-Unique: iiJ48cDDMyS018lT0dJyzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6279F10A8E00;
	Fri, 15 Oct 2021 16:57:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 478E110013D7;
	Fri, 15 Oct 2021 16:57:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E5984EA2A;
	Fri, 15 Oct 2021 16:57:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGvM60012733 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:57:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B2FA240C1256; Fri, 15 Oct 2021 16:57:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AECF1400E410
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:57:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95F54811E78
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:57:22 +0000 (UTC)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
	[209.85.215.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-199-Gw95pQ2EPDeidDKAi51IKA-1; Fri, 15 Oct 2021 12:57:20 -0400
X-MC-Unique: Gw95pQ2EPDeidDKAi51IKA-1
Received: by mail-pg1-f181.google.com with SMTP id d23so9116055pgh.8
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=/eOYGY8U37n2MZu0N4BHYKivX4HrXVHyr5D+KqaWhQU=;
	b=y1Wc+OZs2GBPM26+fITPj8vLy+/gdiEWkdKP/T6O8lggRx+tbbboKteMmSHOFBh2XQ
	7JKX5bfj9EAPvxCq3GCqodk3rffFASNt9ZHcUYchGqv1qlGuRRLalT9vMky574CmbZk8
	KzBb0rjijRoFM8uIPORQFEAfvHj40vuNJmYe0/c/AUIExdkJk4NBJewK6qBvZhcuGdb+
	ZpdAlNp2zQ+xrcBEAChI6HVDHnVysuRpxMaC6QV93xrw7OkAYfY+qr65hMix3rtsYcWm
	6WrY0zNK1OeUOQip+Kr7asd3uHB8YOaAZ7mX/P+IDL3mW5NoVKpb44t6Px3YlMVU3+ke
	yipA==
X-Gm-Message-State: AOAM5320x/npgJtgmwP3cbKRVlPfiVvAwyRNB/tD7Iv5ZyT1pbrbZD0X
	JNedvu/+jheepVE4YKIXECjlCA==
X-Google-Smtp-Source: ABdhPJyzpBRnickMzNbIwiNU4SlM0+KvU9N1DSuPdJJGXTy9zuESs+0VnjHyi75qB2n8UZERvww2Xg==
X-Received: by 2002:a63:b950:: with SMTP id v16mr5917773pgo.361.1634317039225; 
	Fri, 15 Oct 2021 09:57:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	a20sm11450710pjh.46.2021.10.15.09.57.18
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:57:18 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:57:18 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150957.C90F687@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-25-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-25-hch@lst.de>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 24/30] block: use bdev_nr_bytes instead of
 open coding it in blkdev_fallocate
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 15, 2021 at 03:26:37PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


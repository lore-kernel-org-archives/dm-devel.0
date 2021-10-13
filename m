Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44577C43219
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:14:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB92060FDA
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:14:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB92060FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-o3Mn5OvqOcScEdcQEH8jtg-1; Wed, 13 Oct 2021 02:14:30 -0400
X-MC-Unique: o3Mn5OvqOcScEdcQEH8jtg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81E09100F953;
	Wed, 13 Oct 2021 06:14:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B83C5196F9;
	Wed, 13 Oct 2021 06:14:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B39E4E9F5;
	Wed, 13 Oct 2021 06:14:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D6ENV1028069 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 02:14:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5AEC740F9D72; Wed, 13 Oct 2021 06:14:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54D3240F9D69
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:14:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38DB01066689
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:14:18 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
	[209.85.215.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-590-TmZJidKyPom8xCnYTjaKDg-1; Wed, 13 Oct 2021 02:14:16 -0400
X-MC-Unique: TmZJidKyPom8xCnYTjaKDg-1
Received: by mail-pg1-f175.google.com with SMTP id r201so1316436pgr.4
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 23:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=ohUOQyC8vv5S9fFmDSqrC2HGxb4XvUeywx+2/I7KWZo=;
	b=6aLRWwW5xIDurlGtgziD8VoGfinrnZMQ7PFdCgklVlYsusEtZG/9KFCqw8xnWLrMVn
	EqqPr90PB3mR8fYtCk3Y6xgbTOuMHqf3xhfgQBeMLudpyJU5v9ay4D1zMCORMnFT3H10
	Yh6jFvPaoZeIoPzOqtBMxq8SZsozwREIrfDFrz68GoXAeRI8uxMowoWNyCwd1LRt/Qga
	BdGH4qBMakPtD7fLuZOdM2ciRwAqv4/l7zB8iAORdS5Fc2++9icEHJtMByHEmDASgAz8
	5lnN0NDIhp/qOPbnpqNDW3nk2sBafN6KLA/qlMBgwbD3VC0St1t7fzwc6gnK0u9+qepN
	zFcw==
X-Gm-Message-State: AOAM531lUiXeQNmLamSAY7tVtg47bdfcAh+QSDNmcSIJywuuVGl/Lx+U
	Ln3V2CiRNR9uQ7L8g4rsBwdQow==
X-Google-Smtp-Source: ABdhPJwNMNbppcyyaPyGGktYQSHeAypT2bIkLVBhhieDA7TSPn60W6m8F7nQfgJZ/E5a6hMyK4Ynow==
X-Received: by 2002:a63:e00b:: with SMTP id e11mr26380948pgh.190.1634105655240;
	Tue, 12 Oct 2021 23:14:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	t8sm10813622pgk.66.2021.10.12.23.14.14
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 12 Oct 2021 23:14:15 -0700 (PDT)
Date: Tue, 12 Oct 2021 23:14:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110122314.664187AA@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-10-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-10-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com,
	linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 09/29] fs: simplify init_page_buffers
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 13, 2021 at 07:10:22AM +0200, Christoph Hellwig wrote:
> No need to convert from bdev to inode and back.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


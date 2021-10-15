Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3A0C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:58:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C466611C8
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:58:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C466611C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-TLWJRdX4M3iL9B-z8dcBeQ-1; Fri, 15 Oct 2021 12:58:21 -0400
X-MC-Unique: TLWJRdX4M3iL9B-z8dcBeQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E9FA80365C;
	Fri, 15 Oct 2021 16:58:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4209F5F4E5;
	Fri, 15 Oct 2021 16:58:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4E2D4EA2F;
	Fri, 15 Oct 2021 16:58:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGwFiW012849 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:58:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8D03710087F1; Fri, 15 Oct 2021 16:58:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8889710088A3
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:58:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE74B8007B1
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:58:10 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
	[209.85.210.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-434-K3pBe8oXOeKJQg4dbKVflQ-1; Fri, 15 Oct 2021 12:58:09 -0400
X-MC-Unique: K3pBe8oXOeKJQg4dbKVflQ-1
Received: by mail-pf1-f169.google.com with SMTP id d9so1673931pfl.6
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=D4ik1Lt2fUu7rVQyF8CllyYkKQv1Uz9xzDA6N8pwEt0=;
	b=qZPbclXMdKCA0BuM7/JJhIcPqp1dxIM5IVxN5LEWnFsXS96I2t/+cUHXZVKC8IKPTE
	AxrhhuzKgWuykBo4JbPVjLommb85ofRWfSzm04JRGSNH9tlasczdeXmDw8o0r1ELXzAk
	tO5OQ5SuKZiBYiAH4V3PjTqGX+flz4O+winE56y3wmFXgIhnyHP7pDW8R0RaUFd+ROS9
	ekBeCgkGnKj5YeQFsw7WQF7WR+Fec6WqujvHbSx7Y2Vm+QuiIXEjgl4esn0jhEIV09jm
	7YoF2MChF+fqPVq43pz7W+4OVllTJVcEQA68bxgQljg4Fu96QuNLSuUi+AVhMIoilzE9
	vmqQ==
X-Gm-Message-State: AOAM533YfNiI6LkZCiOaHMI3D+QKnGaC3paT/v6RmThaMt4gVitYb+oH
	HXystwJI2tMjywAgfKHqbfwtgA==
X-Google-Smtp-Source: ABdhPJwjs+d5iHomMRfB84u/9uN/BXfrv3rJikQOTGFeQP4iBMjOf7nvTwY+G4DJFOV8bNrfnz+CuA==
X-Received: by 2002:a63:4766:: with SMTP id w38mr10056849pgk.104.1634317087874;
	Fri, 15 Oct 2021 09:58:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id e1sm5367341pgi.43.2021.10.15.09.58.07
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:58:07 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:58:06 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150957.44EE74B5@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-26-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-26-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
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
Subject: Re: [dm-devel] [PATCH 25/30] block: add a sb_bdev_nr_blocks helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 15, 2021 at 03:26:38PM +0200, Christoph Hellwig wrote:
> Add a helper to return the size of sb->s_bdev in sb->s_blocksize_bits
> based unites.  Note that SECTOR_SHIFT has to be open coded due to
> include dependency issues for now, but I have a plan to sort that out
> eventually.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

You can adjust this changelog to remove the note about SECTOR_SHIFT
now. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


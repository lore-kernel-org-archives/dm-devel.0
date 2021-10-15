Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D79AC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:56:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BD742611C1
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BD742611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-lUM-ecuuN9e7P6O6ndRCcA-1; Fri, 15 Oct 2021 12:56:40 -0400
X-MC-Unique: lUM-ecuuN9e7P6O6ndRCcA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC2B418A0748;
	Fri, 15 Oct 2021 16:56:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7334BB8549;
	Fri, 15 Oct 2021 16:56:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1A106181A1CF;
	Fri, 15 Oct 2021 16:56:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGsxBw012434 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:54:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1AB3240C1256; Fri, 15 Oct 2021 16:54:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16EC7400F3F9
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:54:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3652106655A
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:54:58 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
	[209.85.215.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-302-H4w77ZlAPTGI3jArSt27Uw-1; Fri, 15 Oct 2021 12:54:57 -0400
X-MC-Unique: H4w77ZlAPTGI3jArSt27Uw-1
Received: by mail-pg1-f171.google.com with SMTP id f5so9092286pgc.12
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:54:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=SGOpzYQsZVxiJYbDiHH5De0/7WPNstxhmFZjyDhxXSM=;
	b=uqfDaTxGgVKDVDX7XDqDfpEAJBSgmkhmCP5lgUHqU9f3jzF04oQ4Tzc9gUn702Hbzo
	4pVAX1GgLSu8Ip6mRRAp0jKHzdR3JR8p/8LZmrrqQxpUDhISarT+BvXSMH3QBuq5Ew+g
	BlyTM3rEllnOQqX1/tQO1JjFa+L7bQsNK2Lu9W28kLyGugpL+5PceLzku/GfjTNFXj2A
	ms9pGLXmh4kWz6fcyNPxN7g0siyC9YfnAd3Zz31kv4q8KANxbGO9fuwnPt8OmISck5aG
	lf3y7C+oIhJFbh/vFQTucbte50v5b3SposNMpAFDKJshWvRz0zRh8PGYeqtNcMZoFTwh
	pUUg==
X-Gm-Message-State: AOAM533qCegid+cbxHb8fmVw8Mu8h+NKs7D4f9qzuebqMpA9quhY4WFE
	C8+tgZTC6sbDObMfdGYEfJSE/w==
X-Google-Smtp-Source: ABdhPJyWeQQaxN3OVR9dpjDI7bcixMoFds0uTAEJpzN0+vwQj4qrWqnY4m/W/UbgYRyhJ3miirXMyQ==
X-Received: by 2002:a62:1596:0:b0:44c:f7b3:df74 with SMTP id
	144-20020a621596000000b0044cf7b3df74mr12889236pfv.60.1634316896184;
	Fri, 15 Oct 2021 09:54:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	h3sm6042497pfv.166.2021.10.15.09.54.55
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:54:55 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:54:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150954.FE37F8CF00@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-21-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-21-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 20/30] ntfs3: use bdev_nr_bytes instead of
	open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 15, 2021 at 03:26:33PM +0200, Christoph Hellwig wrote:
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


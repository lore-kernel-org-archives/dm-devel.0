Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41ADC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:16:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2F06160E74
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F06160E74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-yFYYyeKbPXWgvAXW5GuGjQ-1; Wed, 13 Oct 2021 02:16:24 -0400
X-MC-Unique: yFYYyeKbPXWgvAXW5GuGjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7614E10A8E05;
	Wed, 13 Oct 2021 06:16:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E6F85BAF8;
	Wed, 13 Oct 2021 06:16:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EE5984EA30;
	Wed, 13 Oct 2021 06:16:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D6GHF9028365 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 02:16:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B04BF40CFD10; Wed, 13 Oct 2021 06:16:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA49840CFD04
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:16:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9189B8001EA
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:16:17 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
	[209.85.215.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-176-NwXmcSbeO4KLQ5x8MTMIUw-1; Wed, 13 Oct 2021 02:16:13 -0400
X-MC-Unique: NwXmcSbeO4KLQ5x8MTMIUw-1
Received: by mail-pg1-f169.google.com with SMTP id m21so1284276pgu.13
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 23:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=FeQrChfiZcW4o0OhHTmPDOdTdbcOGCmUWNGR2fssds0=;
	b=q93LiMpg0U/KeXJQ5SyPuyVEIakS281EJl04ur0akqrbU8aWTdfYOO9REWSNDnCj6F
	Kv/aqgzVXrkS1CXB5gXx2BF4BIVuIiFdoO2t4fgG6ocXajeerj+4j8etoVdDMcrYbLcD
	bV+r5wNytylNxXsRJqKtWXOGaxbuydB8/7U73WAYdybrT0mCKjQMpcKoFOvX7DxVs0yg
	9IK2xoNU5mctYypR5X4blHAlY1RG0A9KLH0TjHtHYEY1YENu0FkWvxfZhbaCS40k02L/
	kPr62LDQVCF9W9aoAbAjIAIG+QrQQRyT7nUvVOVBw5NtcRVhR004hbuBROpsB5s/z3zG
	WwvQ==
X-Gm-Message-State: AOAM5337aLpvSZjZZpBKsXTkmB9f+2MFcuN+6C6XqJHiLobpLqp3yEQ8
	etxSfs9JeNNQthZ9oxTLTHRWCg==
X-Google-Smtp-Source: ABdhPJwmuFRgBzGEKwhfH80cvrnOY6Q3ng7kI1vOHwrwBDvns1KKcyGoScUlnacdxAU8v7fqrhUUVw==
X-Received: by 2002:a63:d654:: with SMTP id d20mr26275164pgj.122.1634105772620;
	Tue, 12 Oct 2021 23:16:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	a28sm13085937pfg.33.2021.10.12.23.16.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 12 Oct 2021 23:16:12 -0700 (PDT)
Date: Tue, 12 Oct 2021 23:16:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110122315.7CFF5F6@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-13-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-13-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 12/29] cramfs: use bdev_nr_sectors instead of
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 13, 2021 at 07:10:25AM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/cramfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> index 2be65269a987c..3e44cc3ed0543 100644
> --- a/fs/cramfs/inode.c
> +++ b/fs/cramfs/inode.c
> @@ -209,7 +209,7 @@ static void *cramfs_blkdev_read(struct super_block *sb, unsigned int offset,
>  		return read_buffers[i] + blk_offset;
>  	}
>  
> -	devsize = mapping->host->i_size >> PAGE_SHIFT;
> +	devsize = bdev_nr_sectors(sb->s_bdev) >> (PAGE_SHIFT - SECTOR_SHIFT);

I find this less readable than "bytes >> PAGE_SHIFT". I'd suggest this
use a new bdev_nr_bytes() helper.

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


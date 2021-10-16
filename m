Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE469C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 678FD610A6
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 07:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 678FD610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-rkMpLQ2aP7Wtdt_Phk0qug-1; Mon, 18 Oct 2021 03:35:05 -0400
X-MC-Unique: rkMpLQ2aP7Wtdt_Phk0qug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3E1C15875A3;
	Mon, 18 Oct 2021 07:35:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8492B5F4F5;
	Mon, 18 Oct 2021 07:35:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4A9C9181A1D0;
	Mon, 18 Oct 2021 07:35:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19G7eFvs024862 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 16 Oct 2021 03:40:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8659A40CFD11; Sat, 16 Oct 2021 07:40:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8048E40CFD02
	for <dm-devel@redhat.com>; Sat, 16 Oct 2021 07:40:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D44248007B1
	for <dm-devel@redhat.com>; Sat, 16 Oct 2021 07:40:14 +0000 (UTC)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
	[209.85.167.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-590-5mbZWjg4On-ooz6XkTvLhg-1; Sat, 16 Oct 2021 03:40:12 -0400
X-MC-Unique: 5mbZWjg4On-ooz6XkTvLhg-1
Received: by mail-lf1-f46.google.com with SMTP id r19so50617461lfe.10;
	Sat, 16 Oct 2021 00:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=yeYbTALLt+81wu8WFfyKx0a33Kod/SnDLZRAl1Frm5U=;
	b=lLETY5A2h2adQM5XOnQMsxgXQDii0nyROzfcXxkIIVpM4ESmZgB2wl3474liXHjRXK
	m1qQjkquTxtXlpUyg4yr2u/fnTBVm2fEgZDJPfGO+SPhKy1blsvyv7fCOW8G1VC4ypMW
	3bsCAbV1bif9NEvGfEpTZshrrNpKyZA9J7tZwVlj9zZDx3p2Cv6XcrEoL30GOptqY8Qx
	2SDL7CykdGS4IQQ0AdDN4j2IhfV2B5Scq5EsBJW8e6Ors/bUj9d3KDLPiOmOjqG+/qNr
	YHm4Kj6Z5167u0bgt5qVo/8JFyT7Ugcpt5y5+7BKPpwR5WXk4tlGMPIE+dyMcUGjS8RO
	ax5A==
X-Gm-Message-State: AOAM533nIOSKw2XZb/0S8h8W/RxzPioDyEWW0Zwv9XtctWTgwQ45DNxj
	7twcPqPeGQxQkl66tqNfNaY=
X-Google-Smtp-Source: ABdhPJz42JllLibAuMU4PSsWo9d4pmXBI6FidoZzBNe3/Oe9MjVOfwHK8qKnrFH4pZzBziLDXJNmxQ==
X-Received: by 2002:a05:6512:3190:: with SMTP id
	i16mr9019031lfe.224.1634370011048; 
	Sat, 16 Oct 2021 00:40:11 -0700 (PDT)
Received: from kari-VirtualBox (85-23-89-224.bb.dnainternet.fi. [85.23.89.224])
	by smtp.gmail.com with ESMTPSA id a19sm827633ljb.3.2021.10.16.00.40.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 16 Oct 2021 00:40:10 -0700 (PDT)
Date: Sat, 16 Oct 2021 10:40:08 +0300
From: Kari Argillander <kari.argillander@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211016074008.o6wl7uy3vsrz4v3b@kari-VirtualBox>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 18 Oct 2021 03:34:40 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
> ---
>  fs/ntfs3/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
> index 55bbc9200a10e..7ed2cb5e8b1d9 100644
> --- a/fs/ntfs3/super.c
> +++ b/fs/ntfs3/super.c
> @@ -918,7 +918,6 @@ static int ntfs_fill_super(struct super_block *sb, void *data, int silent)
>  	int err;
>  	struct ntfs_sb_info *sbi;
>  	struct block_device *bdev = sb->s_bdev;
> -	struct inode *bd_inode = bdev->bd_inode;

Linus merged latest ntfs3 stuff and this temp variable is not anymore in
upstream. So this patch will conflict. Just so that you know.

>  	struct request_queue *rq = bdev_get_queue(bdev);
>  	struct inode *inode = NULL;
>  	struct ntfs_inode *ni;
> @@ -967,7 +966,7 @@ static int ntfs_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	/* Parse boot. */
>  	err = ntfs_init_from_boot(sb, rq ? queue_logical_block_size(rq) : 512,
> -				  bd_inode->i_size);
> +				  bdev_nr_bytes(bdev));
>  	if (err)
>  		goto out;
>  
> -- 
> 2.30.2
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


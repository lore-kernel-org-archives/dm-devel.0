Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A221C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 15:58:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 17BA960EE5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 15:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17BA960EE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-HEuOXuIYP26EnDEUEaeChg-1; Fri, 15 Oct 2021 11:58:16 -0400
X-MC-Unique: HEuOXuIYP26EnDEUEaeChg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D24CF1006AA2;
	Fri, 15 Oct 2021 15:58:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 944F31002D67;
	Fri, 15 Oct 2021 15:58:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6549C4A704;
	Fri, 15 Oct 2021 15:58:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FFw9iP006215 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 11:58:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3209ED74B9; Fri, 15 Oct 2021 15:58:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D238D74C2
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 15:58:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49649899EC5
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 15:58:03 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
	[209.85.216.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-399-Ir1abC57PdyJjwW1bXkYxA-1; Fri, 15 Oct 2021 11:58:01 -0400
X-MC-Unique: Ir1abC57PdyJjwW1bXkYxA-1
Received: by mail-pj1-f42.google.com with SMTP id
	qe4-20020a17090b4f8400b0019f663cfcd1so9652290pjb.1
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 08:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=rgGaYmDb8aNvCIAME7GO0birqL1mkWt7ydTyP9O/cKE=;
	b=q2QJA72LPCLHEk+6ASBghlwHtYYvfjwV7dHA1Rdg+E/OLDdj4SlkY7smx225RqFszR
	OLU8oy8K4TmBShPRxmeI5so0MS8yyVJaj0yFZCnoAIsz5ne2zM5BPaHuW7SX0LOIbpLv
	jFIxzwO5ooTyKK5UfBujUISjlUkvi6frNMD8ehsb9vYo8/zVvHRw1PPEC/8tQ9U174s6
	7Y5un30j7zHnadEh1DSNz5AJuAsURfCEIzUllPQIRw/2oqHTT17/ZM4ueIMFVaXvKdVu
	UX1AHC2SiZmsrTxoUrW0wbS20ckTuoM/gIKCUy9Uvz+Pqr6d9DhV7mtHYvOknk9l7u0e
	jj8A==
X-Gm-Message-State: AOAM530nOROSz+750dqz9Z70qowLl+yZzYFI1C7PJh+BMYaJXkWj1iHJ
	wlqdI/6I33iWzkFAmRu/goNgQw==
X-Google-Smtp-Source: ABdhPJx303madCzq8aEdsp3YSciE1Wq7LVhGoNPOEW0M7ZYp3QKmvN8DHnOwfgCID2D8+p9KXQEc7Q==
X-Received: by 2002:a17:902:b40a:b0:13d:cbcd:2e64 with SMTP id
	x10-20020a170902b40a00b0013dcbcd2e64mr11832704plr.18.1634313480495;
	Fri, 15 Oct 2021 08:58:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	i123sm5371745pfg.157.2021.10.15.08.58.00
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 08:58:00 -0700 (PDT)
Date: Fri, 15 Oct 2021 08:57:59 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150857.A7E96DAE@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-9-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
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
Subject: Re: [dm-devel] [PATCH 08/30] target/iblock: use bdev_nr_bytes
 instead of open coding it
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

On Fri, Oct 15, 2021 at 03:26:21PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

Is this basically an open-coded non-sb version of sb_bdev_nr_blocks()?

Reviewed-by: Kees Cook <keescook@chromium.org>

> ---
>  drivers/target/target_core_iblock.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 31df20abe141f..b1ef041cacd81 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -232,9 +232,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
>  	struct block_device *bd,
>  	struct request_queue *q)
>  {
> -	unsigned long long blocks_long = (div_u64(i_size_read(bd->bd_inode),
> -					bdev_logical_block_size(bd)) - 1);
>  	u32 block_size = bdev_logical_block_size(bd);
> +	unsigned long long blocks_long =
> +		div_u64(bdev_nr_bytes(bd), block_size) - 1;
>  
>  	if (block_size == dev->dev_attrib.block_size)
>  		return blocks_long;
> -- 
> 2.30.2
> 

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


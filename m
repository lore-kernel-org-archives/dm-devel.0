Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DBFC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D28461019
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0D28461019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-_YPt66LcPL-dSS7lr5Xsaw-1; Thu, 14 Oct 2021 03:53:13 -0400
X-MC-Unique: _YPt66LcPL-dSS7lr5Xsaw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33AE018D6A35;
	Thu, 14 Oct 2021 07:53:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E304C641AA;
	Thu, 14 Oct 2021 07:53:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E7FCB4E58F;
	Thu, 14 Oct 2021 07:53:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D9VMEc012902 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 05:31:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8912C5EDED; Wed, 13 Oct 2021 09:31:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 835E05F274
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 09:31:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3883899EC0
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 09:31:18 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
	[209.85.208.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-453-vOmeDSOeORqCBByqtIL6Bw-1; Wed, 13 Oct 2021 05:31:15 -0400
X-MC-Unique: vOmeDSOeORqCBByqtIL6Bw-1
Received: by mail-ed1-f54.google.com with SMTP id z20so7383777edc.13;
	Wed, 13 Oct 2021 02:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=jSDv3nCwYvRWF60PFzYmVFtCqi6n+8kG/qLGRQcEwXY=;
	b=3e4o/DFOOBfYSdIe/FIHCt84/NiUr60k4kDFfRt1C+y4z2e0JA5jlbTaRNh2OFRoO8
	nx1h5OsHSKb9pYxGNLTWJ7G6yOdVukoc6m0CsEdoIxThKBMD2KTRaXrqFsKNJbw4Mp7N
	43fiRGIE4wy76/W3G+Q8erXIYOZTDgNQTiyBcmMgSoW7bFQBiXbAJax9AOD8Qn7NXj9S
	e0eQTrbxi7z4ICAz2ltZjhV/7WUjxGWJ6RiARKpB4lsBKntxgwSs9M616im8/YPYIMnM
	okhX/+JccorfFNC2UFNIJcYSYWKAkJA7KrWx9Zf4OYI2iMTFQ0POg5xYf57VkFikAOVC
	jQnw==
X-Gm-Message-State: AOAM533qF8RWOTm6QE7MEDO2/j8+gsUIFgaro0LN1QyAmbchhzk9n0vd
	1BBg6qqp5RC3iPT5ClXD/og=
X-Google-Smtp-Source: ABdhPJzWnNPujm70ssX25zhSqx1K1lXHECTOGOjBrmNCExix4poiHSM5QToDrvQz8D7ttpAXJOx3mg==
X-Received: by 2002:a05:6402:51d0:: with SMTP id
	r16mr7954872edd.353.1634117473882; 
	Wed, 13 Oct 2021 02:31:13 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc061e7.dynamic.kabel-deutschland.de.
	[188.192.97.231])
	by smtp.gmail.com with ESMTPSA id p7sm7639013edr.6.2021.10.13.02.31.12
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 13 Oct 2021 02:31:13 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-8-hch@lst.de>
From: Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <3babe7ca-cf08-fd19-6793-39f6d78bca12@gmail.com>
Date: Wed, 13 Oct 2021 11:31:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-8-hch@lst.de>
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
X-Mailman-Approved-At: Thu, 14 Oct 2021 03:53:04 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com,
	linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 07/29] target/iblock: use bdev_nr_sectors
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 13.10.21 07:10, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/target/target_core_iblock.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 31df20abe141f..ab7f5678ebc44 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -232,8 +232,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
>   	struct block_device *bd,
>   	struct request_queue *q)
>   {
> -	unsigned long long blocks_long = (div_u64(i_size_read(bd->bd_inode),
> -					bdev_logical_block_size(bd)) - 1);
> +	loff_t size = bdev_nr_sectors(bd) << SECTOR_SHIFT;
> +	unsigned long long blocks_long =
> +		div_u64(size, bdev_logical_block_size(bd)) - 1;
>   	u32 block_size = bdev_logical_block_size(bd);

To enhance readability, would it make sense to shift the new lines
behind "u32 block_size = ...", so block_size can be used in div_u64
instead of using bdev_logical_block_size twice?

>   
>   	if (block_size == dev->dev_attrib.block_size)
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D15DC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:53:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F361560F02
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F361560F02
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-ZBcwUZ2SMJONZkgxdON--A-1; Mon, 18 Oct 2021 13:53:44 -0400
X-MC-Unique: ZBcwUZ2SMJONZkgxdON--A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F339AA0CAB;
	Mon, 18 Oct 2021 17:53:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B1995C23A;
	Mon, 18 Oct 2021 17:53:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F051F1806D03;
	Mon, 18 Oct 2021 17:53:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19IHrDmJ015177 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 13:53:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C23FB40CFD04; Mon, 18 Oct 2021 17:53:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB8404010FF0
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 17:53:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 382C8899EC4
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 17:53:13 +0000 (UTC)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
	[209.85.166.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-364-FQEyKx51MW6N2zIslsfLKA-1; Mon, 18 Oct 2021 13:53:11 -0400
X-MC-Unique: FQEyKx51MW6N2zIslsfLKA-1
Received: by mail-io1-f50.google.com with SMTP id m20so17240836iol.4
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 10:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=YH4oGe9dRfdZQ1d4CvnTMZ1r7HRf2QBAQWpHy9E3Wng=;
	b=x567/p3PPQJH4Ghj6VNuhKkSjycvCG6kLXfFx0MXRuqBWdImrERzrpo4lRSqiIk/wT
	cfuP9YXURlIenYT4CqgPLWm3U/JL7DjaFsKRI8MWfqd0QYh2QsW6VxVvw6fLKoP6YQ7O
	ykWA4embh74vDt8uEc5ohVkrF8kla0s0N2o4rZzjkCTFZShKwWmmVhkU2dut6uabK+aP
	Q8sifqjTBPpz+u6SLwGTaro485hz0Qd4eQGYWO0gJQiMfcD6inbMYY59RHUqEdkA3v3O
	maF7Z81jutTAMJvUePeyzHZigPBNFkP3cgKz2PALxK55XB4QGPXjS6yKq0Z48jcZJ24C
	HBJg==
X-Gm-Message-State: AOAM5311I8XdQjM4UsNau4TveOLVscPNI2xha9Gds8YRjFOrVsZcPteN
	j9UQtMJouLZ5kJrtAwHziZ37Ng==
X-Google-Smtp-Source: ABdhPJzaVpRAohIh75kPuEB6cvjZHptUXsyrO2OyQP99Xt2V/uaZI2XjjHTplRgkBKRlsFA7V0q64g==
X-Received: by 2002:a6b:8dd6:: with SMTP id
	p205mr14846469iod.192.1634579590519; 
	Mon, 18 Oct 2021 10:53:10 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
	by smtp.gmail.com with ESMTPSA id
	m15sm3303730ilh.73.2021.10.18.10.53.09
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 18 Oct 2021 10:53:10 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
	<4a8c3a39-9cd3-5b2f-6d0f-a16e689755e6@kernel.dk>
	<20211018171843.GA3338@lst.de>
	<2f5dcf79-8419-45ff-c27c-68d43242ccfe@kernel.dk>
	<20211018174901.GA3990@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e0784f3e-46c8-c90c-870b-60cc2ed7a2da@kernel.dk>
Date: Mon, 18 Oct 2021 11:53:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211018174901.GA3990@lst.de>
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
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
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
Subject: Re: [dm-devel] don't use ->bd_inode to access the block device size
	v3
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/18/21 11:49 AM, Christoph Hellwig wrote:
> On Mon, Oct 18, 2021 at 11:40:51AM -0600, Jens Axboe wrote:
>>  static inline loff_t bdev_nr_bytes(struct block_device *bdev)
>>  {
>> -	return i_size_read(bdev->bd_inode);
>> +	return bdev->bd_nr_sectors;
> 
> This hunk needs to go into bdev_nr_sectors, and the bdev_nr_bytes
> probably wants to call bdev_nr_sectors and do the shifting.

Makes sense.

commit dd018a580d0037f65d7dd801cbf3e053f36283de
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Oct 18 11:39:45 2021 -0600

    block: cache inode size in bdev
    
    Reading the inode size brings in a new cacheline for IO submit, and
    it's in the hot path being checked for every single IO. When doing
    millions of IOs per core per second, this is noticeable overhead.
    
    Cache the nr_sectors in the bdev itself.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/genhd.c b/block/genhd.c
index 759bc06810f8..53495e3391e3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -58,6 +58,7 @@ void set_capacity(struct gendisk *disk, sector_t sectors)
 
 	spin_lock(&bdev->bd_size_lock);
 	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
+	bdev->bd_nr_sectors = sectors;
 	spin_unlock(&bdev->bd_size_lock);
 }
 EXPORT_SYMBOL(set_capacity);
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 9dbddc355b40..66ef9bc6d6a1 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -91,6 +91,7 @@ static void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors)
 {
 	spin_lock(&bdev->bd_size_lock);
 	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
+	bdev->bd_nr_sectors = sectors;
 	spin_unlock(&bdev->bd_size_lock);
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 472e55e0e94f..fe065c394fff 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,6 +39,7 @@ struct bio_crypt_ctx;
 
 struct block_device {
 	sector_t		bd_start_sect;
+	sector_t		bd_nr_sectors;
 	struct disk_stats __percpu *bd_stats;
 	unsigned long		bd_stamp;
 	bool			bd_read_only;	/* read-only policy */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7b0326661a1e..a967b3fb3c71 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -236,14 +236,14 @@ static inline sector_t get_start_sect(struct block_device *bdev)
 	return bdev->bd_start_sect;
 }
 
-static inline loff_t bdev_nr_bytes(struct block_device *bdev)
+static inline sector_t bdev_nr_sectors(struct block_device *bdev)
 {
-	return i_size_read(bdev->bd_inode);
+	return bdev->bd_nr_sectors;
 }
 
-static inline sector_t bdev_nr_sectors(struct block_device *bdev)
+static inline loff_t bdev_nr_bytes(struct block_device *bdev)
 {
-	return bdev_nr_bytes(bdev) >> SECTOR_SHIFT;
+	return bdev_nr_setors(bdev) << SECTOR_SHIFT;
 }
 
 static inline sector_t get_capacity(struct gendisk *disk)

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


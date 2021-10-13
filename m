Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4370FC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:43:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C681A60ED4
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C681A60ED4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-uq6NmPW-NhKFHGpzsxUn1g-1; Wed, 13 Oct 2021 02:43:08 -0400
X-MC-Unique: uq6NmPW-NhKFHGpzsxUn1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70B9C18125C0;
	Wed, 13 Oct 2021 06:43:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49B2510016F4;
	Wed, 13 Oct 2021 06:43:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D28531800B8B;
	Wed, 13 Oct 2021 06:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D6dTKf029907 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 02:39:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C0D7C40C1256; Wed, 13 Oct 2021 06:39:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCE12400E410
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:39:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5092800186
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:39:29 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
	[209.85.214.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-441-6U9tAnpwNQSiz1DZ8anu_g-1; Wed, 13 Oct 2021 02:39:27 -0400
X-MC-Unique: 6U9tAnpwNQSiz1DZ8anu_g-1
Received: by mail-pl1-f172.google.com with SMTP id c4so1127263pls.6
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 23:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=DD/2eDntZRvmYFLabpX6hx1U0eeFdg0nt6CnyRZUcUo=;
	b=KTSY9hsqNZ9p5brVig2CfiKbXO3Z9wEko8Y8M038hCS2IAtogYR0TY+5L0ch6EWlD+
	HuS1dmrhGivlTfcuKEl7zqzjOiZHoOus4Q1mxd2Ke8Wt9ChEgFmjLfLCEsesj1bWSDki
	ptMc0lqryJypcfkuVXEc5e3NPleYX7Z2Ds9+Benr4Yz2UlTVYIF4se0j4h9duwHIueyi
	cGlTiwOvTEvw0isFQB0Vz2y9fbe/l4L8s5PsyP2+Kl6Vjds9Apx8l7TBUoQNwd3Kjsew
	g1TvxmBlv7Kzr7CbLTRQnD5qLaEJ1AVUWKhLx/YJ/lwTXZBAuZocahAR81j2NbcOoh0u
	cl6A==
X-Gm-Message-State: AOAM5311Jd7ui5sSUfm/9pYui69sg06iapjZbLdw598pvYQVeTR8bMJl
	ProH2rSZPWvIiM3/kmWk+FtOmw==
X-Google-Smtp-Source: ABdhPJz6dN+fakHkI4mmw5FMrWYwE5jr866artFMUIcBHqytxUEdEx+T1ampoWpSo+mgvVckvfVoUQ==
X-Received: by 2002:a17:90b:4b4f:: with SMTP id
	mi15mr808506pjb.97.1634107166729; 
	Tue, 12 Oct 2021 23:39:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	y17sm9562796pfn.96.2021.10.12.23.39.26
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 12 Oct 2021 23:39:26 -0700 (PDT)
Date: Tue, 12 Oct 2021 23:39:25 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110122335.19348E8E8@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
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
Subject: Re: [dm-devel] don't use ->bd_inode to access the block device size
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

On Wed, Oct 13, 2021 at 07:10:13AM +0200, Christoph Hellwig wrote:
> I wondered about adding a helper for looking at the size in byte units
> to avoid the SECTOR_SHIFT shifts in various places.  But given that
> I could not come up with a good name and block devices fundamentally
> work in sector size granularity I decided against that.

Without something like bdev_nr_bytes(), this series has 13 of 29 patches
actually _adding_ an open-coded calculation:

[PATCH 05/29] mtd/block2mtd: use bdev_nr_sectors instead of open coding it
[PATCH 06/29] nvmet: use bdev_nr_sectors instead of open coding it
[PATCH 07/29] target/iblock: use bdev_nr_sectors instead of open coding it
[PATCH 08/29] fs: use bdev_nr_sectors instead of open coding it in blkdev_max_block
[PATCH 11/29] btrfs: use bdev_nr_sectors instead of open coding it
[PATCH 16/29] jfs: use bdev_nr_sectors instead of open coding it
[PATCH 17/29] nfs/blocklayout: use bdev_nr_sectors instead of open coding it
[PATCH 18/29] nilfs2: use bdev_nr_sectors instead of open coding it
[PATCH 19/29] ntfs3: use bdev_nr_sectors instead of open coding it
[PATCH 20/29] pstore/blk: use bdev_nr_sectors instead of open coding it
[PATCH 21/29] reiserfs: use bdev_nr_sectors instead of open coding it
[PATCH 22/29] squashfs: use bdev_nr_sectors instead of open coding it
[PATCH 23/29] block: use bdev_nr_sectors instead of open coding it in blkdev_fallocate

I think it's well worth having that helper (or at least leaving these
alone). Otherwise, this is a lot of churn without a clear net benefit,
IMO.

The others look good to me, though!

-Kees

>
> Diffstat:
>  block/fops.c                        |    2 +-
>  drivers/block/drbd/drbd_int.h       |    3 +--
>  drivers/md/bcache/super.c           |    2 +-
>  drivers/md/bcache/util.h            |    4 ----
>  drivers/md/bcache/writeback.c       |    2 +-
>  drivers/md/dm-bufio.c               |    2 +-
>  drivers/md/dm-cache-metadata.c      |    2 +-
>  drivers/md/dm-cache-target.c        |    2 +-
>  drivers/md/dm-clone-target.c        |    2 +-
>  drivers/md/dm-dust.c                |    5 ++---
>  drivers/md/dm-ebs-target.c          |    2 +-
>  drivers/md/dm-era-target.c          |    2 +-
>  drivers/md/dm-exception-store.h     |    2 +-
>  drivers/md/dm-flakey.c              |    3 +--
>  drivers/md/dm-integrity.c           |    6 +++---
>  drivers/md/dm-linear.c              |    3 +--
>  drivers/md/dm-log-writes.c          |    4 ++--
>  drivers/md/dm-log.c                 |    2 +-
>  drivers/md/dm-mpath.c               |    2 +-
>  drivers/md/dm-raid.c                |    6 +++---
>  drivers/md/dm-switch.c              |    2 +-
>  drivers/md/dm-table.c               |    3 +--
>  drivers/md/dm-thin-metadata.c       |    2 +-
>  drivers/md/dm-thin.c                |    2 +-
>  drivers/md/dm-verity-target.c       |    3 +--
>  drivers/md/dm-writecache.c          |    2 +-
>  drivers/md/dm-zoned-target.c        |    2 +-
>  drivers/md/md.c                     |   26 +++++++++++---------------
>  drivers/mtd/devices/block2mtd.c     |    5 +++--
>  drivers/nvme/target/io-cmd-bdev.c   |    4 ++--
>  drivers/target/target_core_iblock.c |    5 +++--
>  fs/affs/super.c                     |    2 +-
>  fs/btrfs/dev-replace.c              |    2 +-
>  fs/btrfs/disk-io.c                  |    3 ++-
>  fs/btrfs/ioctl.c                    |    4 ++--
>  fs/btrfs/volumes.c                  |    7 ++++---
>  fs/buffer.c                         |    4 ++--
>  fs/cramfs/inode.c                   |    2 +-
>  fs/ext4/super.c                     |    2 +-
>  fs/fat/inode.c                      |    5 +----
>  fs/hfs/mdb.c                        |    2 +-
>  fs/hfsplus/wrapper.c                |    2 +-
>  fs/jfs/resize.c                     |    5 ++---
>  fs/jfs/super.c                      |    5 ++---
>  fs/nfs/blocklayout/dev.c            |    4 ++--
>  fs/nilfs2/ioctl.c                   |    2 +-
>  fs/nilfs2/super.c                   |    2 +-
>  fs/nilfs2/the_nilfs.c               |    3 ++-
>  fs/ntfs/super.c                     |    8 +++-----
>  fs/ntfs3/super.c                    |    3 +--
>  fs/pstore/blk.c                     |    4 ++--
>  fs/reiserfs/super.c                 |    7 ++-----
>  fs/squashfs/super.c                 |    5 +++--
>  fs/udf/lowlevel.c                   |    5 ++---
>  fs/udf/super.c                      |    9 +++------
>  include/linux/genhd.h               |    6 ++++++
>  56 files changed, 100 insertions(+), 117 deletions(-)

--
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


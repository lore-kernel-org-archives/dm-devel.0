Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A192C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:45:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 95380610C7
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 95380610C7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-lRqLuIt3Mpq6hfRkKuDHsQ-1; Mon, 18 Oct 2021 13:45:35 -0400
X-MC-Unique: lRqLuIt3Mpq6hfRkKuDHsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4F4A8735D5;
	Mon, 18 Oct 2021 17:45:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23F407945B;
	Mon, 18 Oct 2021 17:45:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 57EDE1818480;
	Mon, 18 Oct 2021 17:45:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19IHfaov012551 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 13:41:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 965AC2026D48; Mon, 18 Oct 2021 17:41:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 918D62026D46
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 17:41:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D243800883
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 17:41:28 +0000 (UTC)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
	[209.85.166.176]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-526-JLWTGGftPWieSCz6evoiqQ-1; Mon, 18 Oct 2021 13:41:26 -0400
X-MC-Unique: JLWTGGftPWieSCz6evoiqQ-1
Received: by mail-il1-f176.google.com with SMTP id k3so15754721ilu.2
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 10:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=+qLOjd0XBTgNB6PyT/azLzYqk1pAiNcBYGjkEFHfKgY=;
	b=N1CMERxBmldJvzWrEdBVHzy6LxzNyWN2eQPs2j7mrIUmvbOydafgECY/CKRLPWKWhy
	Jl+dIaflSA5WvTDylfWI+90sXlkPoabyBePvsKliJvvL2EHifuTkNdg32x4SX3ez2FNG
	Y7v5ruwuEY9ggQkAfeug69AVKf/ZtRIwZ5U63akm66kpGyLq2/gZnmvZoxI5WEmswthb
	8ooYfQ3h6/FaS1YXvvhQR/YY328xH3s4M4ycAuDr+1MIbdvyyuF9Axdm7LdwUlDnaKLG
	qTJzku8w5YBWy7ipLtRNRVljZj/OB9eg1Dik05sWGDZc02GNMsTRe7KbU3QnqHU7GopN
	nSZg==
X-Gm-Message-State: AOAM532yLGlzbuQQrELloVzc7sGjccBTHGyjcU1PCxtYYeY4ewr6JKJ9
	TX7ICO4R94BR0pWOMnL1PMmqpQ==
X-Google-Smtp-Source: ABdhPJwUV70oibJYf8iw/UP9RU8rrzgiQ8l+cK/EH1A19nZcoh+uCtduaCjXDIwHeCteveuemeWXlw==
X-Received: by 2002:a05:6e02:bf4:: with SMTP id
	d20mr15751146ilu.146.1634578885728; 
	Mon, 18 Oct 2021 10:41:25 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
	by smtp.gmail.com with ESMTPSA id b4sm7342594iot.45.2021.10.18.10.41.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 18 Oct 2021 10:41:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Date: Mon, 18 Oct 2021 11:41:22 -0600
Message-Id: <163457887855.397824.18265513445295974558.b4-ty@kernel.dk>
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 18 Oct 2021 12:11:00 +0200, Christoph Hellwig wrote:
> various drivers currently poke directy at the block device inode, which
> is a bit of a mess.  This series cleans up the places that read the
> block device size to use the proper helpers.  I have separate patches
> for many of the other bd_inode uses, but this series is already big
> enough as-is,
> 
> Changes since v2:
>  - bdev_nr_bytes should return loff_t
>  - fix a commit message typo
>  - drop a redundant note in a commit message
> 
> [...]

Applied, thanks!

[01/30] block: move the SECTOR_SIZE related definitions to blk_types.h
        commit: ac076a376d4c1fa7f01bedad76bab96a981b7464
[02/30] block: add a bdev_nr_bytes helper
        commit: 449c780f68d9adbab2373c996d4341e61c088685
[03/30] bcache: remove bdev_sectors
        commit: 519070e1b8411c93b483fb50511c9d5d7932f62a
[04/30] drbd: use bdev_nr_sectors instead of open coding it
        commit: eee1958b9a7b912fff33319e5737d861703c3a47
[05/30] dm: use bdev_nr_sectors and bdev_nr_bytes instead of open coding them
        commit: 34d7526093779e26c1a281992c7e91662f3afa85
[06/30] md: use bdev_nr_sectors instead of open coding it
        commit: 1a70a0364bbbf29eab22c9fa4b3d71087df940a5
[07/30] nvmet: use bdev_nr_bytes instead of open coding it
        commit: d61ec9eeaa161c6e385f4adebc5d671bc5290687
[08/30] target/iblock: use bdev_nr_bytes instead of open coding it
        commit: 30de91d3df67291093736890b7496620d5025df9
[09/30] fs: use bdev_nr_bytes instead of open coding it in blkdev_max_block
        commit: 011bb9476ef8f9867330e2bce22cf124d034cd33
[10/30] fs: simplify init_page_buffers
        commit: 957c50dd8af9945fde3a3fb6c8baf5d638ef3177
[11/30] affs: use bdev_nr_sectors instead of open coding it
        commit: ec003894a9db3858165dd61fb4cabf9a402aabe0
[12/30] btrfs: use bdev_nr_bytes instead of open coding it
        commit: 167a1c754eae512e45de682e2cb4ea05f080fda5
[13/30] cramfs: use bdev_nr_bytes instead of open coding it
        commit: cdf881e14aa127c7602110d208b3412b1412c1ab
[14/30] fat: use bdev_nr_sectors instead of open coding it
        commit: 4513b8c903782c4f3963172d81414e08f48a0317
[15/30] hfs: use bdev_nr_sectors instead of open coding it
        commit: 311b610de54a52c199e2a129da2c26ad5953edb3
[16/30] hfsplus: use bdev_nr_sectors instead of open coding it
        commit: 03b67c1de5d3b085360f3d6dcf37560f44e8cb4b
[17/30] jfs: use bdev_nr_bytes instead of open coding it
        commit: c1e80b87c3acd52817bea278310900ad2825686c
[18/30] nfs/blocklayout: use bdev_nr_bytes instead of open coding it
        commit: 6b1b53cf606d70dc6dd375aaaab42558cfe7e945
[19/30] nilfs2: use bdev_nr_bytes instead of open coding it
        commit: a24d8bcfd590de5dc4a9e806c9e76558676c2eef
[20/30] ntfs3: use bdev_nr_bytes instead of open coding it
        commit: 9242c8b0b4432b6929b030c729a1edd9d9116d4c
[21/30] pstore/blk: use bdev_nr_bytes instead of open coding it
        commit: 989ab34bd83f075efdae2cf6026cec0507374696
[22/30] reiserfs: use bdev_nr_bytes instead of open coding it
        commit: 8d147b3353c7fd853313521c4f66430d38d66391
[23/30] squashfs: use bdev_nr_bytes instead of open coding it
        commit: 8538360bb42955166d0073ffb6dff6a4b0caa4ec
[24/30] block: use bdev_nr_bytes instead of open coding it in blkdev_fallocate
        commit: 7ad94c3008a3f5e0ff8af1e3ff1c7061955ccec4
[25/30] block: add a sb_bdev_nr_blocks helper
        commit: 5793a4ebc76566fd24d7afdbcefb3311355fd077
[26/30] ext4: use sb_bdev_nr_blocks
        commit: 3a10af74c8f1d390857cf87648573bc4f157e4ca
[27/30] jfs: use sb_bdev_nr_blocks
        commit: cd8ac55f93923c65e18204c99b08a8c4cba3d187
[28/30] ntfs: use sb_bdev_nr_blocks
        commit: 8e2c901e6d1c97bf862514901beaae3e248655d8
[29/30] reiserfs: use sb_bdev_nr_blocks
        commit: 93361ef44a8931d281583ea9c608247fe8127528
[30/30] udf: use sb_bdev_nr_blocks
        commit: ea8befeb35c47cf95012032850fe3f0ec80e5cde

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


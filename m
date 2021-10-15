Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E22C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:09:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 800E161090
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:09:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 800E161090
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-aP0t5gchNbClEDAA9yit1Q-1; Fri, 15 Oct 2021 12:09:24 -0400
X-MC-Unique: aP0t5gchNbClEDAA9yit1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5E3510B744E;
	Fri, 15 Oct 2021 16:09:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E4A75F4E9;
	Fri, 15 Oct 2021 16:09:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01B001806D00;
	Fri, 15 Oct 2021 16:09:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FG0K45006433 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:00:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 06FFE404727D; Fri, 15 Oct 2021 16:00:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02C83404727C
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:00:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9D9418A01AF
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:00:19 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
	[209.85.214.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-563--G7AAjUDPV2kN_dPrkvGbg-1; Fri, 15 Oct 2021 12:00:17 -0400
X-MC-Unique: -G7AAjUDPV2kN_dPrkvGbg-1
Received: by mail-pl1-f170.google.com with SMTP id y1so6653052plk.10
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=oA+XtrVpatY111qi9rW+eMi2Ccu5JD4bZ/9KhM3WrlE=;
	b=dTSdPyQ20RYr6Y1dtveUegRxZHug0oX1PQ/dBc4ZRXX7B+JQD02pa/zh8yWXuEceNC
	MwHrG4pm+T1Q6PDfzFLWfhLBhkkkDrJn/+5BzolpqAHzP6O6qhDAIRw7QU2X79lb/IIm
	YRivJ0mh0xYjfsYt7xaYIH4KP0wggdUYpmSSX3dbH6eWE0PTyjAS9l4tLTyozPcTGq1g
	56RWcsyc4FkCKkd2gJY25UEliYtO6rjLSEqZcHZxyl1EdDfuzYBBRVcTmyqZi1CgTsz9
	8y2lCv5igaqnqa2l2YN5IqOOfDJkGHnguj4eKkwGWsaP96IYSjzmh94Jl1d95whHmgW+
	TMCA==
X-Gm-Message-State: AOAM533szwEKpzM50awI6c/3uctm5dV3nIxnVuRmRLCeSx5B8G7472u7
	Bw5mxYp4PxiWQ5dZA2oqQWX3Cg==
X-Google-Smtp-Source: ABdhPJzKtqYe4vRxUad2HzrB2swbKAK83Cb9s6XXYIsx2Jq5whQZG4n13YyVL1QUtSJ6rA0qtwQqhQ==
X-Received: by 2002:a17:90a:a386:: with SMTP id
	x6mr14380761pjp.56.1634313616631; 
	Fri, 15 Oct 2021 09:00:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	nn14sm5397718pjb.27.2021.10.15.09.00.16
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:00:16 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:00:15 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150900.71DDE55E1B@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-10-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-10-hch@lst.de>
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
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
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
Subject: Re: [dm-devel] [PATCH 09/30] fs: use bdev_nr_bytes instead of open
 coding it in blkdev_max_block
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

On Fri, Oct 15, 2021 at 03:26:22PM +0200, Christoph Hellwig wrote:
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


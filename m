Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8280EC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:59:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 177C9611C3
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 177C9611C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-T0bsHyKyOneGZ_LBHMieWg-1; Fri, 15 Oct 2021 12:59:46 -0400
X-MC-Unique: T0bsHyKyOneGZ_LBHMieWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4095A3630A;
	Fri, 15 Oct 2021 16:59:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22CC860FFE;
	Fri, 15 Oct 2021 16:59:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5AE0F4EA30;
	Fri, 15 Oct 2021 16:59:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGxewM013027 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:59:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 29B9640CFD11; Fri, 15 Oct 2021 16:59:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24A4C40CFD0D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:59:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C7DF1066680
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:59:40 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
	[209.85.215.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-25-inNsAnS4PjW28dz50tUq1Q-1; Fri, 15 Oct 2021 12:59:38 -0400
X-MC-Unique: inNsAnS4PjW28dz50tUq1Q-1
Received: by mail-pg1-f169.google.com with SMTP id 66so9112933pgc.9
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=KeY5Iupdn4Pa1b1ywzkz23CB7y+Fa3Cfufu6RZZIPYI=;
	b=nJO3lAqbvMT7aQCAO5lR17ifeK3CtMbQkfUBNyAMayHRtPFSci92yIbUtrQ0LEOfys
	swRu3Bp4tlao1ZjWZnMNwiydLQ+8hK3ANmDpn4SuGsukQOxNq9t18IJ0+/nh4/1WNRnn
	UT92G4P5q8APoRBuN50PNue2ShUwScfglmIH/4+F6djnq2y+G0KBsIGTU5fQ3xwcItE/
	VaxQCdvqX6jT0ZtM/P0icRPahKafYnbxzlW8DofRrRt9SPuUtMOclRhEJEOhH4tmORiu
	NwgxjOKVkj5mH6CNFLJHz3Dx07Ul0Vbr0/Axj49G/XcT6K1E5LeMVN/rsu6qEBDp2bGb
	YqUg==
X-Gm-Message-State: AOAM533vvqWCiwSEMyuFdqPU17r5pKYXpJQDKHEp2v2gFSNcRL8iQ++X
	QpKRvZQFV7MD94xPgzyAe1KJmw==
X-Google-Smtp-Source: ABdhPJyZcIPxqI061aZSIz4/wOG8MIjCzx1/IGr1O74KMeY0yclhOMeVn1PfQJDWXy+egSNKM0RvAw==
X-Received: by 2002:a62:1bd2:0:b0:44c:db2e:5a88 with SMTP id
	b201-20020a621bd2000000b0044cdb2e5a88mr13192615pfb.29.1634317177017;
	Fri, 15 Oct 2021 09:59:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	t38sm1001799pfg.102.2021.10.15.09.59.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:59:35 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:59:35 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150959.D3A3EBD2DD@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-13-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-13-hch@lst.de>
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
	linux-ext4@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net,
	Anand Jain <anand.jain@oracle.com>, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 12/30] btrfs: use bdev_nr_bytes instead of
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 15, 2021 at 03:26:25PM +0200, Christoph Hellwig wrote:
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


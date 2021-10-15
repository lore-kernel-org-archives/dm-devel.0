Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02005C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7D45D611C1
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7D45D611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-pCDfWVuCMImiUhTRzZvGJA-1; Fri, 15 Oct 2021 12:54:48 -0400
X-MC-Unique: pCDfWVuCMImiUhTRzZvGJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0291EC1A0;
	Fri, 15 Oct 2021 16:54:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0F845F4EB;
	Fri, 15 Oct 2021 16:54:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84477180598A;
	Fri, 15 Oct 2021 16:54:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGsfZw012377 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:54:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DDCC510EB2A5; Fri, 15 Oct 2021 16:54:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9A5B10EB2A4
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:54:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F2CB1066558
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:54:39 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-286-ma1m932gOl-mbyqZys1hZQ-1; Fri, 15 Oct 2021 12:54:37 -0400
X-MC-Unique: ma1m932gOl-mbyqZys1hZQ-1
Received: by mail-pj1-f46.google.com with SMTP id
	qe4-20020a17090b4f8400b0019f663cfcd1so9758749pjb.1
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=++j3EKFYagTjYpVDRmVtpilprtSSGPZNL/U6+y1BFYU=;
	b=wUqIsGhk/7kh6rou95ux7qMAr7D2nc9gBxKBbqeyC5PTTcwz6SB2uAyvJn6t9hFQsn
	6ZeytOCxxXTV8b4n6jFEMxNVNz5HgjmgtqEMMNUHMCaYxCyZAAw7/ZuiAQfLkNSmJAhm
	iXgmjzCO6NkcCMytcVD6C8V+RAVoqlqmgQsACH8l9FB3lMomWdvKdr9AdIQ7E4HyArjp
	BZSPEoYSukerentFfagfcjjhbLms5ObT1tB5S63MHmSRl9MBkDcbDuEds1GbnNg85YJG
	zF3NX84rkvzrNYPuTrPyAElJPBRHjgWPh36pTi88WDG5f/jYZ5KCaXJMQ6c9ArJr8dUr
	NQlA==
X-Gm-Message-State: AOAM5310/V7L6dOvrFmNCV9qWg2S1foGlKkrOoC+gSluSJnkTWJsnAVk
	7t3qOIxkXSMxk89rQ7yW1lM0Cw==
X-Google-Smtp-Source: ABdhPJxiUcnkoooEgdTHhZSK5QlfnfikulhFK8mfbnmCN2PXzxc7k6fawv/6LA10hComZoogNKw4PQ==
X-Received: by 2002:a17:903:3092:b0:13f:663d:f008 with SMTP id
	u18-20020a170903309200b0013f663df008mr11973339plc.13.1634316876253;
	Fri, 15 Oct 2021 09:54:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	t126sm5505715pfc.80.2021.10.15.09.54.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:54:35 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:54:35 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150954.45A4DFA79@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-20-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-20-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Subject: Re: [dm-devel] [PATCH 19/30] nilfs2: use bdev_nr_bytes instead of
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

On Fri, Oct 15, 2021 at 03:26:32PM +0200, Christoph Hellwig wrote:
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


Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8313BC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 15:53:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0BC0611C1
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 15:53:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D0BC0611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-cTYGbEDROoqalPEJLQRk-w-1; Fri, 15 Oct 2021 11:53:26 -0400
X-MC-Unique: cTYGbEDROoqalPEJLQRk-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEF90801AA7;
	Fri, 15 Oct 2021 15:53:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5475F60C05;
	Fri, 15 Oct 2021 15:53:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3201C4A703;
	Fri, 15 Oct 2021 15:53:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FFpJPm005606 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 11:51:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 82D6D404727A; Fri, 15 Oct 2021 15:51:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EB924047272
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 15:51:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66C10185A7A4
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 15:51:19 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-500-wK772PXkNc6eGZuXkioQZg-1; Fri, 15 Oct 2021 11:51:17 -0400
X-MC-Unique: wK772PXkNc6eGZuXkioQZg-1
Received: by mail-pj1-f46.google.com with SMTP id
	nn3-20020a17090b38c300b001a03bb6c4ebso7591634pjb.1
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 08:51:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=DZnDLe/hPV82nGDaQ9SybgeRvq4v8194pDCOmq4WnGI=;
	b=QA4VnqdC1WaH/A20cuNXa+7ZVIU1lMspX29MPKwmMRqNLPJk/qEt3Yc9A1D9/pw0xr
	NaQvisyp33urfMChvHAksox59ZHnq/tsTt3uzWVDLkPCGVFU+5qd0qKhN3LWSqwEhuP8
	yLNxh9QUSFF/7sk5UKdgjY8Y8Es7HETa77VIIFCtWoPdEu/2sXzjTUBfpDYFWs0XODuS
	heiDhwpfvMm9nr0+/Ro0ZxrFvcrIcw89/RT+fJZnpE5kpMvXZKdsXxmT1K+9A1bcTofT
	ftNpvKzpZ1DYCa+9ID23A6tXG4WmQsGxWaFWg4ZTz8rfr+P2O9ej7XaZpkZhBSnBArSG
	6jSw==
X-Gm-Message-State: AOAM5325ARN7Beu0uu8Hfj9xUojECqp9JMFQ02sRSsLpKSP5Ku8P+Msh
	u8Ev+xyqFNQ0bD8RUX+j3/FSYg==
X-Google-Smtp-Source: ABdhPJxDmKDta0sIDCKxrBjrXvbcujsYquDk3gV7yUWEsTdaAg5jq62C+ng3dE34jL0hht2zFj2KNw==
X-Received: by 2002:a17:90b:224e:: with SMTP id
	hk14mr14307733pjb.224.1634313076478; 
	Fri, 15 Oct 2021 08:51:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	k17sm5446139pfk.16.2021.10.15.08.51.16
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 08:51:16 -0700 (PDT)
Date: Fri, 15 Oct 2021 08:51:15 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150851.0021855B14@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-8-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-8-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 07/30] nvmet: use bdev_nr_bytes instead of
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

On Fri, Oct 15, 2021 at 03:26:20PM +0200, Christoph Hellwig wrote:
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


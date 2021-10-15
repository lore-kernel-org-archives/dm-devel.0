Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAA0C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:57:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 003DB611C8
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 003DB611C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-RPahZ0QlPPWuJQQ9NlrZgA-1; Fri, 15 Oct 2021 12:57:17 -0400
X-MC-Unique: RPahZ0QlPPWuJQQ9NlrZgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7F8BEC1A2;
	Fri, 15 Oct 2021 16:57:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBD5A60C9F;
	Fri, 15 Oct 2021 16:57:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9F77A1806D01;
	Fri, 15 Oct 2021 16:57:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGvBPb012697 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:57:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E09F2026D65; Fri, 15 Oct 2021 16:57:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08CAC2026D5D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:57:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38F78800963
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:57:07 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
	[209.85.210.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-516-jFv97nHGOmKku6JRFWdcSg-1; Fri, 15 Oct 2021 12:57:05 -0400
X-MC-Unique: jFv97nHGOmKku6JRFWdcSg-1
Received: by mail-pf1-f173.google.com with SMTP id c29so8888230pfp.2
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=K+6isvwekOgtvopkqE4I0h7AgNguipVYqeEY21w12Mo=;
	b=tLNG5jSAJgN6tWy2RqLEMXg1ZniPkJhm9mL4RD4Hd3oc74VD6kt8/K8L7QsDO4r+fj
	eNsz5SLKncIs8MT7NcL/sbwsc0wEXjFjUNJkGyrUTh+e0ItX0xF86Q+b+3Nkfw3U7BKv
	v6P8H5wau+nnHR+dhdNUtWM1Syqg1uQRaZIZ0VEonk2p8m4fqemzKJRfFG0F7Ad+I0qB
	qBAdGj1oWKY62c/3FkSUX9jewecRXiyB0UQOmwWdJKHCt1uRC3VZOh8a+1fVDgrMeuTD
	GrbapNe3wccwe6urddnTXlQYoR0cObeiucLDU63erkO25Qbk+hspcwzhvKNxNvpP2RV7
	nUPw==
X-Gm-Message-State: AOAM530MIeHT/7PQ6MDOSONG56HmZ7l2zSCQ766VtPK0kU3gF9xo9j4Y
	wbDRw8VgSQebgD405FOcomsq2A==
X-Google-Smtp-Source: ABdhPJy+YUT6npY/fZ/G9URvGOZpt9eamOIJH1D5JMCGxtLxyzdwQfs5MmBQFVKQI/Zn2W8hW6yLYA==
X-Received: by 2002:a05:6a00:1309:b0:44d:4d1e:c930 with SMTP id
	j9-20020a056a00130900b0044d4d1ec930mr12851663pfu.65.1634317024412;
	Fri, 15 Oct 2021 09:57:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	b16sm5793589pfm.58.2021.10.15.09.57.04
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:57:04 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:57:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150957.38CBB0C08@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-24-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-24-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 23/30] squashfs: use bdev_nr_bytes instead of
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

On Fri, Oct 15, 2021 at 03:26:36PM +0200, Christoph Hellwig wrote:
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


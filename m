Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6437FC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:57:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E16DC611C8
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:57:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E16DC611C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-WjuZTQQmOWKtSOR_orZWAw-1; Fri, 15 Oct 2021 12:56:58 -0400
X-MC-Unique: WjuZTQQmOWKtSOR_orZWAw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CEF1EC1A8;
	Fri, 15 Oct 2021 16:56:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7161D5DEFA;
	Fri, 15 Oct 2021 16:56:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4DDE31806D01;
	Fri, 15 Oct 2021 16:56:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGupA5012651 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:56:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8FF6440CFD11; Fri, 15 Oct 2021 16:56:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B51040CFD0D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:56:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 736EB8007B1
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:56:51 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
	[209.85.216.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-415-IPmfA_LPOA68w-F-LnVIFQ-1; Fri, 15 Oct 2021 12:56:49 -0400
X-MC-Unique: IPmfA_LPOA68w-F-LnVIFQ-1
Received: by mail-pj1-f42.google.com with SMTP id
	lk8-20020a17090b33c800b001a0a284fcc2so9765235pjb.2
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=vfh8ldDPWodO2+NAKgs+77i4cirGVTrsvlhR7sq6n14=;
	b=K396rRKGsgNOGO0hiIm/8rmMS7S4Y92Kt/3qgY45Lv4UWxFy3LlLngHW0TI30LVf1N
	j6U7EktB4ZCPj0fTdozKjutpT+hsONKdnWuG5Nxb3EjoFPUse3t6PxmY0t+TyzywPxzd
	xKC61a7IVul4AiffiGZfUnknub7WNDucCIShOeFB8dzmrq/72KDi+QH4GmH7ZDntvNTG
	DaTXAza58g2rNA8vh+70PCFzY5ok8sZsa/go8vRDIqb5VfxwTWwfxa8h40ONz28tp4Cr
	trfTiktn6U+0lVvwvC9i6igV8+4P9xKmqwfMtrvh9hpFdAacsDwOfxQrWHJcSJ0otpnx
	teug==
X-Gm-Message-State: AOAM531Ip2XQcyt44LNDyJv0QC2+sLpTXSFoxtzWnF/gl8eC7JcMYjlU
	Ht/g68GlxFDO2xCuzSZLI7z/jbKIjH4vIg==
X-Google-Smtp-Source: ABdhPJwnnQ3ulrXVGFg4s+UA3ddGM8HwmAEnk5XYfNq6HtGw+i5b3OvChqf29ta/Idk60aluKwm2lg==
X-Received: by 2002:a17:903:18d:b0:13e:f1ef:d80c with SMTP id
	z13-20020a170903018d00b0013ef1efd80cmr11974419plg.63.1634317008672;
	Fri, 15 Oct 2021 09:56:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	t125sm5518370pfc.119.2021.10.15.09.56.48
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:56:48 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:56:47 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150956.A0360E2D01@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-23-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-23-hch@lst.de>
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
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
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
Subject: Re: [dm-devel] [PATCH 22/30] reiserfs: use bdev_nr_bytes instead of
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 15, 2021 at 03:26:35PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size and remove two
> cargo culted checks that can't be false.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


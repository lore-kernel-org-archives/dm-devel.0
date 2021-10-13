Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534FCC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:17:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D3ED460E74
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:17:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D3ED460E74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-nvdNiM1GMGqGiV3_m8klmA-1; Wed, 13 Oct 2021 02:16:58 -0400
X-MC-Unique: nvdNiM1GMGqGiV3_m8klmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A35910A8E01;
	Wed, 13 Oct 2021 06:16:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57168196F8;
	Wed, 13 Oct 2021 06:16:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2CA451806D00;
	Wed, 13 Oct 2021 06:16:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D6Grnx028461 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 02:16:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F0CEA2026D46; Wed, 13 Oct 2021 06:16:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB14D2026D65
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:16:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13890899ECF
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:16:50 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
	[209.85.210.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-413-nd73l8g-P0KzeCfSeTbmZA-1; Wed, 13 Oct 2021 02:16:45 -0400
X-MC-Unique: nd73l8g-P0KzeCfSeTbmZA-1
Received: by mail-pf1-f172.google.com with SMTP id g14so1555513pfm.1
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 23:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=WC8qlO5hS71mDqsT8bl0w3ijZFYGEZDCAo8tBaqenJs=;
	b=LxiKpw3qIVK/IRCZsiZk8BGXYbGqCCXJBPc5en1CMLYU+yBPT/s6vBoQQYQdxfI5yj
	sxnz+1OjvRCfa5Qqz1vf2/C607UipRpW3O1iaLHDA+yufKFUEpfZr828JzoeP57zzceZ
	6tnRRxgVyFpM2w1YWNsRQ4zjd4d7OFxgtn1k3KIxFVJZP1GJ6zj7NhOw0xI4w9mfkiKo
	yKuiNp5rvA4YIYFIPUbUBp/4qxdCLpPq4nq2drir7EDayUfJb3F38TWds3MwXRytU6NX
	8oR/p1Txlu8b69A0DA/xqbCrNHBqxTw8u6CWlmG9X2ZLC/MY3XlPWoGmHmuu0F05cylf
	+d/A==
X-Gm-Message-State: AOAM533pxi9bGUjW3vD9CxHxA5VVH29k7ha7F3XfpCgSJSJOPG0l0K8z
	xtXkjG/XkvM2mlwhvasbdk4eNw==
X-Google-Smtp-Source: ABdhPJywBNvyfgfyQbknPTYchwSJjS8lkA7Ed3FT30CWk3r+y/Lrw7XBaVRa792lS0jCj03fnTC0tQ==
X-Received: by 2002:a62:1b8e:0:b0:44c:9318:f6e1 with SMTP id
	b136-20020a621b8e000000b0044c9318f6e1mr36636622pfb.84.1634105804176;
	Tue, 12 Oct 2021 23:16:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	z4sm13596761pfz.99.2021.10.12.23.16.43
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 12 Oct 2021 23:16:43 -0700 (PDT)
Date: Tue, 12 Oct 2021 23:16:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110122316.C8D15CD2@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-15-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-15-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 14/29] hfs: use bdev_nr_sectors instead of
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 13, 2021 at 07:10:27AM +0200, Christoph Hellwig wrote:
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


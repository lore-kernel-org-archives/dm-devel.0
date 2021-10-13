Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31ECC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:15:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1B7F160F94
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1B7F160F94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-dHMolAkCPU6cHkqApW2swg-1; Wed, 13 Oct 2021 02:14:58 -0400
X-MC-Unique: dHMolAkCPU6cHkqApW2swg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F53B1006AA7;
	Wed, 13 Oct 2021 06:14:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F7DA16C0B;
	Wed, 13 Oct 2021 06:14:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 050034EA2F;
	Wed, 13 Oct 2021 06:14:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D69PFb027769 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 02:09:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D28875AB7F; Wed, 13 Oct 2021 06:09:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC86C568FA
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:09:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F36AB811E7A
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:09:22 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
	[209.85.210.176]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-428-IK_rnv98NniYcysmjwREuA-1; Wed, 13 Oct 2021 02:09:20 -0400
X-MC-Unique: IK_rnv98NniYcysmjwREuA-1
Received: by mail-pf1-f176.google.com with SMTP id t15so1478493pfl.13
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 23:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Qqwh23O6V/63P0yRnTO77bOtLRcytQL2fAyeRI5kB34=;
	b=FQm5eNQO4heEtoIfhVR8OXWE1e5EePha0FW8E06UEkVtPoxXAM8cQx4FXDteMmkLbT
	DI6tRUruDYQt8cHuT5hOuMt3lo5xALN7sfCIBmbey0WYTIJ0QvS+T7Nq/eJTZrYTcmCP
	57SToCjCYJgCCv2l3jmOCwm7OlR7God6IjkdtXxXhsZjUezXCJUiQFd5s+7p77dYQHfv
	ygRZrsxIGQa/nDc/Nen+t0roWlpcJGySNPgGM9HZk9f94d7WNHNYyb9v/b1un6LEDlJb
	Dpf5ozBUGi5RjkI0s6+O4P99mQjieG//5vGrA29HuQBBshsIclhYYg2ByAHTlm2LdoLU
	rlEA==
X-Gm-Message-State: AOAM5313AqZTn0Vdo+JAxWJoPlZNZTjmumHXtOQaRhDzB6boaklYRDmE
	59Htoy4Zok1z1/SXb99holKEeg==
X-Google-Smtp-Source: ABdhPJzPVB6suksbrVxsW8arxDgbrt+zmZKpBhbvkmkjyXI+mBKX9gJNh2h2afCA7c0GFA7FKUgXzA==
X-Received: by 2002:a63:d40a:: with SMTP id a10mr26426089pgh.7.1634105359458; 
	Tue, 12 Oct 2021 23:09:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	e6sm12787858pfm.212.2021.10.12.23.09.18
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 12 Oct 2021 23:09:18 -0700 (PDT)
Date: Tue, 12 Oct 2021 23:09:17 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110122309.010F81F49A@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
Subject: Re: [dm-devel] [PATCH 01/29] bcache: remove bdev_sectors
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

On Wed, Oct 13, 2021 at 07:10:14AM +0200, Christoph Hellwig wrote:
> Use the equivalent block layer helper instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4846FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:33:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDF8661027
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 06:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CDF8661027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-inwy2TspN4OPvqUbB6rWKQ-1; Wed, 13 Oct 2021 02:33:35 -0400
X-MC-Unique: inwy2TspN4OPvqUbB6rWKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6A2B8042F0;
	Wed, 13 Oct 2021 06:33:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8F2C22713;
	Wed, 13 Oct 2021 06:33:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 77C0E1800FE4;
	Wed, 13 Oct 2021 06:33:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19D6XS4B029523 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 02:33:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6B17C2166B2D; Wed, 13 Oct 2021 06:33:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 658C02166B25
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:33:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBA41802A6A
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 06:33:24 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
	[209.85.216.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-134-222fffJaOtO10JC3N9uUlQ-1; Wed, 13 Oct 2021 02:33:23 -0400
X-MC-Unique: 222fffJaOtO10JC3N9uUlQ-1
Received: by mail-pj1-f41.google.com with SMTP id
	nn3-20020a17090b38c300b001a03bb6c4ebso1476694pjb.1
	for <dm-devel@redhat.com>; Tue, 12 Oct 2021 23:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=KN0hCxg4qCtDzIgJk5dwSpisgOtLaF48lTZLQMzdZGQ=;
	b=4nR/kwlAVGiPqYWyc0o1peBvjtUzdZiJ+mUJ8MXge058fYZ5V/GmQ76H44VZ4g1gMM
	G34qhU6ARaKE6w4cyvUgLkFPBWiBZw0CokaNjrt36cPnURZONqtIzzIfkO5lntvfiTCi
	BELbxnuuWPZH7hrfU6Gm1p7qTqqDbjd0lB5m+5DAZp8G17sH9mi7Vrbcf+cmNkRXyLgm
	CAZsEj/mcOp3obRhVeeuWxIvNinmxj67E8Mu7yDw/hOTSHF8cNYlD9afJUTRYDSLi3H6
	d6FMM0jwEdJ1NxoQ0sfU4zFIZ3hABRfIGXcklpZ1/PqlifAjo6wXTnyCyUnd8Ii8/tHZ
	55dg==
X-Gm-Message-State: AOAM532A4wjZsn7rgVJLjPM/XNB044GwnlMIctdxSVdLmi8wQqfTnDQu
	5VRHH3OWdmGx5VWK3tprEQ5mjg==
X-Google-Smtp-Source: ABdhPJwSbdMnxpZNPs6DEcJzD+WCYFHCQcM73CXxNLIwDuWek8lOvAv7bQAbdyDz750VOQBh4gVb4A==
X-Received: by 2002:a17:902:e5d2:b0:13f:21c1:b44f with SMTP id
	u18-20020a170902e5d200b0013f21c1b44fmr23591611plf.30.1634106800893;
	Tue, 12 Oct 2021 23:33:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	s8sm8887899pfh.186.2021.10.12.23.33.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 12 Oct 2021 23:33:20 -0700 (PDT)
Date: Tue, 12 Oct 2021 23:33:19 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110122333.7CE920EB9@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-29-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-29-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Subject: Re: [dm-devel] [PATCH 28/29] reiserfs: use sb_bdev_nr_blocks
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 13, 2021 at 07:10:41AM +0200, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A5DC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C877961181
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C877961181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220--pAvaEVlNga3hncJTpWURA-1; Fri, 15 Oct 2021 12:54:30 -0400
X-MC-Unique: -pAvaEVlNga3hncJTpWURA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 878D9100D680;
	Fri, 15 Oct 2021 16:54:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FF4D60BD8;
	Fri, 15 Oct 2021 16:54:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0234E180598A;
	Fri, 15 Oct 2021 16:54:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FGs1aP012278 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 12:54:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A5C3A2026D48; Fri, 15 Oct 2021 16:54:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A14EB2026D46
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:53:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 564FA899EC0
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 16:53:56 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
	[209.85.214.174]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-266-cO7Gtu1TPjWqPqIdXZfKtQ-1; Fri, 15 Oct 2021 12:53:54 -0400
X-MC-Unique: cO7Gtu1TPjWqPqIdXZfKtQ-1
Received: by mail-pl1-f174.google.com with SMTP id f21so6770172plb.3
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 09:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=i/gIfzDIY8BHp2GAnTGqbUaWifgLmmgJaZHOEikCPNE=;
	b=j2i42RL9wkrJsYHfFRWUs9/uBBTmop+q7+ADmlZPFuqpMegN2O47czQ0CZmDDgVVjf
	DW9xLs7PYqXISLNxFJohjsFezy+uQ/f3K6I4G0GYRTxAsoVC8Lr9+avA7wWcyJc3Sc/r
	z6iGk/u7863GHEnxtXK27HfN2zoWvg66IfIelHthKhx4wlwJwL3USU2j1wTKLdTCVntw
	leQQ02obtx4JPNYpBa+LNvT87rOmaci+lRWS9WGsjyF63mQIr2sJEqN5U4iJwuMdEa6t
	t9I92MY4+pHpWorY/pHlHBO6SCWBuujXJTpFODm8WRaqFOmJgd2aa8wVil7j1Z28PK3P
	t5Wg==
X-Gm-Message-State: AOAM53390X2EUokz5fgsYixqiRzx0HL5/B6fbWV92Fhz5UU5hx29Gl6j
	IsHPoC54x2x1lMhkPGiYpUCHew==
X-Google-Smtp-Source: ABdhPJwk57gXwSH1fuk9uQJ3MKRp8IS5de92E1niz0LUeVepi4gZ7xD6FT4x0ovJQOMjXdqoZrATMw==
X-Received: by 2002:a17:902:eccf:b0:13e:b002:d8bd with SMTP id
	a15-20020a170902eccf00b0013eb002d8bdmr11944496plh.48.1634316833234;
	Fri, 15 Oct 2021 09:53:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	j7sm5286487pfh.168.2021.10.15.09.53.52
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 15 Oct 2021 09:53:52 -0700 (PDT)
Date: Fri, 15 Oct 2021 09:53:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <202110150953.4C55C8948@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
	<20211015132643.1621913-18-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211015132643.1621913-18-hch@lst.de>
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
	linux-bcache@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 17/30] jfs: use bdev_nr_bytes instead of open
	coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 15, 2021 at 03:26:30PM +0200, Christoph Hellwig wrote:
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


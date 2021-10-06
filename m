Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CB2C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:32:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 359AB610A8
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 359AB610A8
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633527121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3/mNs3JmPaO95Br8RkLsJseiGt18EuKlMcl7wDoniSs=;
	b=h+CsdbTclq01zuuVpMlXxPdelo0n2RrAN204m61f1dNT4JwAkRXtdO6aGuYXd2KVT2Oi+w
	swJcRUFen5SMtFS1Ylla1PRg61hEWwq/X75O1pHqBh7JS+YUDZchqzfGjXAl+0f1xPpQhr
	FOK61BJrjjiv2TvS3tW8HKyrOYVyEaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-S276Z9ycOUKmnh6OiW4Hww-1; Wed, 06 Oct 2021 09:31:59 -0400
X-MC-Unique: S276Z9ycOUKmnh6OiW4Hww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5026A56C26;
	Wed,  6 Oct 2021 13:31:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 092F99AA20;
	Wed,  6 Oct 2021 13:31:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD16B4E9F4;
	Wed,  6 Oct 2021 13:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196DPPFO014724 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 09:25:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 113BF2026D48; Wed,  6 Oct 2021 13:25:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CFDE2026D46
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:25:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4CC3811E97
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:25:24 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-188-r1vKzEjgPQy2dLfsCbZUYQ-1; Wed, 06 Oct 2021 09:25:23 -0400
X-MC-Unique: r1vKzEjgPQy2dLfsCbZUYQ-1
Received: by mail-qk1-f200.google.com with SMTP id
	v14-20020a05620a0f0e00b0043355ed67d1so2152502qkl.7
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=REf5XfxKy2/DOMCe3ZbKnMPcGwKfHql13e1o3U4ongw=;
	b=zdcz6m3cke7Z+2dnvWWt+KYEvg6wCJ4OOVrQkjs/n/C79ph/khoGtnQf1nEMq5SvYC
	5ODNl1S1KA8DpimUIyyyvER5dsfqXVMgxvG2QZjmhHXjIhMuzxWi0A5x4bNQEoM3Om2q
	z4nwdJQCFEAkAHxV0rcG5CpPlsFsZuBb9rTiDLIjGzT31DyI7rsI5gX8qivnveqDC7b5
	dwWMPy9N4krZWXzmBy3ON5Rr6FhuAeZFgMuBBVHn7t/8qOt9NhHmbTsnvutzDN7aNpsF
	N29odOcpJ7qBjHFHl+SImgAEdtq3jnr3TdvzPlayU940lHMykFh3+l/59pYmDqWNdmXI
	kNyw==
X-Gm-Message-State: AOAM531c5uav3O97bbZv1Uvn+bFDbB1f+6Vdbcg6USU62jVi0U/MSvn1
	ZQBWg09ENmbQpCx5Oki98CKqf3CMVU2NHmDm0tjuKgpVZYA3OG3Uth+W7ekrrwq2gssed/pA7QC
	1UsxvXJU/hT679Q==
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr26967157qtd.382.1633526723438; 
	Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+PKn5GM9cvmQAEvw5ba5TX7RO88qJGng/rIUSvV54/GxbODRhQ88kDsUXdjhkd0AFADfwww==
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr26967139qtd.382.1633526723289; 
	Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	m11sm11234942qkm.88.2021.10.06.06.25.22
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 06:25:23 -0700 (PDT)
Date: Wed, 6 Oct 2021 09:25:22 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-ID: <YV2jwuFGgSfxS56K@redhat.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
	<20210929163600.52141-3-ebiggers@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210929163600.52141-3-ebiggers@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v4 2/4] blk-crypto: rename keyslot-manager
 files to blk-crypto-profile
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 29 2021 at 12:35P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> In preparation for renaming struct blk_keyslot_manager to struct
> blk_crypto_profile, rename the keyslot-manager.h and keyslot-manager.c
> source files.  Renaming these files separately before making a lot of
> changes to their contents makes it easier for git to understand that
> they were renamed.
> 
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


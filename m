Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF94DC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:32:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7006261075
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 13:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7006261075
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633527175;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7wvPpbO4gkFu6rlaVV4Gr7kUf3SG8gboezrnyFJhqH4=;
	b=PxRsjYyvqF1z0gK7xngTam/SNVAzvxbvvs8dPL5mL8XDD+UJhHXa9ZWuOQViaw5SXtjwqW
	5ZcXvO5MIUxLXJF6AtogGt5p5RMurtauT2RLq6p5sCYgA2bJYgdb17yqhfG2IZIKOZLMs5
	cuTcnM+Q1ft4nEFFBH9lH4Br7gBD70Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-TK3qTSrVMJmjc1Iz7psYSA-1; Wed, 06 Oct 2021 09:32:54 -0400
X-MC-Unique: TK3qTSrVMJmjc1Iz7psYSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 853E1100C66B;
	Wed,  6 Oct 2021 13:32:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E7905FC13;
	Wed,  6 Oct 2021 13:32:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 111581806D00;
	Wed,  6 Oct 2021 13:32:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196DTX03014968 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 09:29:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 40A891112C37; Wed,  6 Oct 2021 13:29:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 327D71111C7E
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:29:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5303980A0AB
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 13:29:15 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-471-BBuxcslzPxurk6aJHJQGlQ-1; Wed, 06 Oct 2021 09:29:14 -0400
X-MC-Unique: BBuxcslzPxurk6aJHJQGlQ-1
Received: by mail-qk1-f200.google.com with SMTP id
	q5-20020a05620a0d8500b0045edb4779dbso2189029qkl.2
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 06:29:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=wzQmzBUEihVkKDDjIOOM5bJWBT7h0GK8QC/ZlgQykqs=;
	b=R8iAtQjPIvqQzIxtYd8RyZzk3zbHT1rG8bO3X/FldNaXe3VJnFu32XqesraKyPcCM5
	VQN82MkubICMUxEGnhuZmwMAZewE4LXq9aYKz1jFsJA+YH8SNAfm968ZxAsu7QZvv1yh
	NnvmjWaTPlzXEnLUmr7s3PjXN6XvNA8pf9QAjf/10lRUW3QbwzlvPe/3sNk99XXGqQ+H
	hBcbTEpuHK6fbQniigZBZWYPb2WW/oHffUgxgPawTO1Xil5qwOCWuPpKbNHZhaWiYucx
	k4TuH0Sfg2cSAyzHzmMujprou62zUWUVlFSLVyRYgHDTQdOfE/S4P3w7MReXKiH2Kapo
	FRxQ==
X-Gm-Message-State: AOAM532dyD8jB4rVN22uf5089mrCdNLZ39pgAEi6edkrt0NifbbrrNL+
	G3mnrVyRsJCFGo+1TtMb0Xd0knssHou8jhymUeqUQwGUEWdYUgL5Uh5LyYpbITF9dQIa6AWtr/U
	rNAv9CWLVRcuAxg==
X-Received: by 2002:ac8:88:: with SMTP id c8mr7511083qtg.12.1633526953771;
	Wed, 06 Oct 2021 06:29:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/8v3wqkJ1Y5E44+yD/hKM+9kQgCyFGq7beETeqK37nW1j+ndjaNNfhnHZDIHaVp6v5rSBYQ==
X-Received: by 2002:ac8:88:: with SMTP id c8mr7511066qtg.12.1633526953614;
	Wed, 06 Oct 2021 06:29:13 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id z6sm950959qke.24.2021.10.06.06.29.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 06:29:13 -0700 (PDT)
Date: Wed, 6 Oct 2021 09:29:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-ID: <YV2kqFA3y3qo8ls/@redhat.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
	<20210929163600.52141-5-ebiggers@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210929163600.52141-5-ebiggers@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 4/4] blk-crypto: update inline encryption
	documentation
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

On Wed, Sep 29 2021 at 12:36P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Rework most of inline-encryption.rst to be easier to follow, to correct
> some information, to add some important details and remove some
> unimportant details, and to take into account the renaming from
> blk_keyslot_manager to blk_crypto_profile.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


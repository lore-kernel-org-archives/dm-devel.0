Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3DBC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643826800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b/Twm3Jk8Dktx5E6M0wVhM3WR2qxAdA2D7arjogRPew=;
	b=XunYyqBytC4NgrzItgjMcBR8+xAyHWG4yd8KxoH6+hMFXPt2RL/BPxMnigQEAopESnq4LQ
	NoiDjkru/yVnTVVZTQTqz9e5jmrzl1lpZVayPhC+uu7pClLrWPJ/DJqSWUUsmXDVWA/8Il
	riaSqM+a21zerHzV9e26JVPI6oJDoG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-fkOPoKR6Nj-er-qZVwb2qA-1; Wed, 02 Feb 2022 13:33:18 -0500
X-MC-Unique: fkOPoKR6Nj-er-qZVwb2qA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B601835B47;
	Wed,  2 Feb 2022 18:33:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8946184D12;
	Wed,  2 Feb 2022 18:33:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4ED121809CB8;
	Wed,  2 Feb 2022 18:33:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212IX59t005924 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 13:33:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ADE2840885B9; Wed,  2 Feb 2022 18:33:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8D5440885B2
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 18:33:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E6FE805F4A
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 18:33:05 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-403-nJ5C5YvQN9yrx-BtfB7_Aw-1; Wed, 02 Feb 2022 13:33:04 -0500
X-MC-Unique: nJ5C5YvQN9yrx-BtfB7_Aw-1
Received: by mail-qk1-f200.google.com with SMTP id
	g3-20020a05620a108300b0047e16fc0d6cso380739qkk.3
	for <dm-devel@redhat.com>; Wed, 02 Feb 2022 10:33:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=53Uot1wvZSt1uP0+nqAgLg+8waHH8Mj8+skF7+R4kzQ=;
	b=Y1RpMlwhz5NcFj/4FDYPGEL/3bq5BvxR3yghE2oo/e+3USk3CC7Qch6/O5gj6CsvGV
	Zr1HUh84siHwQc8FGs4x4Om3SpdBJKDLgVhqsge4Nm2VQMLrd4nlSICWI+HTeyVY6GcM
	QNitKFmvpuv78B8Lezs67OVOVv1Kap8KOhJvK0lZMSnQHAd7TyMPkhjD32uf61CO6reh
	64RjFymh6u38L8fWu2Fyz9QkbQCcOKvjLKshCTVK1TzgxZoh904KoISTxIu2lEOL3awU
	JP2pbc3ZZonDAJXVAQ4wNSbmqHJN6LeCI3bPucTYfaYtysyCf+Lyn/2O8gNP/v9aOdvu
	xKug==
X-Gm-Message-State: AOAM532ROIii+BQ5zOigUZ5Ic6IbNlDZaXY+u/jRgzTORhHzZWqtLFlG
	GxOpRVPJXxVjkEmQL74r2zsvqNczesT5JpJC7Gm4bpDCMk/trvp1g4wliDJGk6NdYxQwMzWvX1D
	Mima4gLwQRVpsdQ==
X-Received: by 2002:ad4:5745:: with SMTP id q5mr27182557qvx.55.1643826784147; 
	Wed, 02 Feb 2022 10:33:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+xpPw5Ufa5QPVUE8hEtOkyVx76EUcpxqMD2VGXdH8iCwT01cOCO2Iq6GBrYUrepIug8Ij6w==
X-Received: by 2002:ad4:5745:: with SMTP id q5mr27182538qvx.55.1643826783950; 
	Wed, 02 Feb 2022 10:33:03 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o1sm13822596qkp.49.2022.02.02.10.33.03
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Feb 2022 10:33:03 -0800 (PST)
Date: Wed, 2 Feb 2022 13:33:02 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YfrOXqVVwcwIoArj@redhat.com>
References: <20220202160109.108149-1-hch@lst.de>
	<20220202160109.108149-8-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220202160109.108149-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 07/13] dm: retun the clone bio from alloc_tio
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

On Wed, Feb 02 2022 at 11:01P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Return the clone bio embedded into the tio as that is what the callers
> actually want.  Similar for the free side.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Small nit, subject has typo: s/retun/return/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


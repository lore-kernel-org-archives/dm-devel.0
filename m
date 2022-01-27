Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2525FC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 19:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643310483;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XWDAKUKN0sEnJQdf5EB9jBTxfTT/QQVHa1pZmLHgdMY=;
	b=X1NJ4OMFKdKklkBYa9L50vIUflbv/ITduWf2Q78UPBrKneZxv669WHWnYRfcsUMQKOe5KF
	FwIL6d9qfQDHnYwC8oMKGhQkj89E4tZv88Cge0ltvrbMYyOGdenRZnXqilDw56+IkvuGIo
	0b5AqJ+KrStSDNBsdX+l5eCZjgGwmjo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-Or-gLpl2MuWhrw6Rfwk-sg-1; Thu, 27 Jan 2022 14:07:57 -0500
X-MC-Unique: Or-gLpl2MuWhrw6Rfwk-sg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ECFF8145E2;
	Thu, 27 Jan 2022 19:07:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B33205D6BA;
	Thu, 27 Jan 2022 19:07:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 76C391809CBA;
	Thu, 27 Jan 2022 19:07:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RJ7lBJ004291 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 14:07:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 16D4F40885B5; Thu, 27 Jan 2022 19:07:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13AF640885BD
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE36A2BD19E9
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:46 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-3-HGJtCm8jOJGaZdLpWC6VdA-1; Thu, 27 Jan 2022 14:07:45 -0500
X-MC-Unique: HGJtCm8jOJGaZdLpWC6VdA-1
Received: by mail-qk1-f200.google.com with SMTP id
	p20-20020a05620a22b400b0047ecab0db4fso3160541qkh.2
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 11:07:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=OaRzF3xvYhcODcVUOmZQDjADhYKacgp04Z3+AcxkRnM=;
	b=RSwjKVNarUOtqLn1usbAMYSwu1SD2KtEVdPGU8SyTuStTToOBXaBOPVE31o/rpgHP1
	9kG7kTBbVcG/8RiRweWFJOYgMttOzaX2aLD7glBvqmU4RSEnSdGlY6KOXO7TKfBp76I8
	uXk5/2Nm9exTlt20X6+WPnzIYcP7FTcPUpU4nJBY4kkv/CxUjh4zBM16TSnWJPboahXe
	l0X/jqvgTs0VmxrjpgBDjPj7c0aBq88WY0qn+pCVtJdhOrGaNpMjjB8Cnp9Rq/sCBt3k
	2Z/27WgvZX+ddb4YJq6KFdRxiopejdEdSul2cwVZNqW6dSMPDCki94kcb3M3utOXwTRI
	fGLQ==
X-Gm-Message-State: AOAM533AOedJx2+H8gocR5hXYdhEIF/fDY/LDXAnzvLWtFefYTbwp9wl
	8a05CbnOjyHs4Ce4oBRL3vE2/5LqWTX66AT2l69PWRlOBmqUrBfq5Sy/WNRLJNRL9QUUTbHmOB2
	eMiv9tIUjaPkUdg==
X-Received: by 2002:a05:6214:76a:: with SMTP id
	f10mr4489259qvz.85.1643310464982; 
	Thu, 27 Jan 2022 11:07:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynf7Rz6AS8mWVd28TKss0f24ARumnzqA4qfRaxnHbQp6Zr3lwHM7g2J6br5z8MWE6Gpw7AKA==
X-Received: by 2002:a05:6214:76a:: with SMTP id
	f10mr4489237qvz.85.1643310464748; 
	Thu, 27 Jan 2022 11:07:44 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	l1sm1934493qkp.100.2022.01.27.11.07.44
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 11:07:44 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 14:07:39 -0500
Message-Id: <20220127190742.12776-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 0/3] block/dm: fix bio-based DM IO accounting
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

Just over 3 years ago, with commit a1e1cb72d9649 ("dm: fix redundant
IO accounting for bios that need splitting") I focused too narrowly on
fixing the reported potential for redundant accounting for IO totals.
Which, at least mentally for me, papered over how inaccurate all other
bio-based DM's IO accounting is for bios that get split.

This set fixes things up properly by allowing DM to start IO
accounting _after_ IO is submitted and a split is occurred.  The
proper start_time is still established (prior to submission), it is
passed in to a new __bio_start_io_acct().  This eliminates the need
for any DM hack to rewind block core's excessive accounting in the
face of a split bio recursing back to block core.

All said: If you'd provide your Acked-by(s) I'm happy to send this set
to Linus for v5.17-rc (and shepherd the changes into stable@ kernels).
Or you're welcome to pickup this set to send along (I'd obviously
still do any stable@ backports). NOTE: the 3rd patch references the
linux-dm.git commit id for the 1st patch.. so that'll require tweaking
no matter who sends the changes to Linus.

Please advise, thanks.
Mike

Mike Snitzer (3):
  block: add __bio_start_io_acct() to control start_time
  dm: revert partial fix for redundant bio-based IO accounting
  dm: properly fix redundant bio-based IO accounting

 block/blk-core.c       | 27 ++++++++++++++++++++-------
 drivers/md/dm.c        | 20 +++-----------------
 include/linux/blkdev.h |  1 +
 3 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


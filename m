Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95026C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643385546;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XTePsFOZXNA0I68UesCNTtkiU5MPykZnYt8riSdaQLk=;
	b=iCmQw9xaqz0kh7+rn7uBrmXlbXniKJPPZCiug6WCSTyxX3Njx82hhzt+z1EgIIXqIweeYq
	BjUW2yC/dFu2jZFd0MF9x2X/ydvpFgeirdFkIBjji+RX4tahcL7JE/zx4yiI7jjtVyUQIg
	hvOXWOUafIG1puGYMx60DUE7oEn9+3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-_29N-R3gMAeiYmyFjCU9XA-1; Fri, 28 Jan 2022 10:59:02 -0500
X-MC-Unique: _29N-R3gMAeiYmyFjCU9XA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 194578144EA;
	Fri, 28 Jan 2022 15:58:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E48DA10A48A9;
	Fri, 28 Jan 2022 15:58:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B24244CA9B;
	Fri, 28 Jan 2022 15:58:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SFwmeL026006 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 10:58:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 761812144B25; Fri, 28 Jan 2022 15:58:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7182B2144B24
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40B62108C0E1
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:58:45 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
	[209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-2-YkygBcotN3WzwoZivaY7UA-1; Fri, 28 Jan 2022 10:58:44 -0500
X-MC-Unique: YkygBcotN3WzwoZivaY7UA-1
Received: by mail-qk1-f199.google.com with SMTP id
	d11-20020a37680b000000b0047d87e46f4aso5084950qkc.11
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 07:58:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=4mmE2BDklC4kbyMzrXLJtoHLPinScMnYfFrJMWf1e+U=;
	b=Few5BBUlWG/kKDceGwA+p/n1+tYHvF/30galnR57RbJRynxImOC2su4R80c5SGKU0A
	osOnSvuO9LRcYhAb+2+2/I7hJESHu49TdZQvJowgtZ7MJ+m7aXYOhpIJNOcY7BOAXdSd
	yAie+JVdUx1WxmWoaLNIUwFYJajMcvL2PbSmvjL4FbrIkGRFRpUkL5gX/5wRSw9YmsOm
	hfzQN2LW1mBQkv76IxDBaJ67YoGdCKSNF1rlcQZ/En6hiXMNqlu77Q9ZkcQz1xx/4ZIO
	ZzzysJwdvUqiUTe8rFgo8M00w0YDgA6LUSTvbxrgQARJb2IdyqP+hPc+MixKSOPg/dqE
	0jLA==
X-Gm-Message-State: AOAM532yHvNaAQn3E0fY3WR1ret/+L+OzfoNusUbyyGtkmzRm3v6s3dY
	3p3xGrl7gMJ0MZLz9SDelEehT4pxXnzIPjP35vz6jRTc9bILkLBS71IraApB1iqeJlrfRNZZ8ek
	TkEAJNylXMc6RJw==
X-Received: by 2002:a05:620a:1790:: with SMTP id
	ay16mr6070285qkb.330.1643385523336; 
	Fri, 28 Jan 2022 07:58:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1Sp8T3UlIDPcX8b/jwkTUzeQeOx03Ve8v0cn9k0JmN8doT4Ho3uDIdTRk9+2Xvyywgk7lgA==
X-Received: by 2002:a05:620a:1790:: with SMTP id
	ay16mr6070276qkb.330.1643385523160; 
	Fri, 28 Jan 2022 07:58:43 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o10sm3457427qtx.33.2022.01.28.07.58.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 28 Jan 2022 07:58:42 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri, 28 Jan 2022 10:58:38 -0500
Message-Id: <20220128155841.39644-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v4 0/3] block/dm: fix bio-based DM IO accounting
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[this v4 is final iteration, should be "ready"...]

Hi Jens,

Just over 3 years ago, with commit a1e1cb72d9649 ("dm: fix redundant
IO accounting for bios that need splitting") I focused too narrowly on
fixing the reported potential for redundant accounting for IO totals.
Which, at least mentally for me, papered over how inaccurate all other
bio-based DM's IO accounting is for bios that get split.

This set fixes things up properly by allowing DM to start IO
accounting _after_ IO is submitted and a split may have occurred. The
proper start_time is still established (prior to submission), it is
passed in to a new bio_start_io_acct_time().  This eliminates the need
for any DM hack to rewind block core's accounting that was started
before any potential bio split.

All said: If you'd provide your Acked-by(s) I'm happy to send this set
to Linus for v5.17-rc (and shepherd the changes into stable@ kernels).

Or you're welcome to pickup this set to send along (I'd obviously
still do any stable@ backports). NOTE: the 3rd patch references the
linux-dm.git commit id for the 1st patch.. so that'll require tweaking
no matter who sends the changes to Linus.

Please advise, thanks.
Mike

v4: added Christoph's Reviewed-bys. Removed READ_ONCE from patch 3
v3: fix patch 3 to call bio_start_io_acct_time
v2: made block changes suggested by Christoph

Mike Snitzer (3):
  block: add bio_start_io_acct_time() to control start_time
  dm: revert partial fix for redundant bio-based IO accounting
  dm: properly fix redundant bio-based IO accounting

 block/blk-core.c       | 25 +++++++++++++++++++------
 drivers/md/dm.c        | 20 +++-----------------
 include/linux/blkdev.h |  1 +
 3 files changed, 23 insertions(+), 23 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


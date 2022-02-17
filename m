Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7100DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 02:40:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-6uEiubi8N5uyXVfKp8qw0g-1; Wed, 16 Feb 2022 21:40:40 -0500
X-MC-Unique: 6uEiubi8N5uyXVfKp8qw0g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 184EB814246;
	Thu, 17 Feb 2022 02:40:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 848EB101F6CA;
	Thu, 17 Feb 2022 02:40:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A3841809CB8;
	Thu, 17 Feb 2022 02:40:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21H2eS3E017944 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 21:40:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F6F62024CB7; Thu, 17 Feb 2022 02:40:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99BA12024CAE
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 02:40:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EABA3C23385
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 02:40:25 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
	[209.85.215.180]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-272-kA5otZS5OcKDQ-Kuy_8YFA-1; Wed, 16 Feb 2022 21:40:23 -0500
X-MC-Unique: kA5otZS5OcKDQ-Kuy_8YFA-1
Received: by mail-pg1-f180.google.com with SMTP id r76so3749504pgr.10
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 18:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
	:message-id:date:mime-version:content-transfer-encoding;
	bh=oODu74s9GE4pl/LcFCnseaYhJWRPo2lHWvLkc0TctgM=;
	b=1ZYYCuxREFM98LdmbKpEzLYbV8wqp2ZQUfKdZyfVbRw4qsdkf4yMvhaG3d4Z0+6Wcm
	0ynRCOQTRxI/h2Tye7gEh3ETUqBrfQ26ClmswUmrEjJVS2i4sWPm971Cu94S8YymEdQE
	s9au0xVtCXKOMDg+V8Y2Fqrh0qbp0bMvI1bQUdvyvUpt4noNXNvoyxyoUQUVrllyDzuD
	x/9peRtClSxh8WTqYCuyXpKCyC9oM/xopaMU0RdC6a1Qy3ZsjPP6+hn4eY22v3S0Ns2H
	YVp8n3yv9NgFUVPiLC0lCy91pOMPNUoGa663znNugbcHalAa3lt8s4jVjR6z3xDki+Vl
	x1HQ==
X-Gm-Message-State: AOAM533egZSnitZuhq1qhwf5bfYicg0ncXUzNGdXLJagf+pFeS39n0Aq
	e2BBwGhuLMS+iUEuZaMWTS/olRpKs7FuIQ==
X-Google-Smtp-Source: ABdhPJzPZybSL83JbFQ7Ko+3wR4VK2ajkjH42fnPCHnO7hdrLt590zqAdba2ygW+GoAliSG2gPoiZw==
X-Received: by 2002:a63:451e:0:b0:373:6a1d:2ad9 with SMTP id
	s30-20020a63451e000000b003736a1d2ad9mr797469pga.114.1645065622451;
	Wed, 16 Feb 2022 18:40:22 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
	by smtp.gmail.com with ESMTPSA id a17sm366645pju.15.2022.02.16.18.40.21
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Feb 2022 18:40:22 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20220215100540.3892965-1-hch@lst.de>
References: <20220215100540.3892965-1-hch@lst.de>
Message-Id: <164506562143.46255.14806921752720866775.b4-ty@kernel.dk>
Date: Wed, 16 Feb 2022 19:40:21 -0700
MIME-Version: 1.0
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] make the blk-mq stacking interface optional
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 15 Feb 2022 11:05:35 +0100, Christoph Hellwig wrote:
> this series requires an explicit select to use the blk-mq stacking
> interfaces.  This means they don't get build without dm support, and
> thus the buildbot should catch abuses like the one we had in the ufs
> driver more easily.  And while I touched this code I also ended up
> cleaning up various loose ends.
> 
> Diffstat:
>  block/Kconfig          |    3 +++
>  block/blk-mq.c         |   45 +++++++++------------------------------------
>  drivers/md/Kconfig     |    1 +
>  drivers/md/dm-rq.c     |   26 +++++++++-----------------
>  include/linux/blk-mq.h |    3 +--
>  5 files changed, 23 insertions(+), 55 deletions(-)
> 
> [...]

Applied, thanks!

[1/5] blk-mq: make the blk-mq stacking code optional
      (no commit info)
[2/5] blk-mq: fold blk_cloned_rq_check_limits into blk_insert_cloned_request
      (no commit info)
[3/5] blk-mq: remove the request_queue argument to blk_insert_cloned_request
      (no commit info)
[4/5] dm: remove useless code from dm_dispatch_clone_request
      (no commit info)
[5/5] dm: remove dm_dispatch_clone_request
      (no commit info)

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


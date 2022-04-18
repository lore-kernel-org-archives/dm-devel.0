Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E8B7C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 12:51:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-XIeQw4uZMi2eIsxLVQNRlQ-1; Mon, 18 Apr 2022 08:51:35 -0400
X-MC-Unique: XIeQw4uZMi2eIsxLVQNRlQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D3A101AA47;
	Mon, 18 Apr 2022 12:51:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E00A5145F942;
	Mon, 18 Apr 2022 12:51:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 92ACC1947BBB;
	Mon, 18 Apr 2022 12:51:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0722F19451F1
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 12:51:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7C76416362; Mon, 18 Apr 2022 12:51:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3D5F403375
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 12:51:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C996D101AA44
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 12:51:32 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-9JWuPvqoPki1t4mued4dsQ-1; Mon, 18 Apr 2022 08:51:31 -0400
X-MC-Unique: 9JWuPvqoPki1t4mued4dsQ-1
Received: by mail-pj1-f48.google.com with SMTP id
 o5-20020a17090ad20500b001ca8a1dc47aso17201798pju.1
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 05:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=V5PPFfMIzwWQAfLKN2M6veOqiwFTONaVa2X6RpGYlTQ=;
 b=HEd5FgzOVJbpXq1hqDE141RvUeJRr4BV4dRmjlhHt1fAXOEKqbRrmc82l0jep2HfT/
 Q6nyhgBB1g4THTsJEqBWaGa0N7viVtCH1KfueYaCHQckUv24IlnxsaxokvrCqM1wqv9P
 yhYbkxsnEDrQQkHowKycgRuKijogEPWdsd3rmvFiI2evJEqE04E0uLE4f/sC6UThFN0m
 lRWpAUF8w9G+6dUiEO7nmniPVmo5WRQ6kPocnnTONxD+41cYXt1nyRb+yFtnd9ftbFOL
 u7Gc3MdQ3zAKCN4lfJmSNM+nHkrbQltdEvcnZNXzyqCGhEMmce27kPvE8Qa0ruiXhJUK
 dnSA==
X-Gm-Message-State: AOAM533/T2mUDBqX6VMk7ypl80IyxoHtMiZ8vG0wwPM8FR/Rpl0X+fks
 rme4pPUmJ6BOO3wBsmQ3pxz+n36Wzo4iS3FG
X-Google-Smtp-Source: ABdhPJzSkLEK8HYte1nSjsoBQspbza1F5/S23owTrFkaJZ261rlTY168aZ1FVEJ/8q3d5vRP/gT38g==
X-Received: by 2002:a17:90a:2e0d:b0:1c9:b839:af02 with SMTP id
 q13-20020a17090a2e0d00b001c9b839af02mr17928615pjd.122.1650286289939; 
 Mon, 18 Apr 2022 05:51:29 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 l8-20020a17090a150800b001cbaf536a3esm17201170pja.18.2022.04.18.05.51.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Apr 2022 05:51:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: snitzer@kernel.org, dm-devel@redhat.com
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
Message-Id: <165028628918.14511.6166643889093812699.b4-ty@kernel.dk>
Date: Mon, 18 Apr 2022 06:51:29 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] (subset) [dm-5.19 PATCH 00/21] dm: changes staged
 for 5.19
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Christoph Hellwig <hch@lst.de>, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, 17 Apr 2022 22:27:12 -0400, Mike Snitzer wrote:
> This patchset reflects what I've staged in linux-dm.git's "dm-5.19"
> branch (also staged in "for-next" for linux-next):
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19
> 
> It build's on jens/for-5.19/block branch (which is based on v5.18-rc3)
> 
> I can still make changes or add Reviewed-by:s, etc. So please feel
> free to review.
> 
> [...]

Applied, thanks!

[01/21] block: change exported IO accounting interface from gendisk to bdev
        commit: 5f0614a55ecebdf55f1a17db0b5f6b787ed009f1

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


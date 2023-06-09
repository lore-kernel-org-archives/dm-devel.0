Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4FCC7EE23
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 03:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686281596;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9FeHcFSpHbgMe9pQjzIuSQ3VGX6CjVL3VxqTiW202ls=;
	b=DDRSrwCLysCsnspbqp6d6rZFJ0RnqQkWDFwlOnPxubvZeIzFo0YqpDjLZcs9wYkkyzt6qM
	d8bSiD5ttdaeIRBvWh3U+SwK28DcG0JlJlDQnWBwNQ1ZzZpg4Lb9sEA/MsNDZCe3hv5bbT
	P/TpLMoJBoCoRIXgFN3R60G4Yyb3TQQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-KKd--HwoMoC26mXqSqPtZA-1; Thu, 08 Jun 2023 23:33:13 -0400
X-MC-Unique: KKd--HwoMoC26mXqSqPtZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3DD22999B38;
	Fri,  9 Jun 2023 03:33:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB589140E956;
	Fri,  9 Jun 2023 03:33:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A09ED19451C0;
	Fri,  9 Jun 2023 03:33:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5B3E194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 03:33:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92B5E40D1B68; Fri,  9 Jun 2023 03:33:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B58540D1B66
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 03:33:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 701B2101A52C
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 03:33:03 +0000 (UTC)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-Zq30qN1xOdSiZw_7Adg07g-1; Thu, 08 Jun 2023 23:33:01 -0400
X-MC-Unique: Zq30qN1xOdSiZw_7Adg07g-1
Received: by mail-ot1-f47.google.com with SMTP id
 46e09a7af769-6b2bdca0884so303393a34.2
 for <dm-devel@redhat.com>; Thu, 08 Jun 2023 20:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686281580; x=1688873580;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6iwigF78U3EwOQGn53e2UyWPNzHupFHtA26oaO3R2wc=;
 b=TzG4TvykoYqA+OfrI0Vo7O533qtoxv2US1ci8/K4CDdNMF4eb8o4bSDRSFUYgVWq70
 9G/RWK/8r/GcrNEfHboZmE6zk0m34yRVZyYB2wzEs0oCUNdhiq9jKGDSvTJifEAVMb7c
 NtTk+zMq0f2QOn2oJbFYCyNIJYoaOzMq/tgeZCv6EeZXCRySOi9X7lwJxS05p7/B9XPb
 8kOLAD9vUVudjndNLr8r73CHCRN4Y+96PlPt4YnzUIBhk5ZLO5Tr8Jh1rvN9D7YRiz+U
 Pmgk4phmqJ2DHIQY/2DlKDdhEMOiuDzjX73DvHyBr6Qj528nGaocDZ6kLwjulqn0c06K
 qM4g==
X-Gm-Message-State: AC+VfDwQB5/iJBkf2xn1sU/JyKo8sph8mcCD/a4tJ340IpTtJfe/O9a1
 VdnOEN9ykk2kFliQq33a/X+48Q==
X-Google-Smtp-Source: ACHHUZ4jpAKkv/P4I5GyogL5cyKUBbH9jdQo3rd8sW4sBbrGIyPOxPKXrqwUV/kK78Vqo7hkyQEMOA==
X-Received: by 2002:a05:6830:3a0a:b0:6a6:6121:dc60 with SMTP id
 di10-20020a0568303a0a00b006a66121dc60mr317885otb.10.1686281580410; 
 Thu, 08 Jun 2023 20:33:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au.
 [49.179.79.151]) by smtp.gmail.com with ESMTPSA id
 t1-20020aa79381000000b0064381853bfcsm1723703pfe.89.2023.06.08.20.32.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Jun 2023 20:32:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q7Srw-009XUr-2X;
 Fri, 09 Jun 2023 13:32:56 +1000
Date: Fri, 9 Jun 2023 13:32:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <ZIKdaJNhSq9JfFDU@dread.disaster.area>
References: <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area>
 <ZHti/MLnX5xGw9b7@redhat.com>
 <ZH/k9ss2Cg9HYrEV@dread.disaster.area>
 <ZIEXwTd17z0iYW4s@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZIEXwTd17z0iYW4s@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Joe Thornber <thornber@redhat.com>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, dm-devel@redhat.com,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Joe Thornber <ejt@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 07, 2023 at 07:50:25PM -0400, Mike Snitzer wrote:
> Do you think you're OK to scope out, and/or implement, the XFS changes
> if you use v7 of this patchset as the starting point? (v8 should just
> be v7 minus the dm-thin.c and dm-snap.c changes).  The thinp
> support in v7 will work enough to allow XFS to issue REQ_OP_PROVISION
> and/or fallocate (via mkfs.xfs) to dm-thin devices.

Yup, XFS only needs blkdev_issue_provision() and
bdev_max_provision_sectors() to be present.  filesystem code. The
initial XFS provisioning detection and fallocate() support is just
under 50 lines of new code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


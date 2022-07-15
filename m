Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10270CCA47C
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657895167;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6vJYpjxq1zG0qKZQubpMBaqcO+l/6bG0795w4zf3jbs=;
	b=HX/ltKX11TLa+AyslKsAVmQIQZe2IRxuAHDV3hmj+GaZXqwFrUH6WU4ieVvtBFXjqY+N8A
	lWiU7KQ331iUYSCbOqHRedo1jiqHv4skKS1trEkm4n/zSD36GJqLMFnuQ4Ql4WoQj6CDbf
	RyvzSsW5WBfZiBXZV3YhQbjv0Zp1e2k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-EY3PVBkIOvylyqP_oGVTfQ-1; Fri, 15 Jul 2022 10:26:04 -0400
X-MC-Unique: EY3PVBkIOvylyqP_oGVTfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DB7A18E6C44;
	Fri, 15 Jul 2022 14:26:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55CF4140EBE3;
	Fri, 15 Jul 2022 14:26:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0ECF21947052;
	Fri, 15 Jul 2022 14:26:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE2FF1947041
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 14:25:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BDC23141511D; Fri, 15 Jul 2022 14:25:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9CDA140EBE3
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 14:25:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A24E51019C89
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 14:25:58 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-fRfkbFy5MfKB9K2qJDCh8A-1; Fri, 15 Jul 2022 10:25:51 -0400
X-MC-Unique: fRfkbFy5MfKB9K2qJDCh8A-1
Received: by mail-qt1-f181.google.com with SMTP id c20so3825499qtw.8
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 07:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HKodF5hKMkQVTCPo18xzZDboTSgZXMA4aBpvsz56Xr4=;
 b=e0DBBF8ym8kBMQCCzUqe4yoZTqywtMUGecoiizW+95MBtPxzxZbc7308S+q1vt2YRc
 TBdzDyH1r26dTR2fNwdSQY6ujeelTHc4BMBxay3xS5CpvC78DMJI7vuKLOANJjUwQnFP
 V7IhgT+xzL14V/StPBUsuKTfBtafmnIr70P52CI5yR4A86tLT2mNbMNjKLQv13kifEZR
 nOSV2GdBhGeDKjBrVSulrKCXIV4Wq8bJ7h27e3XnLU01kH/BJpBJ8Rj+bgUpxu1FU7Lf
 dWWvAcyQEMpiqQqUYcJJpfDg0K0HGp3+zIUVO8i5mmSAefXf+XEUfrpxIJC3jIt/LLqy
 zbeA==
X-Gm-Message-State: AJIora9stVitsPVXl6rMAWPoOJcjGA1M6S4vd3SxVPrM3+OvFPYAUU/p
 7SSWcwYUHkHENJxWNSZh8toCs9ZiCnlUheI=
X-Google-Smtp-Source: AGRyM1sVVoMppSD1ocyzwKtQXcnIWDSk18aExmZQaRiE0J5jWwRNJ+ZXqtgVa2fRR4fjKSHUF9hhgA==
X-Received: by 2002:ac8:5807:0:b0:31e:bc4f:61c4 with SMTP id
 g7-20020ac85807000000b0031ebc4f61c4mr12563359qtg.46.1657895144439; 
 Fri, 15 Jul 2022 07:25:44 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 g2-20020a05620a40c200b006b5bbf0cad3sm4356474qko.59.2022.07.15.07.25.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Jul 2022 07:25:43 -0700 (PDT)
Date: Fri, 15 Jul 2022 10:25:42 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <YtF45oMcHMKXjIyy@redhat.com>
References: <e3ac2722-01c4-decb-2b79-bfd1b6c2b782@I-love.SAKURA.ne.jp>
 <a41b962e-8423-75b5-ef89-74e8b9f25259@I-love.SAKURA.ne.jp>
 <6deb326e-0b0e-84f5-5d1e-2f321d5816ca@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
In-Reply-To: <6deb326e-0b0e-84f5-5d1e-2f321d5816ca@I-love.SAKURA.ne.jp>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] dm: Avoid flush_scheduled_work() usage
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I'm not applying such a fundamental change to the DM subsystem when
the header for the change leads with: "Note: This patch was made
blindly and completely untested."

I've been busy... when is the deadline for this conversion?  I read
commit c4f135d643823a86 but it doesn't say.

I don't think I have the time to make and test such change in time for
5.20 as I'm working to resolve other issues.

Mike


On Fri, Jul 15 2022 at  9:27P -0400,
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Ping?
> 
> On 2022/06/13 18:52, Tetsuo Handa wrote:
> > Please see commit c4f135d643823a86 ("workqueue: Wrap flush_workqueue()
> > using a macro") for background.
> > 
> > What should we do for this module?
> > 
> > On 2022/04/20 14:12, Tetsuo Handa wrote:
> >> Flushing system-wide workqueues is dangerous and will be forbidden.
> >> Remove flush_scheduled_work() from local_init() in dm.c and instead
> >> use local workqueue to dm-mpath.c, dm-raid1.c, dm-stripe.c.
> >>
> >> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
> >> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> >> ---
> >> Note: This patch was made blindly and completely untested. Maybe simply
> >> removing flush_scheduled_work() from local_init() is sufficient. But I
> >> don't know dependency across all files. Therefore, please carefully check
> >> which schedule_work() needs to be converted to queue_work().
> >>
> >> As far as I can see, dm-stripe.c which contains dm_stripe_exit() which is
> >> called via _exits[] before local_exit() calls flush_scheduled_work() is
> >> the only file which calls schedule_work(). Therefore, I used dm_stripe_wq
> >> for dm-stripe.c.
> >>
> >> Since I don't know dependency, and dm-raid1.c and dm-mpath.c are also calling
> >> schedule_work(), I used dm_raid1_wq and dm_mpath_wq. But these changes might be
> >> unnecessary because of not calling flush_scheduled_work().
> >>
> >>  drivers/md/dm-mpath.c  | 17 +++++++++++++----
> >>  drivers/md/dm-raid1.c  | 14 +++++++++++---
> >>  drivers/md/dm-stripe.c | 12 ++++++++++--
> >>  drivers/md/dm.c        |  1 -
> >>  4 files changed, 34 insertions(+), 10 deletions(-)
> >>
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


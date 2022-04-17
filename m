Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E449C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 17 Apr 2022 01:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650158635;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d+0xZYTZ7zQsDcWnrF/2COJiu8jcKitUQ+KdBIBtiTM=;
	b=U+YRa2qgCvHMmdfhTR+ryj3yw+D7ewTV3GlVl2BTVMXL0VLaCzZVe2CLAZ+58uZMpjfrbI
	+4Z7damaBLxWMjwn0cJdCrC/RpYO8AI/fvSqzTMbUPU5LA3LalB4VIY1S9iLWclz3Iu1sd
	egYhizfSid/xtWdPlJHPaw4bT9cDJs4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-Zl0wcfaFMPm9-9SRrZG2KA-1; Sat, 16 Apr 2022 21:23:51 -0400
X-MC-Unique: Zl0wcfaFMPm9-9SRrZG2KA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2048D80159B;
	Sun, 17 Apr 2022 01:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07E5E111F3B6;
	Sun, 17 Apr 2022 01:23:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A84BD19451F1;
	Sun, 17 Apr 2022 01:23:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 086D819466DF
 for <dm-devel@listman.corp.redhat.com>; Sun, 17 Apr 2022 01:23:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EAFC0C44CEB; Sun, 17 Apr 2022 01:23:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E79C4C44CE8
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 01:23:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE5FF851784
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 01:23:45 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-vb2MLUShMWiX22Yne2obmw-1; Sat, 16 Apr 2022 21:23:44 -0400
X-MC-Unique: vb2MLUShMWiX22Yne2obmw-1
Received: by mail-qk1-f198.google.com with SMTP id
 h8-20020a05620a244800b00699fb28d5e4so7883578qkn.22
 for <dm-devel@redhat.com>; Sat, 16 Apr 2022 18:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=z781wwa86GLbmKos8zoVf/9OVyjd0hUDM1gXB0rozMo=;
 b=Sg+mF5EMiQU06D4BoA2vkXDL1VHBGllyG60Ietko6OvwInwjkVIydVSr9jlPbvTqpg
 SH7r1/UeVyNuEnQ9jZpxHey95TzQxFK/BJJlxBE1mO7as7yD6LPPUW9Zxw4qXHGWDpvi
 vC04Rl/+CdSfd8dk/mBY6PWq9cWpHzswH5Y1mZrEQdHoZ2ypgkBzz9Rd4/mXZF2KAnsi
 hJ4XSqrKuZWLIVoeljuzGmvHV51qqghRFw0N14cxEwZtgUFDdNX4p0QV4fFJQzNZwVBK
 nOQzK5yv9L4wpfEokFeXZYuIm0uqLMhoq/koNmgKmBrqOf4lKZKg7LtMeW0tYbPEs8Di
 c4Cg==
X-Gm-Message-State: AOAM533WfvmAfLJnFr5JRqLlO1GioJcgF17a19TjCKl9dK6y0HpROS1W
 6TfGW99CoPUX+6JtNIWUpZU47AOfe5JHKaSvnMVk3DRpfK1iyTMWX7sDfQ1KO/tRjoWB0Iu63i+
 A3/slqLaJ3r5x0w==
X-Received: by 2002:a37:a8c3:0:b0:69e:5f25:3e60 with SMTP id
 r186-20020a37a8c3000000b0069e5f253e60mr3271079qke.58.1650158624171; 
 Sat, 16 Apr 2022 18:23:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOQPbh4MUU/ec5E4VsecUK//kjDs1uWZh8pE6kTcSF5wGD/nyzJOW0hcWXcCR0DeC0WTSFZQ==
X-Received: by 2002:a37:a8c3:0:b0:69e:5f25:3e60 with SMTP id
 r186-20020a37a8c3000000b0069e5f253e60mr3271072qke.58.1650158623960; 
 Sat, 16 Apr 2022 18:23:43 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 c20-20020a05622a025400b002e1dd71e797sm5648762qtx.15.2022.04.16.18.23.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 16 Apr 2022 18:23:43 -0700 (PDT)
Date: Sat, 16 Apr 2022 21:23:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YltsHc7lrGMzEEy1@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <YlWzoj+M1ykUubH+@redhat.com> <YlpbGbtc5NwD64KH@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YlpbGbtc5NwD64KH@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 0/8] dm: io accounting & polling improvement
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
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 16 2022 at  1:58P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Apr 12, 2022 at 01:15:14PM -0400, Mike Snitzer wrote:
> > I'll review this closely but, a couple weeks ago, I queued up quite a
> > lot of conflicting changes for 5.19 here:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19
> 
> Can you please end them out to the device mapper list for review?

Yes, no problem. I brought my various earlier changes to the front,
dropped my changes for removing dm_io refcounting for normal r/w IO
(still visible in 'dm-5.19-v1'), and rebased Ming's series (now
visible in 'dm-5.19-v2').

Common: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19
Old: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19-v1
New: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19-v2

I'll clean up the 'dm-5.19-v2' series further and likely post to the
list on Tuesday.

I discussed with Jens and we'll both be rebasing our 5.19 trees to
v5.18-rc3. dm will be rebasing on block (I can fix up Ming's patch for
bdev_{start,end}_io_acct based on your review and Jens can then pick
it up from the first patch in the series I post).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


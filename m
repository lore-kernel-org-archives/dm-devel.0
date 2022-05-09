Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809CEC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652125747;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ALwxyRwt1I+/luFlgIeHbEIR2ClbYOK+dfmKiaouLu0=;
	b=TdzMU6zRvATlcFrmB9qoRcVR61q+2DWQxcvw6zpUjYC1Jkh5HAffhfXoqSwN9zcaQA0KS+
	FbDdbut/Do4XMTFzp68AxeefJp6c1kqtQk89J6WgHuXA4/iNHo7wMBJ9l7WxTTcjCFIZHH
	fwYYzawOjH0Jx7D1puHU/WWz1fIb2Os=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-sUmC4uNWNFS7ONet2p8Odw-1; Mon, 09 May 2022 15:49:06 -0400
X-MC-Unique: sUmC4uNWNFS7ONet2p8Odw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A309C185A7B2;
	Mon,  9 May 2022 19:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90B3D2166B2F;
	Mon,  9 May 2022 19:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C6A51947052;
	Mon,  9 May 2022 19:49:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 960BA1947051
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 19:49:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 73C4815088C0; Mon,  9 May 2022 19:49:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FB4C15063FF
 for <dm-devel@redhat.com>; Mon,  9 May 2022 19:49:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 572BB805F46
 for <dm-devel@redhat.com>; Mon,  9 May 2022 19:49:02 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-d_w2U6m7OvG8czbH2uJn5w-1; Mon, 09 May 2022 15:49:01 -0400
X-MC-Unique: d_w2U6m7OvG8czbH2uJn5w-1
Received: by mail-qk1-f199.google.com with SMTP id
 p129-20020a37a687000000b0069fc31a594bso9332429qke.4
 for <dm-devel@redhat.com>; Mon, 09 May 2022 12:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fjdCbV/T3nnZewrHuQYMn98COxNxvNVpnje5UNOk5dM=;
 b=H1nhOB1m0rLiuDxRA/+zDpZJ/8Z5eTh1VlO4GbqbCUAc2lV+Ks7dfxirh3weGk7DT0
 uVFGEreHr3lmS3tt/DLJZ7CsbDDtuE4EGHGFCbM3kVfet43bMDTXy17phBs7hjgI9I+6
 pelHsASn743YG7GM7wGOlFHk50GKgaqomjoOBg/ccXHxryk9coumPXQ19W0+O6cnMshr
 JfdLOUuPNz4VwUq5zO6fJVmLUc4+dwREJiciQWRMGQjOsBY/rXOOnLmcc+Us0tT6bZOc
 ETdVDTVqoi3P4kMIuwKEa5zdDsChldpkHfVbn5R2+qF6bnqUqjrzMW3sMG3ictEmzvJR
 LyGw==
X-Gm-Message-State: AOAM531/fUqSVuYgvxeq9Nc49jECbSrMsjXD67m8NtBLIJcVMqkn5S1x
 0zvKPXPwVlzSm/dnOIFqCTsh82ZW3PT0/ZuYqhS29UVTEBZThEqI9fddzL9qGbiO+5MbMGTQITv
 asc2iokPk64eTow==
X-Received: by 2002:ac8:578c:0:b0:2f3:a7b7:878f with SMTP id
 v12-20020ac8578c000000b002f3a7b7878fmr16894855qta.186.1652125740578; 
 Mon, 09 May 2022 12:49:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUWBe94w4/zRChfAF0vUg+SJ2OVtIJbFyi0CL0zR2jMzq5OCieAgdAThKKbxfofY0ac0oQXg==
X-Received: by 2002:ac8:578c:0:b0:2f3:a7b7:878f with SMTP id
 v12-20020ac8578c000000b002f3a7b7878fmr16894840qta.186.1652125740363; 
 Mon, 09 May 2022 12:49:00 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 5-20020a05620a070500b0069fc13ce1f3sm7566643qkc.36.2022.05.09.12.48.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 12:48:59 -0700 (PDT)
Date: Mon, 9 May 2022 15:48:58 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Message-ID: <YnlwKjirviHlRDHi@redhat.com>
References: <20220427165710.225808-1-krisman@collabora.com>
 <Ynlv6lyV1OgZe6h5@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Ynlv6lyV1OgZe6h5@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] dm: dm-mpath: Provide high-resolution timer to HST
 with bio-mpath
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
Cc: dm-devel@redhat.com, kernel@collabora.com, khazhy@google.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 09 2022 at  3:47P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Apr 27 2022 at 12:57P -0400,
> Gabriel Krisman Bertazi <krisman@collabora.com> wrote:
> 
> > The precision loss of reading IO start_time with jiffies_to_nsecs
> > instead of using a high resolution timer degrades HST path prediction
> > for BIO-based mpath on high load workloads.
> > 
> > Below, I show the utilization percentage of a 10 disk multipath with
> > asymmetrical disk access cost, while being exercised by a randwrite FIO
> > benchmark with high submission queue depth (depth=64).  It is possible
> > to see that the HST path selection degrades heavily for high-iops in
> > BIO-mpath, underutilizing the slower paths way beyond expected.  This
> > seems to be caused by the start_time truncation, which makes some IO to
> > seem much slower than they actually is.  In this scenario ST outperforms
> > HST for bio-mpath, but not for mq-mpath, which already uses ktime_get_ns().
> > 
> > The third column shows utilization with this patch applied.  It is easy
> > to see that now HST prediction is much closer to the ideal distribution
> > (calculated considering the real cost of each path).
> > 
> > |     |   ST | HST (orig) | HST(ktime) | Best |
> > | sdd | 0.17 |       0.20 |       0.17 | 0.18 |
> > | sde | 0.17 |       0.20 |       0.17 | 0.18 |
> > | sdf | 0.17 |       0.20 |       0.17 | 0.18 |
> > | sdg | 0.06 |       0.00 |       0.06 | 0.04 |
> > | sdh | 0.03 |       0.00 |       0.03 | 0.02 |
> > | sdi | 0.03 |       0.00 |       0.03 | 0.02 |
> > | sdj | 0.02 |       0.00 |       0.01 | 0.01 |
> > | sdk | 0.02 |       0.00 |       0.01 | 0.01 |
> > | sdl | 0.17 |       0.20 |       0.17 | 0.18 |
> > | sdm | 0.17 |       0.20 |       0.17 | 0.18 |
> > 
> > This issue was originally discussed [1] when we first merged HST, and
> > this patch was left as a low hanging fruit to be solved later.  I don't
> > think anyone is using HST with BIO mpath, but it'd be neat to get it
> > sorted out.
> > 
> > Regarding the implementation, as suggested by Mike in that mail thread,
> > in order to avoid the overhead of ktime_get_ns for other selectors, this
> > patch adds a flag for the selector code to request the high-resolution
> > timer.
> > 
> > I tested this using the same benchmark used in the original HST submission.
> > 
> > Full test and benchmark scripts are available here:
> > 
> >   https://people.collabora.com/~krisman/HST-BIO-MPATH/
> > 
> > [1] https://lore.kernel.org/lkml/85tv0am9de.fsf@collabora.com/T/
> > 
> > Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> > Acked-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> 
> Overall your code was OK, but I nudged it a bit further to be
> inkeeping with how 'features' flags have been implemented elsewhere
> (e.g. dm_target_type's features) -- by using a healer to test the
> flag, etc.

s/healer/helper/ ;)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


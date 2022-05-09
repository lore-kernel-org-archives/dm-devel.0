Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6AFC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 19:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652125694;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V5CbqEpeU5i2c7MZg6x2CYtPK6vR7XykiMa6fxwUwyg=;
	b=KpG2BUm4kOlmenYjETX07uS8Pxo7Y/giprPmvMo0/CXE4AD1mr2baZlz9fF3VCp4K7DE6k
	vMN1iQfOMtMWsCcrKpkLWUNQsqBEIdj07NKHSWTziOays3bnBytOoLgWdetnvbIFUiQzDh
	5/d9dXcRMpN1OI+yBiMTv1U1/6ViUwA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-FHi1stTAMVuMM2L5hp8djA-1; Mon, 09 May 2022 15:48:12 -0400
X-MC-Unique: FHi1stTAMVuMM2L5hp8djA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3F7F3C0219F;
	Mon,  9 May 2022 19:48:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5730454E895;
	Mon,  9 May 2022 19:48:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E2E81947052;
	Mon,  9 May 2022 19:48:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DBEA1947051
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 19:48:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3A8CB2166B4B; Mon,  9 May 2022 19:48:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3667B2166B2F
 for <dm-devel@redhat.com>; Mon,  9 May 2022 19:47:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C41829AB40D
 for <dm-devel@redhat.com>; Mon,  9 May 2022 19:47:59 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-1Y4AATZ6MyatHUOw1MdTyw-1; Mon, 09 May 2022 15:47:57 -0400
X-MC-Unique: 1Y4AATZ6MyatHUOw1MdTyw-1
Received: by mail-qv1-f72.google.com with SMTP id
 e3-20020a056214110300b0045abb0e1760so12217815qvs.3
 for <dm-devel@redhat.com>; Mon, 09 May 2022 12:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qq3Em0Qke0Zo628kUwMh2zsDPLWxSg49r3FNvHja0tI=;
 b=nAhC5txDJ9Q4QEaXqZh0M1VXOqvkJwyFvW07OpVrKSTDsEgI1x/R9b9C/PsHtlZNXS
 NCRSUhrd+JRny8Mf2fsdT3DNLiEERkwexPqecy6+K+t9Ft28/QSWYIgq22R62e/AnCKe
 DVmhvZDbbZ5nk0oOw9vn/uymA3NSnXwFsVVRvfdQZ5sor13eMHTmBrQMt8yDzjmbR2sK
 MhZ2+IolIDTJVedn+EfxOD44FcsujYogmFMnl3JkuMHtLgJ3EWPzHovxcE1X+bpwKql0
 6ksrzy6XDkqdr6XVqe/I4AcBlDACv7h92Jko841X2i4wNagYWCXlSj9C2+XeVIBF+vcx
 AAEA==
X-Gm-Message-State: AOAM532/pbu/F4Xc2ZJSwK3lc4XYUXfUFiJrBRES7QcGjtvBfZPsfrla
 a5pra+cGBWtl3qopnsSd58PPkQYKgiD6Lp5/1IOdtPoER3UK9ZvZ5Jkwa+BlTmooZlECHejzKnX
 7zgPsF5aV+Gs4FQ==
X-Received: by 2002:a05:622a:81:b0:2f3:c0d8:d630 with SMTP id
 o1-20020a05622a008100b002f3c0d8d630mr16508111qtw.599.1652125676304; 
 Mon, 09 May 2022 12:47:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6D4vHASBVGw4zYVckV32ZCfZ7YQgSD67tubaI05ClknGqR1n0tI/o2Y5VpdIgsNYL6yMs2Q==
X-Received: by 2002:a05:622a:81:b0:2f3:c0d8:d630 with SMTP id
 o1-20020a05622a008100b002f3c0d8d630mr16508089qtw.599.1652125676076; 
 Mon, 09 May 2022 12:47:56 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 g4-20020ac81244000000b002f3b561957asm8408920qtj.13.2022.05.09.12.47.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 12:47:55 -0700 (PDT)
Date: Mon, 9 May 2022 15:47:54 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Message-ID: <Ynlv6lyV1OgZe6h5@redhat.com>
References: <20220427165710.225808-1-krisman@collabora.com>
MIME-Version: 1.0
In-Reply-To: <20220427165710.225808-1-krisman@collabora.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 27 2022 at 12:57P -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> The precision loss of reading IO start_time with jiffies_to_nsecs
> instead of using a high resolution timer degrades HST path prediction
> for BIO-based mpath on high load workloads.
> 
> Below, I show the utilization percentage of a 10 disk multipath with
> asymmetrical disk access cost, while being exercised by a randwrite FIO
> benchmark with high submission queue depth (depth=64).  It is possible
> to see that the HST path selection degrades heavily for high-iops in
> BIO-mpath, underutilizing the slower paths way beyond expected.  This
> seems to be caused by the start_time truncation, which makes some IO to
> seem much slower than they actually is.  In this scenario ST outperforms
> HST for bio-mpath, but not for mq-mpath, which already uses ktime_get_ns().
> 
> The third column shows utilization with this patch applied.  It is easy
> to see that now HST prediction is much closer to the ideal distribution
> (calculated considering the real cost of each path).
> 
> |     |   ST | HST (orig) | HST(ktime) | Best |
> | sdd | 0.17 |       0.20 |       0.17 | 0.18 |
> | sde | 0.17 |       0.20 |       0.17 | 0.18 |
> | sdf | 0.17 |       0.20 |       0.17 | 0.18 |
> | sdg | 0.06 |       0.00 |       0.06 | 0.04 |
> | sdh | 0.03 |       0.00 |       0.03 | 0.02 |
> | sdi | 0.03 |       0.00 |       0.03 | 0.02 |
> | sdj | 0.02 |       0.00 |       0.01 | 0.01 |
> | sdk | 0.02 |       0.00 |       0.01 | 0.01 |
> | sdl | 0.17 |       0.20 |       0.17 | 0.18 |
> | sdm | 0.17 |       0.20 |       0.17 | 0.18 |
> 
> This issue was originally discussed [1] when we first merged HST, and
> this patch was left as a low hanging fruit to be solved later.  I don't
> think anyone is using HST with BIO mpath, but it'd be neat to get it
> sorted out.
> 
> Regarding the implementation, as suggested by Mike in that mail thread,
> in order to avoid the overhead of ktime_get_ns for other selectors, this
> patch adds a flag for the selector code to request the high-resolution
> timer.
> 
> I tested this using the same benchmark used in the original HST submission.
> 
> Full test and benchmark scripts are available here:
> 
>   https://people.collabora.com/~krisman/HST-BIO-MPATH/
> 
> [1] https://lore.kernel.org/lkml/85tv0am9de.fsf@collabora.com/T/
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Acked-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Overall your code was OK, but I nudged it a bit further to be
inkeeping with how 'features' flags have been implemented elsewhere
(e.g. dm_target_type's features) -- by using a healer to test the
flag, etc.

I also tweaked some other small implementation details.  Please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=c06dfd124d46df9c482fbd1319b5fe19bcb1a110

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


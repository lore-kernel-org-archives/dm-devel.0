Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EEEC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:34:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3421D2225E
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3421D2225E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-pR6Yu3AXP6qlGLhlFYjUSg-1; Fri, 11 Dec 2020 11:34:07 -0500
X-MC-Unique: pR6Yu3AXP6qlGLhlFYjUSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FFD01005504;
	Fri, 11 Dec 2020 16:34:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B90456F45C;
	Fri, 11 Dec 2020 16:34:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3CED21809CA1;
	Fri, 11 Dec 2020 16:34:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBGY1gP017322 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 11:34:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 24A0E2026D3F; Fri, 11 Dec 2020 16:34:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FF492026D3B
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 16:33:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D7C1100B165
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 16:33:58 +0000 (UTC)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
	[209.85.166.67]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-260-gU8oBHxLMoCtngVG5Lgd6Q-1; Fri, 11 Dec 2020 11:33:56 -0500
X-MC-Unique: gU8oBHxLMoCtngVG5Lgd6Q-1
Received: by mail-io1-f67.google.com with SMTP id y5so10052514iow.5
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 08:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=FAw6hXoyT6uM9vzPmYIpKukJwESiYRXuzPIlQPsLuXA=;
	b=cRkkKXT6CiSEIsVFSxPSkUEwfNNdjqCjFHdnn3RhPdc74Wskdw0SMr138Uv2dlEP5I
	xRuGe8Xw6nXVDZc7TI9CVKHYHTtDZRoXgEQBi5lRwrS7QA/vVv80BPJdpnEvGh4LE0Le
	s4ugMkoBA5JmCDJftjnZOjo2VqfXvM8jgWu7NtffLOe4JAvXE6cLAV/7OhJtPKplD4RM
	KJoVGh789YUof6GX6v4GXMZ9uWzy1vtTDt5JAhZBpjGnEeVI4y3p1X6DVzWdK8KTuZr+
	40jiQfLaR7S1NRdTBzWt5QlpZoz50S/pQi2aQ695kIWtHGIjCxcjrua4zZNwyXzkpviS
	tVCw==
X-Gm-Message-State: AOAM5319NBzueQHr+rup7rFNr7TnaWvG/BoNjPWWy9qywnsG425ZwDl9
	69MFxl7BwNnNP5zXZiH5QNS8fqGqvBjreA==
X-Google-Smtp-Source: ABdhPJza4ydPg5ScWsbhL87xQLWUOu18OVel48dEocpMnw6mZJsUxBpB5MtgvueLlNUMfiiYS7gltg==
X-Received: by 2002:a6b:3788:: with SMTP id e130mr16099681ioa.23.1607704435255;
	Fri, 11 Dec 2020 08:33:55 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id f2sm4657901iop.6.2020.12.11.08.33.54
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 11 Dec 2020 08:33:54 -0800 (PST)
To: Mike Snitzer <snitzer@redhat.com>, Sergei Shtepa
	<sergei.shtepa@veeam.com>, hch@lst.de
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com> <20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com> <20201211163049.GC16168@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
Date: Fri, 11 Dec 2020 09:33:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201211163049.GC16168@redhat.com>
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
Cc: "steve@sk2.org" <steve@sk2.org>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@redhat.com, "koct9i@gmail.com" <koct9i@gmail.com>
Subject: Re: [dm-devel] [PATCH 0/3] block: blk_interposer - Block Layer
	Interposer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/11/20 9:30 AM, Mike Snitzer wrote:
> While I still think there needs to be a proper _upstream_ consumer of
> blk_interposer as a condition of it going in.. I'll let others make the
> call.

That's an unequivocal rule.

> As such, I'll defer to Jens, Christoph and others on whether your
> minimalist blk_interposer hook is acceptable in the near-term.

I don't think so, we don't do short term bandaids just to plan on
ripping that out when the real functionality is there. IMHO, the dm
approach is the way to go - it provides exactly the functionality that
is needed in an appropriate way, instead of hacking some "interposer"
into the core block layer.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


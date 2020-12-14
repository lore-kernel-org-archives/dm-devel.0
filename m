Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2586C2BB40
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 17:22:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD71122516
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 17:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD71122516
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-WRbJGjfnNdqWhYuDJOBr2Q-1; Mon, 14 Dec 2020 12:22:17 -0500
X-MC-Unique: WRbJGjfnNdqWhYuDJOBr2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E93815722;
	Mon, 14 Dec 2020 17:22:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6B69E702;
	Mon, 14 Dec 2020 17:22:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D4E5D4BB7B;
	Mon, 14 Dec 2020 17:22:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BEHM8Pu008130 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 12:22:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2924E82872; Mon, 14 Dec 2020 17:22:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 229478289E
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 17:22:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6017857F90
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 17:22:04 +0000 (UTC)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
	[209.85.166.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-10-w7l9jqlGMImiEootivTRqg-1; Mon, 14 Dec 2020 12:22:03 -0500
X-MC-Unique: w7l9jqlGMImiEootivTRqg-1
Received: by mail-io1-f47.google.com with SMTP id i18so17630775ioa.1
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 09:22:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=eWhgExMN4zCprjhcDtgmjw9YARch/pKzDiQ2LLbaT/E=;
	b=chw7hSshsRlfHp2u9g4TSqs8Z2SkhMxEL6FyPs59FQqpQvrauowvXrYe67O5exhTTn
	4EQf5+1mOKQAjueXGpQRtl5m/y8KagTsopTJ9m1zOongigr2VH/8RqQfy7l17OkjfQj+
	MrRYBETaQPwmfgHSKxOumPu2+3G6Zp8NZvcAcTAiYTbWdVrmo8si5CbQKbZ5kXmQZBTD
	2xY+VMDT9jqq11348cChNwMDmsBthS7oymygIttYHCYjb540HeuszAnULRwKhQNlJeu7
	hTdfnDOFppfMJe1rtDBMeqo3sz66xb5LnSfhTCFSMbqWUyKT3FH2IxLkcYmjW3JALLBK
	wB2w==
X-Gm-Message-State: AOAM530BRsvKG2AD6oD8S5kMMSY70rCpO1C+Kd23cS5C8OJlGVthShlt
	zmEc9mMGBXY+TkVgCSGAs/eNoIt6dylWrw==
X-Google-Smtp-Source: ABdhPJzv0nDdErB58l03RvBxS0IlU1/1JVfgOa2qPsxmwVJr9H+ZQuTiasKMVqbH+kw5ob7E0FEkkA==
X-Received: by 2002:a5e:820d:: with SMTP id l13mr32942668iom.102.1607966520897;
	Mon, 14 Dec 2020 09:22:00 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id
	j9sm11475152ile.59.2020.12.14.09.22.00
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 14 Dec 2020 09:22:00 -0800 (PST)
To: Mike Snitzer <snitzer@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
References: <CAHk-=whCKhxNyKn1Arut8xUDKTwp3fWcCj_jbL5dbzkUmo45gQ@mail.gmail.com>
	<20201214053147.GA24093@codemonkey.org.uk> <X9b9ujh5T6U5+aBY@kroah.com>
	<20201214160247.GA2090@redhat.com> <20201214162631.GA2290@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6522caad-bfe8-2554-2ba9-dff5856233d1@kernel.dk>
Date: Mon, 14 Dec 2020 10:21:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214162631.GA2290@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
	dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] Linux 5.10
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/14/20 9:26 AM, Mike Snitzer wrote:
> On Mon, Dec 14 2020 at 11:02am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Mon, Dec 14 2020 at 12:52am -0500,
>> Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>>> On Mon, Dec 14, 2020 at 12:31:47AM -0500, Dave Jones wrote:
>>>> On Sun, Dec 13, 2020 at 03:03:29PM -0800, Linus Torvalds wrote:
>>>>  > Ok, here it is - 5.10 is tagged and pushed out.
>>>>  > 
>>>>  > I pretty much always wish that the last week was even calmer than it
>>>>  > was, and that's true here too. There's a fair amount of fixes in here,
>>>>  > including a few last-minute reverts for things that didn't get fixed,
>>>>  > but nothing makes me go "we need another week".
>>>>
>>>> ...
>>>>
>>>>  > Mike Snitzer (1):
>>>>  >       md: change mddev 'chunk_sectors' from int to unsigned
>>>>
>>>> Seems to be broken.  This breaks mounting my raid6 partition:
>>>>
>>>> [   87.290698] attempt to access beyond end of device
>>>>                md0: rw=4096, want=13996467328, limit=6261202944
>>>> [   87.293371] attempt to access beyond end of device
>>>>                md0: rw=4096, want=13998564480, limit=6261202944
>>>> [   87.296045] BTRFS warning (device md0): couldn't read tree root
>>>> [   87.300056] BTRFS error (device md0): open_ctree failed
>>>>
>>>> Reverting it goes back to the -rc7 behaviour where it mounts fine.
>>>
>>> If the developer/maintainer(s) agree, I can revert this and push out a
>>> 5.10.1, just let me know.
>>
>> Yes, these should be reverted from 5.10 via 5.10.1:
>>
>> e0910c8e4f87 dm raid: fix discard limits for raid1 and raid10
>> f075cfb1dc59 md: change mddev 'chunk_sectors' from int to unsigned
> 
> Sorry, f075cfb1dc59 was my local commit id, the corresponding upstream
> commit as staged by Jens is:
> 
> 6ffeb1c3f82 md: change mddev 'chunk_sectors' from int to unsigned
> 
> So please revert:
> 6ffeb1c3f822 md: change mddev 'chunk_sectors' from int to unsigned
> and then revert:
> e0910c8e4f87 dm raid: fix discard limits for raid1 and raid10

Working with Song on understanding the failure case here. raid6 was
tested prior to this being shipped. We'll be back with more soon...

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


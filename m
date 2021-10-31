Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1FAC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 67F4560FC4
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 67F4560FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-nMyBW42kMWWYT5pNGyZucg-1; Mon, 01 Nov 2021 04:45:53 -0400
X-MC-Unique: nMyBW42kMWWYT5pNGyZucg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB3AC18880A6;
	Mon,  1 Nov 2021 08:45:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BA655D9DC;
	Mon,  1 Nov 2021 08:45:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5EC614E9F4;
	Mon,  1 Nov 2021 08:45:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19VDN6fi030227 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 31 Oct 2021 09:23:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BF4C01121315; Sun, 31 Oct 2021 13:23:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9FE11121314
	for <dm-devel@redhat.com>; Sun, 31 Oct 2021 13:23:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE610899EC0
	for <dm-devel@redhat.com>; Sun, 31 Oct 2021 13:23:03 +0000 (UTC)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
	[209.85.221.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-487-2ks3BU5dMCWLNOG5-_vBAA-1; Sun, 31 Oct 2021 09:22:59 -0400
X-MC-Unique: 2ks3BU5dMCWLNOG5-_vBAA-1
Received: by mail-wr1-f50.google.com with SMTP id d13so24217846wrf.11;
	Sun, 31 Oct 2021 06:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=Jf6SDTWkMqXzv0QqQSCH2GQMbJgZyWWXdFXwIRei+eA=;
	b=Dl2J53yy6wo1U5NILQOQ6RxhxQYDjH0LCrqEZr0Ybb3390FlPNdn8QMcpAYrjYxy3y
	vL75r2XTXiyUqtFFZxAlaSG6K6MraF3eWtqanROLyLsdtFiaj1nPNkUWjIHlTyGmlY+N
	rgfWcDpYz1v68pNpAfg8FNvGETHRl3jO0sikxzjT8jFGzk35puTQvb7pRy4RyHAaT+xj
	nzg1YM6CJZAGNnS88RBkaG3qI+v3nIgLvETRQVHmPwab8m1KlYOHWK4qwJFTsuxmnxmd
	sRxBIFWpwBj+owxl/WkxjeWMUcp7wBiDPJmSm3po0+80i8N4XMc287UCDlttLjXWWRMc
	0JyA==
X-Gm-Message-State: AOAM533J3k7ZPVaX7WR9WTeHzdRxVN9vLqqO9P17J+x32eqtwBXJRxv1
	gEQWbsbC9ZXlcA3BIQiPoFM=
X-Google-Smtp-Source: ABdhPJwe81NiP2m6SZsYCxtthQKFwaV9/lqDLxmxy8VMxp0zyRIKyCnNwIjAhtz/toMYpXnKWoP/Ug==
X-Received: by 2002:a05:6000:15c6:: with SMTP id
	y6mr29561346wry.382.1635686578008; 
	Sun, 31 Oct 2021 06:22:58 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.29])
	by smtp.gmail.com with ESMTPSA id a4sm9477733wmb.39.2021.10.31.06.22.56
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 31 Oct 2021 06:22:57 -0700 (PDT)
Message-ID: <1a76314d-9b62-82a3-2787-96e6b83720fc@gmail.com>
Date: Sun, 31 Oct 2021 13:19:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: Dave Chinner <david@fromorbit.com>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<20211028225955.GA449541@dread.disaster.area>
	<22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
	<20211029223233.GB449541@dread.disaster.area>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211029223233.GB449541@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 01 Nov 2021 04:45:25 -0400
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/29/21 23:32, Dave Chinner wrote:
> On Fri, Oct 29, 2021 at 12:46:14PM +0100, Pavel Begunkov wrote:
>> On 10/28/21 23:59, Dave Chinner wrote:
>> [...]
>>>>> Well, my point is doing recovery from bit errors is by definition not
>>>>> the fast path.  Which is why I'd rather keep it away from the pmem
>>>>> read/write fast path, which also happens to be the (much more important)
>>>>> non-pmem read/write path.
>>>>
>>>> The trouble is, we really /do/ want to be able to (re)write the failed
>>>> area, and we probably want to try to read whatever we can.  Those are
>>>> reads and writes, not {pre,f}allocation activities.  This is where Dave
>>>> and I arrived at a month ago.
>>>>
>>>> Unless you'd be ok with a second IO path for recovery where we're
>>>> allowed to be slow?  That would probably have the same user interface
>>>> flag, just a different path into the pmem driver.
>>>
>>> I just don't see how 4 single line branches to propage RWF_RECOVERY
>>> down to the hardware is in any way an imposition on the fast path.
>>> It's no different for passing RWF_HIPRI down to the hardware *in the
>>> fast path* so that the IO runs the hardware in polling mode because
>>> it's faster for some hardware.
>>
>> Not particularly about this flag, but it is expensive. Surely looks
>> cheap when it's just one feature, but there are dozens of them with
>> limited applicability, default config kernels are already sluggish
>> when it comes to really fast devices and it's not getting better.
>> Also, pretty often every of them will add a bunch of extra checks
>> to fix something of whatever it would be.
>>
>> So let's add a bit of pragmatism to the picture, if there is just one
>> user of a feature but it adds overhead for millions of machines that
>> won't ever use it, it's expensive.
> 
> Yup, you just described RWF_HIPRI! Seriously, Pavel, did you read
> past this?  I'll quote what I said again, because I've already
> addressed this argument to point out how silly it is:

And you almost got to the initial point in your penult paragraph. A
single if for a single flag is not an issue, what is the problem is
when there are dozens of them and the overhead for it is not isolated,
so the kernel has to jump through dozens of those.

And just to be clear I'll outline again, that's a general problem,
I have no relation to the layers touched and it's up to relevant
people, obviously. Even though I'd expect but haven't found the flag
being rejected in other places, but well I may have missed something.


>>> IOWs, saying that we shouldn't implement RWF_RECOVERY because it
>>> adds a handful of branches to the fast path is like saying that we
>>> shouldn't implement RWF_HIPRI because it slows down the fast path
>>> for non-polled IO....
> 
>   RWF_HIPRI functionality represents a *tiny* niche in the wider
> Linux ecosystem, so by your reasoning it is too expensive to
> implement because millions (billions!) of machines don't need or use
> it. Do you now see how silly your argument is?
> 
> Seriously, this "optimise the IO fast path at the cost of everything
> else" craziness has gotten out of hand. Nobody in the filesystem or
> application world cares if you can do 10M IOPS per core when all the
> CPU is doing is sitting in a tight loop inside the kernel repeatedly
> overwriting data in the same memory buffers, essentially tossing the
> old away the data without ever accessing it or doing anything with
> it.  Such speed racer games are *completely meaningless* as an
> optimisation goal - it's what we've called "benchmarketing" for a
> couple of decades now.

10M you mentioned is just a way to measure, there is nothing wrong
with it. And considering that there are enough of users considering
or already switching to spdk because of performance, the approach
is not wrong. And it goes not only for IO polling, normal irq IO
suffers from the same problems.

A related story is that this number is for a pretty reduced config,
it'll go down with a more default-ish kernel.

> If all we focus on is bragging rights because "bigger number is
> always better", then we'll end up with iand IO path that looks like
> the awful mess that the fs/direct-io.c turned into. That ended up
> being hyper-optimised for CPU performance right down to single
> instructions and cacheline load orders that the code became
> extremely fragile and completely unmaintainable.
> 
> We ended up *reimplementing the direct IO code from scratch* so that
> XFS could build and submit direct IO smarter and faster because it
> simply couldn't be done to the old code.  That's how iomap came
> about, and without *any optimisation at all* iomap was 20-30% faster
> than the old, hyper-optimised fs/direct-io.c code.  IOWs, we always
> knew we could do direct IO faster than fs/direct-io.c, but we
> couldn't make the fs/direct-io.c faster because of the
> hyper-optimisation of the code paths made it impossible to modify
> and maintain.> The current approach of hyper-optimising the IO path for maximum
> per-core IOPS at the expensive of everything else has been proven in
> the past to be exactly the wrong approach to be taking for IO path
> development. Yes, we need to be concerned about performance and work
> to improve it, but we should not be doing that at the cost of
> everything else that the IO stack needs to be able to do.

And iomap is great, what you described is a good typical example
of unmaintainable code. I may get wrong what you exactly refer
to, but I don't see maintainability not being considered.

Even more interesting to notice that more often than not extra
features (and flags) almost always hurt maintainability of the
kernel, but then other benefits outweigh (hopefully).

> Fundamentally, optimisation is something we do *after* we provide
> the functionality that is required; using "fast path optimisation"
> as a blunt force implement to prevent new features from being
> implemented is just ...  obnoxious.
> 
>> This one doesn't spill yet into paths I care about, but in general
>> it'd be great if we start thinking more about such stuff instead of
>> throwing yet another if into the path, e.g. by shifting the overhead
>> from linear to a constant for cases that don't use it, for instance
>> with callbacks or bit masks.
> 
> This is orthogonal to providing data recovery functionality.
> If the claims that flag propagation is too expensive are true, then
> fixing this problem this will also improve RWF_HIPRI performance
> regardless of whether RWF_DATA_RECOVERY exists or not...
> 
> IOWs, *if* there is a fast path performance degradation as a result
> of flag propagation, then *go measure it* and show us how much
> impact it has on _real world applications_.  *Show us the numbers*
> and document how much each additional flag propagation actually
> costs so we can talk about whether it is acceptible, mitigation
> strategies and/or alternative implementations.  Flag propagation
> overhead is just not a valid reason for preventing us adding new
> flags to the IO path. Fix the flag propagation overhead if it's a
> problem for you, don't use it as an excuse for preventing people
> from adding new functionality that uses flag propagation...

-- 
Pavel Begunkov

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


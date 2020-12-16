Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC40EC433E9
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5A1A5206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A1A5206A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-a56p9TY4MdmX2QdIZc-MbA-1; Mon, 04 Jan 2021 14:03:52 -0500
X-MC-Unique: a56p9TY4MdmX2QdIZc-MbA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05ED1107ACF7;
	Mon,  4 Jan 2021 19:03:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEAAF57;
	Mon,  4 Jan 2021 19:03:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B40521809CAD;
	Mon,  4 Jan 2021 19:03:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGKZe14001436 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 15:35:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BF9431018E6F; Wed, 16 Dec 2020 20:35:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BAAE81019269
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 20:35:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FBB2101A561
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 20:35:36 +0000 (UTC)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
	[209.85.214.179]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-286--NP3qAS1O-OyaaK2-hzw3A-1; Wed, 16 Dec 2020 15:35:32 -0500
X-MC-Unique: -NP3qAS1O-OyaaK2-hzw3A-1
Received: by mail-pl1-f179.google.com with SMTP id y8so13599867plp.8
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 12:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
	:mime-version:content-transfer-encoding;
	bh=p8XQW4cjugdKIwxwILtgQ7d/G6qN5cGSPlZP2CvVqWE=;
	b=Sl0+gqUIyQTNXstczW1iWJ8AQTIrtpacgF29nv9vV16VW//WNgg8q37JP2PCChV2VL
	qxpVtoR2jwFQ9oT3DVKInvhNzvpU4jaFa6QdQ0Q1i4CaPCOKlmazqYW2V6EiizKt9R0j
	fn56JIaW4TcPHR0e3tjreZQxaJu7Ucox+dBdHchb08vfMWgtEWUqQMqLkxd4wa2myhA+
	dMhzSxSOWkNxHqqbNX0yxB8FIWdrzb0rQh5o+KAzLVcuAA8Z5WNU24AUwwLO5fl0Wb6O
	PZR4jy8YiHbVWiWZFNCPReGOPSS/zqUDCsFKYzdvjzzLwkyVr2bB7v34gNolKvlfXYWe
	efqw==
X-Gm-Message-State: AOAM530nwUfwSRXUwmOVkf/oGvfMLQ9nD7fyUmtX9ruioELj6hzbeuF2
	osXuHTtD2q3OE5JYwR8RrSz4Mw==
X-Google-Smtp-Source: ABdhPJzSD8U4wMSXgHoibwCGxFPKpPyA9oDYq8beROKHNnGC6MmYee5AX3iL50+jC56MZu8jjmPTdw==
X-Received: by 2002:a17:90a:df13:: with SMTP id
	gp19mr4545800pjb.235.1608150930853; 
	Wed, 16 Dec 2020 12:35:30 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	u25sm3329042pfn.170.2020.12.16.12.35.29
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Dec 2020 12:35:29 -0800 (PST)
Date: Wed, 16 Dec 2020 12:35:29 -0800 (PST)
X-Google-Original-Date: Wed, 16 Dec 2020 10:42:26 PST (-0800)
In-Reply-To: <CABmKtjfdDS-iO+jLkwt7x-oDHt9V1p-cpYHjL5EV2NKwHxqN1Q@mail.gmail.com>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ruby.wktk@gmail.com
Message-ID: <mhng-cc7f1629-3ff7-4efe-8dc6-806b4d8e28c5@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Christoph Hellwig <hch@infradead.org>, bvanassche@acm.org,
	snitzer@redhat.com, linux-doc@vger.kernel.org,
	kernel-team@android.com, corbet@lwn.net, josef@toxicpanda.com,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com, agk@redhat.com,
	linux-kselftest@vger.kernel.org, shuah@kernel.org,
	michael.christie@oracle.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
	BIOs to userspace
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Tue, 15 Dec 2020 22:17:06 PST (-0800), ruby.wktk@gmail.com wrote:
> Hi my name is Akira Hayakawa. I am maintaining an out-of-tree DM target
> named dm-writeboost.
>
> Sorry to step in. But this is a very interesting topic at least to me.
>
> I have been looking for something like dm-user because I believe we should
> be able to implement virtual block devices in Rust language.
>
> I know proxying IO requests to userland always causes some overhead but for
> some type of device that performance doesn't matter or some research
> prototyping or pseudo device for testing, this way should be developed. Of
> course, implementation in Rust will give us opportunities to develop more
> complicated software in high quality.
>
> I noticed this thread few days ago then I started to prototype this library
> https://github.com/akiradeveloper/userland-io
>
> It is what I want but the transport is still NBD which I don't like so
> much. If dm-user is available, I will implement a transport using dm-user.

Great, I'm glad to hear that.  Obviously this is still in the early days and
we're talking about high-level ABI design here, so things are almost certainly
going to change, but it's always good to have people pushing on stuff.

Just be warned: we've only had two people write userspaces for this (one of
which was me, and all that is test code) so I'd be shocked if you manage to
avoid running into bugs.

>
> - Akira
>
> On Tue, Dec 15, 2020 at 7:00 PM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
>> On Thu, 10 Dec 2020 09:03:21 PST (-0800), josef@toxicpanda.com wrote:
>> > On 12/9/20 10:38 PM, Bart Van Assche wrote:
>> >> On 12/7/20 10:55 AM, Palmer Dabbelt wrote:
>> >>> All in all, I've found it a bit hard to figure out what sort of
>> interest
>> >>> people
>> >>> have in dm-user: when I bring this up I seem to run into people who've
>> done
>> >>> similar things before and are vaguely interested, but certainly nobody
>> is
>> >>> chomping at the bit.  I'm sending it out in this early state to try and
>> >>> figure
>> >>> out if it's interesting enough to keep going.
>> >>
>> >> Cc-ing Josef and Mike since their nbd contributions make me wonder
>> >> whether this new driver could be useful to their use cases?
>> >>
>> >
>> > Sorry gmail+imap sucks and I can't get my email client to get at the
>> original
>> > thread.  However here is my take.
>>
>> and I guess I then have to apoligize for missing your email ;).  Hopefully
>> that
>> was the problem, but who knows.
>>
>> > 1) The advantages of using dm-user of NBD that you listed aren't actually
>> > problems for NBD.  We have NBD working in production where you can hand
>> off the
>> > sockets for the server without ending in timeouts, it was actually the
>> main
>> > reason we wrote our own server so we could use the FD transfer stuff to
>> restart
>> > the server without impacting any clients that had the device in use.
>>
>> OK.  So you just send the FD around using one of the standard mechanisms to
>> orchestrate the handoff?  I guess that might work for our use case,
>> assuming
>> whatever the security side of things was doing was OK with the old FD.
>> TBH I'm
>> not sure how all that works and while we thought about doing that sort of
>> transfer scheme we decided to just open it again -- not sure how far we
>> were
>> down the dm-user rabbit hole at that point, though, as this sort of arose
>> out
>> of some other ideas.
>>
>> > 2) The extra copy is a big deal, in fact we already have too many copies
>> in our
>> > existing NBD setup and are actively looking for ways to avoid those.
>> >
>> > Don't take this as I don't think dm-user is a good idea, but I think at
>> the very
>> > least it should start with the very best we have to offer, starting with
>> as few
>> > copies as possible.
>>
>> I was really experting someone to say that.  It does seem kind of silly to
>> build
>> out the new interface, but not go all the way to a ring buffer.  We just
>> didn't
>> really have any way to justify the extra complexity as our use cases aren't
>> that high performance.   I kind of like to have benchmarks for this sort of
>> thing, though, and I didn't have anyone who had bothered avoiding the last
>> copy
>> to compare against.
>>
>> > If you are using it currently in production then cool, there's clearly a
>> usecase
>> > for it.  Personally as I get older and grouchier I want less things in
>> the
>> > kernel, so if this enables us to eventually do everything NBD related in
>> > userspace with no performance drop then I'd be down.  I don't think you
>> need to
>> > make that your primary goal, but at least polishing this up so it could
>> > potentially be abused in the future would make it more compelling for
>> merging.
>> > Thanks,
>>
>> Ya, it's in Android already and we'll be shipping it as part of the new OTA
>> flow for the next release.  The rules on deprecation are a bit different
>> over
>> there, though, so it's not like we're wed to it.  The whole point of
>> bringing
>> this up here was to try and get something usable by everyone, and while I'd
>> eventually like to get whatever's in Android into the kernel proper we'd
>> really
>> planned on supporting an extra Android-only ABI for a cycle at least.
>>
>> I'm kind of inclined to take a crack at the extra copy, to at least see if
>> building something that eliminates it is viable.  I'm not really sure if
>> it is
>> (or at least, if it'll net us a meaningful amount of performance), but
>> it'd at
>> least be interesting to try.
>>
>> It'd be nice to have some benchmark target, though, as otherwise this stuff
>> hangs on forever.  My workloads are in selftests later on in the patch
>> set, but
>> I'm essentially using tmpfs as a baseline to compare against ext4+dm-user
>> with
>> some FIO examples as workloads.  Our early benchmark numbers indicated
>> this was
>> way faster than we needed, so I didn't even bother putting together a
>> proper
>> system to run on so I don't really have any meaningful numbers there.  Is
>> there
>> an NBD server that's fast that I should be comparing against?
>>
>> I haven't gotten a whole lot of feedback, so I'm inclined to at least have
>> some
>> reasonable performance numbers before bothering with a v2.
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


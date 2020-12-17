Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99466C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F191206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F191206A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-L-t1hDbAPi-d5OMkG9L6xQ-1; Mon, 04 Jan 2021 14:03:51 -0500
X-MC-Unique: L-t1hDbAPi-d5OMkG9L6xQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBB46801AEC;
	Mon,  4 Jan 2021 19:03:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD7496F924;
	Mon,  4 Jan 2021 19:03:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 90F191809CAB;
	Mon,  4 Jan 2021 19:03:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BH6tUqF032551 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 01:55:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8E7D81016D60; Thu, 17 Dec 2020 06:55:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 899ED101B86F
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 06:55:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7307E811E76
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 06:55:23 +0000 (UTC)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
	[209.85.215.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-571-UyeAFv6uMymAwvzSIcYYow-1; Thu, 17 Dec 2020 01:55:21 -0500
X-MC-Unique: UyeAFv6uMymAwvzSIcYYow-1
Received: by mail-pg1-f182.google.com with SMTP id w16so19669243pga.9
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 22:55:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
	:mime-version:content-transfer-encoding;
	bh=BjnZ5s+jnI9mFnTZF3RJgIJMeukCqH/N1kppehfap7Y=;
	b=pDFV4GKcpcqdAidKtkxS83r1Rs66qUH+4Go0YKX5tsiaurpBqSwxX+72L6XyL46DQG
	YcboQyZbmIkMFX0XSLxJPQhNOTJUz59ZN8fmR2ycWcBP9LCE5O+FqMisE5gcYwMHvbqY
	1TQWlBnKvdF6ci7lOTuSQpNy3APXS20AbJ/NxH/59apVXfhdZGc1I19GRBX1JVzSDCmq
	vGcqdX998svzek7+Xdy77wvSLLatuxmHntlIA0fYtFxG32k8ISh67VP7Xx9BirJBhdZ9
	R1pVhRPlvHaXOs50XwA0hONMcCiXnG/92WiItxk77PeMKQAYGefWzbyjUV9wHzHvXZaZ
	xBwA==
X-Gm-Message-State: AOAM5333wJsy7tKqimnfTkQhCV7rUH79hzg2aBMcb7SCFbquCwBRv8xh
	+JaeBFN65+p0lVa+Fixvo7MfNg==
X-Google-Smtp-Source: ABdhPJwOkX04PZM/hDkMwFByq3zRzuq27yaN/Sp6sDe9qMIhnlWHKH2jlrq5wuwjc8F2fNQ6gRsdzQ==
X-Received: by 2002:aa7:8506:0:b029:19e:95:f75f with SMTP id
	v6-20020aa785060000b029019e0095f75fmr35416013pfn.7.1608188119792;
	Wed, 16 Dec 2020 22:55:19 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223])
	by smtp.gmail.com with ESMTPSA id l7sm3921765pjy.29.2020.12.16.22.55.18
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Dec 2020 22:55:19 -0800 (PST)
Date: Wed, 16 Dec 2020 22:55:19 -0800 (PST)
X-Google-Original-Date: Wed, 16 Dec 2020 22:55:17 PST (-0800)
In-Reply-To: <CAGF4SLgDvS7VOih4XZ+sqx6jVK3wBQZan+uZMVsdYdVEPZdrpw@mail.gmail.com>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: v.mayatskih@gmail.com
Message-ID: <mhng-7da80016-a7d7-4232-999d-6fea3196118d@palmerdabbelt-glaptop>
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
Cc: linux-raid@vger.kernel.org, bvanassche@acm.org, snitzer@redhat.com,
	corbet@lwn.net, shuah@kernel.org, linux-doc@vger.kernel.org,
	josef@toxicpanda.com, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, song@kernel.org,
	dm-devel@redhat.com, michael.christie@oracle.com,
	linux-kselftest@vger.kernel.org, kernel-team@android.com, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Wed, 16 Dec 2020 10:24:59 PST (-0800), v.mayatskih@gmail.com wrote:
> On Mon, Dec 14, 2020 at 10:03 PM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
>> I was really experting someone to say that.  It does seem kind of silly to build
>> out the new interface, but not go all the way to a ring buffer.  We just didn't
>> really have any way to justify the extra complexity as our use cases aren't
>> that high performance.   I kind of like to have benchmarks for this sort of
>> thing, though, and I didn't have anyone who had bothered avoiding the last copy
>> to compare against.
>
> I worked on something very similar, though performance was one of the
> goals. The implementation was floating around lockless ring buffers,
> shared memory for zerocopy, multiqueue and error handling. It could be
> that every disk storage vendor has to implement something like that in
> order to bridge Linux kernel to their own proprietary datapath running
> in userspace.

OK, good to know.  That's kind of the feeling I'd gotten from having chatted to
a handful of people about this, but I don't remember people having actually
gotten all the way to zero-copy.  That's how we managed to end up at this
middle-ground ABI style: when I thought people were, in practice, punting on
zero copy because the complexity just wasn't worth the performance benefit.
Maybe I'd just been colored by how my projects ended up going, but I've ended
up designing complicated interfaces in the past that allow for zero-copy only
to never get around to actually making that work.  I don't know if that's just
because I've had the good fortune to avoid working on anything that ended up
with users, though :).

For our use case I think we actually get better performance out of the
copy-based (and probably more importantly kalloc-based, but that's an
implementation thing not an ABI thing) approach: essentially we're very
sensitive to memory pressure and expect this first dm-user daemon to mostly be
idle, so we're really worried about avoiding excess memory usage while idle and
less worried about throughput when active.  This stream-based interface means
that userspace doesn't need much memory allocated to service a request, which
helps with sleep/wake latencies and/or idle memory usage.  That's also why we
have the simple locking scheme: no sense splitting locks if there's no
contention, and we only need a single thread to saturate the storage bandwidth
on these phones.

That said, it does sound like people really do care about the sort of
performance levels where zero copy is relevant in this space.  I'll take a shot
at something along those lines, and while it will add a degree of userspace
complexity I'm not sure it'll add much in the way of kernel complexity -- at
least compared to a fast version of this, where we'd need most of that stuff
anyway (obviously the malloc+single lock design is simple, but probably
wouldn't stick around for long).  At a bare minimum it'll be interesting to
play around with, but if people are doing it in practice then I'm more
confident that I can put something together that at least serves as a starting
point for further discussion.

I haven't gotten around to writing any code yet, but I had spent a bit of time
thinking about how to put this zero-copy version together and am leaning
towards it being a standalone block device (as opposed to a DM target).  I'd
avoided that before as I didn't want to mess around with my own device control
scheme so I'll still try to do the DM thing, but I'm not sure it'll be viable.
That's all speculation now, but it does bring up one interesting question:

IIUC, this version of dm-user handles BIOs before they reach the block
scheduler while a standalone driver would likely handle them after blk-mq.  I
don't have direct experience with this, but the last time I ran into people who
had these sorts of performance requirements for userspace drivers they weren't
actually trying to write userspace drivers but were instead trying to write a
userspace scheduler, with the userspace drivers just being the mechanism to
implement that scheduler.  This was a decade ago and I'm not sure that's what
people are trying to do in the new blk-mq world, but if it is then it's going
to be a major design consideration.  I'm also not entirely sure that we're
really solving the same problem at that point.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


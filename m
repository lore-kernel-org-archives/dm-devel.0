Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0031DC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6ACDC23B79
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:57:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ACDC23B79
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-bztCSPzeM9uU3AnpQw9foQ-1; Wed, 09 Dec 2020 04:57:55 -0500
X-MC-Unique: bztCSPzeM9uU3AnpQw9foQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B9418030AB;
	Wed,  9 Dec 2020 09:57:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31B945C234;
	Wed,  9 Dec 2020 09:57:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 03A1C1809C9F;
	Wed,  9 Dec 2020 09:57:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B7Iu5cl012638 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 13:56:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 13E0E111284A; Mon,  7 Dec 2020 18:56:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E0A61112854
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 18:56:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1FEB800969
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 18:56:02 +0000 (UTC)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
	[209.85.210.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-471-gIIg6_K5NSiEsTrBKcBd2Q-1; Mon, 07 Dec 2020 13:56:00 -0500
X-MC-Unique: gIIg6_K5NSiEsTrBKcBd2Q-1
Received: by mail-pf1-f194.google.com with SMTP id w6so10979515pfu.1
	for <dm-devel@redhat.com>; Mon, 07 Dec 2020 10:56:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
	:mime-version:content-transfer-encoding;
	bh=KtGdp/lwKq2VYARUSn9Vex8GHiah3So/M600I4rdU+k=;
	b=jNKhK8G3Ozv3al+C0AnBXdLtcSObF/0sGwxlOm1/YNTICLhoxT6aVgeETNXZBVUyh5
	sBMelIkOtdGTqBc/i0A0IvNkWGyeYPj0OlgE872NYwsTrO59/In1lIkTA/mYRcVCg0bg
	jFd/sRTORg7EVgpqCZzjJDCvJKdW9Gn1P0Xu0ifJHd+FeL7shx7YOEVgbScBbIxWEWA9
	5ThTzWwJ1nni++QZbM7RvOPDAaYeIvjQUElbwZ7ljld9msbOHk9Oxzs7PCpECRbOkOEV
	dnV28gzHAaY6n32mjkuIBVlOTFoBYYLYILxxMQNapoWlsHypUvAG0J7tkMN5yNxZ0uCh
	H/7A==
X-Gm-Message-State: AOAM531nFUU84ssEY0yEGEUK5z1P+mAJ/xoHsyR8PWQTTZdAkGAV++rQ
	ROp/GBZwv4YkfhvGpZT1r4ZWY4H7L4x4TqxO
X-Google-Smtp-Source: ABdhPJzLmOMynfb1JI8F+/oNdCFJom0GbATVogv9ZDfkhxeT99YUXudSQ0OdVQFteOgVntZyE3iBvQ==
X-Received: by 2002:a62:4dc2:0:b029:19d:b6f2:e7bb with SMTP id
	a185-20020a624dc20000b029019db6f2e7bbmr17129167pfb.74.1607367358874;
	Mon, 07 Dec 2020 10:55:58 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	t36sm14214255pfg.55.2020.12.07.10.55.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 07 Dec 2020 10:55:57 -0800 (PST)
Date: Mon, 07 Dec 2020 10:55:57 -0800 (PST)
X-Google-Original-Date: Mon, 07 Dec 2020 10:55:56 PST (-0800)
In-Reply-To: <20201204103336.GA7374@infradead.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <mhng-97fc5874-29d0-4d9e-8c92-d3704a482f28@palmerdabbelt-glaptop1>
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
X-Mailman-Approved-At: Wed, 09 Dec 2020 04:56:16 -0500
Cc: snitzer@redhat.com, corbet@lwn.net, kernel-team@android.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
	linux-kselftest@vger.kernel.org, shuah@kernel.org, agk@redhat.com
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

On Fri, 04 Dec 2020 02:33:36 PST (-0800), Christoph Hellwig wrote:
> What is the advantage over simply using nbd?

There's a short bit about that in the cover letter (and in some talks), but
I'll expand on it here -- I suppose my most important question is "is this
interesting enough to take upstream?", so there should be at least a bit of a
description of what it actually enables:

I don't think there's any deep fundamental advantages to doing this as opposed
to nbd/iscsi over localhost/unix (or by just writing a kernel implementation,
for that matter), at least in terms of anything that was previously impossible
now becoming possible.  There are a handful of things that are easier and/or
faster, though.

dm-user looks a lot like NBD without the networking.  The major difference is
which side initiates messages: in NBD the kernel initiates messages, while in
dm-user userspace initiates messages (via a read that will block if there is no
message, but presumably we'd want to add support for a non-blocking userspace
implementations eventually).  The NBD approach certainly makes sense for a
networked system, as one generally wants to have a single storage server
handling multiple clients, but inverting that makes some things simpler in
dm-user.  

One specific advantage of this change is that a dm-user target can be
transitioned from one daemon to another without any IO errors: just spin up the
second daemon, signal the first to stop requesting new messages, and let it
exit.  We're using that mechanism to replace the daemon launched by early init
(which runs before the security subsystem is up, as in our use case dm-user
provides the root filesystem) with one that's properly sandboxed (which can
only be launched after the root filesystem has come up).  There are ways around
this (replacing the DM table, for example), but they don't fit it as cleanly.

Unless I'm missing something, NBD servers aren't capable of that style of
transition: soft disconnects can only be initiated by the client (the kernel,
in this case), which leaves no way for the server to transition while
guaranteeing that no IOs error out.  It's usually possible to shoehorn this
sort of direction reversing concept into network protocols, but it's also
usually ugly (I'm thinking of IDLE, for example).  I didn't try to actually do
it, but my guess would be that adding a way for the server to ask the client to
stop sending messages until a new server shows up would be at least as much
work as doing this.

There are also a handful of possible performance advantages, but I haven't gone
through the work to prove any of them out yet as performance isn't all that
important for our first use case.  For example:

* Cutting out the network stack is unlikely to hurt performance.  I'm not sure
  if it will help performance, though.  I think if we really had workload where
  the extra copy was likely to be an issue we'd want an explicit ring buffer,
  but I have a theory that it would be possible to get very good performance out
  of a stream-style API by using multiple channels and relying on io_uring to
  plumb through multiple ops per channel.
* There's a comment in the implementation about allowing userspace to insert
  itself into user_map(), likely by uploading a BPF fragment.  There's a whole
  class of interesting block devices that could be written in this fashion:
  essentially you keep a cache on a regular block device that handles the common
  cases by remapping BIOs and passing them along, relegating the more complicated
  logic to fetch cache misses and watching some subset of the access stream where
  necessary.

  We have a use case like this in Android, where we opportunistically store
  backups in a portion of the TRIM'd space on devices.  It's currently
  implemented entirely in kernel by the dm-bow target, but IIUC that was deemed
  too Android-specific to merge.  Assuming we could get good enough performance
  we could move that logic to userspace, which lets us shrink our diff with
  upstream.  It feels like some other interesting block devices could be
  written in a similar fashion.

All in all, I've found it a bit hard to figure out what sort of interest people
have in dm-user: when I bring this up I seem to run into people who've done
similar things before and are vaguely interested, but certainly nobody is
chomping at the bit.  I'm sending it out in this early state to try and figure
out if it's interesting enough to keep going.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


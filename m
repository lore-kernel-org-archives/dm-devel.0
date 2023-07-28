Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886C1C0015E
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jul 2023 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690555762;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b4FAogS0vdTDkgxohkC+yJUBc0tlV7osEHxCngbyIms=;
	b=YpjQi7fVc74wCeI+aiaBHyGkGnXrWI9qb5si+wDpBTgSF2te7T24gwDNxufqGdYnsU7p1s
	fkbyLTyvqg2+vHMxbyJNV/gujFnsDOZfAdFpDsUfAebDqM+CkvkB7jd8f0EMBi4VD7lNka
	ZC+zmI3sUq1WCb5ebhW8XjZ7eJ30Kq4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-nbnW-uRZNcakHdrDq4rWmg-1; Fri, 28 Jul 2023 10:49:19 -0400
X-MC-Unique: nbnW-uRZNcakHdrDq4rWmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C5023806104;
	Fri, 28 Jul 2023 14:49:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B138A1454145;
	Fri, 28 Jul 2023 14:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6C23B1946A6A;
	Fri, 28 Jul 2023 14:49:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 172B9194658C
 for <dm-devel@listman.corp.redhat.com>; Fri, 28 Jul 2023 14:49:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC7091454151; Fri, 28 Jul 2023 14:49:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E439F1454145
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 14:49:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7EEA1C02153
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 14:49:12 +0000 (UTC)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-7emNX8qBN1KIm6j588kgOQ-1; Fri, 28 Jul 2023 10:49:10 -0400
X-MC-Unique: 7emNX8qBN1KIm6j588kgOQ-1
Received: by mail-oi1-f170.google.com with SMTP id
 5614622812f47-3a44cccbd96so1741520b6e.3
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 07:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690555749; x=1691160549;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=IjrvcJKebeEwg9LTzLTjWACkgonOIQA7bC9s/xETMO8=;
 b=i36aVH9ELSfH+tNQlts+AhZLs6mwSbl0MlOPrpqgwiiZJ24RY+g2zhLxiuombb2Qxy
 4M6Uuazg1cpPqakryf2NbOnTEVqMWtZ3eUzXCKTq0oFCHwi9Qy+prpu2r1v1Ifm83NXv
 /Ww2tqK8mEI6k7U0e98CV4NYovgIL4d5UNooKFfTGHyfDPwfGyZxHUQt89WtEToNNcL1
 1PMrpWcTk+6x6QGbAH+iyKMKP7a4f0KAu6itCXXMaTxZiMcfw2G9gCwK6qG60ja9Xq08
 +XC8fXTPo6Fh9VB3TeHfGCO3braiy5MeLAXkjFT6N6+1pZl3mI3bzInnkMHOERw2EfYY
 vLkw==
X-Gm-Message-State: ABy/qLatOvVE7AdMyRvzXIlvQ6zVN2CuzwBXS+r8e5gepGrDWw+AWL8n
 6Lu7ftR2VpC4RQZxrX97MDf2jQI=
X-Google-Smtp-Source: APBJJlGlkWiCzOmra139l12mk7kimCXAWMjL9VN0DfWLIroxj7ZxsY565yQSDv3HLOAwVY0HSwwYBQ==
X-Received: by 2002:a05:6358:2808:b0:138:dd09:8679 with SMTP id
 k8-20020a056358280800b00138dd098679mr3175670rwb.2.1690555749491; 
 Fri, 28 Jul 2023 07:49:09 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o17-20020a0cf4d1000000b0063d0f1db105sm1309899qvm.32.2023.07.28.07.49.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 28 Jul 2023 07:49:09 -0700 (PDT)
Date: Fri, 28 Jul 2023 10:49:07 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Ken Raeburn <raeburn@redhat.com>
Message-ID: <ZMPVY5wW9GTIwlLZ@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
 <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
 <87cz0e9rkn.fsf@redhat.com> <ZMKF24poWyKdeRHO@redhat.com>
 <874jloa18b.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <874jloa18b.fsf@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 00/39] Add the dm-vdo deduplication and
 compression device mapper target.
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com,
 tj@kernel.org, ebiggers@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 28 2023 at  4:28P -0400,
Ken Raeburn <raeburn@redhat.com> wrote:

> 
> Mike Snitzer <snitzer@kernel.org> writes:
> > Thanks for the extra context, but a _big_ elephant in the room for
> > this line of discussion is that: the Linux workqueue code has
> > basically always been only available for use by GPL'd code.  Given
> > VDO's historic non-GPL origins, it seems _to me_ that an alternative
> > to Linux's workqueues had to be created to allow VDO to drive its
> > work.  While understandable, I gave guidance 6 years ago that VDO
> > engineering should work to definitively reconcile if using Linux
> > workqueues viable now that VDO has been GPL'd.
> 
> Yes, initially that was a significant reason.
> 
> More recently, when we've tried switching, the performance loss made it
> appear not worth the change. Especially since we also needed to ship a
> usable version at the same time.
> 
> > But it appears there wasn't much in the way of serious effort put to
> > completely converting to using Linux workqueues. That is a problem
> > because all of the work item strategy deployed by VDO is quite
> > bespoke.  I don't think the code lends itself to being properly
> > maintained by more than a 1 or 2 engineers (if we're lucky at this
> > point).
> 
> By "work item strategy" are you referring to the lower level handling of
> queueing and executing the work items? Because I've done that. Well, the
> first 90%, by making the VDO work queues function as a shim on top of
> the kernel ones instead of creating their own threads. It would also
> need the kernel workqueues modified to support the SYSFS and ORDERED
> options together, because on NUMA systems the VDO performance really
> tanks without tweaking CPU affinity, and one or two other small
> additions. If we were to actually commit to that version there might be
> additional work like tweaking some data structures and eliding some shim
> functions if appropriate, but given the performance loss, we decided to
> stop there.

There needs to be a comprehensive audit of the locking and the
granularity of work.  The model VDO uses already requires that
anything that needs a continuation is assigned to the same thread
right?  Matt said that there is additional locking in the rare case
that another thread needs read access to an object.

Determining how best to initiate the work VDO requires (and provide
mutual exclusion that still allows concurrency is the goal). Having a
deep look at this is needed.
 
> Or do you mean the use of executing all actions affecting a data
> structure in a single thread/queue via message passing to serialize
> access to data structures instead of having a thread serially lock,
> modify, and unlock the various different data structures on behalf of a
> single I/O request, while another thread does the same for another I/O
> request? The model we use can certainly make things more difficult to
> follow. It reads like continuation-passing style code, not the
> straight-line code many of us are more accustomed to.
> 
> "Converting to using Linux workqueues" really doesn't say the latter to
> me, it says the former. But I thought I'd already mentioned I'd tried
> the former out. (Perhaps not very clearly?)

The implicit locking of the VDO thread assignment model needs to be
factored out.  If 'use_vdo_wq' is true then the locking operations are
a noop. But if Linux workqueues are used then appropriate locking
needed.

FYI, dm-cache-target.c uses a struct continuation to queue a sequence
of work.  Can VDO translate its ~12 stages of work into locking a vio
and using continuations to progress through the stages?  The locking
shouldn't be overbearing since VDO is already taking steps to isolate
the work to particular threads.

Also, just so you're aware DM core now provides helpers to shard a
data structures locking (used by dm-bufio and dm-bio-prison-v1).  See
dm_hash_locks_index() and dm_num_hash_locks().

> > I would like to see a patch crafted that allows branching between the
> > use of Linux and VDO workqueues. Initially have a dm-vdo modparam
> > (e.g. use_vdo_wq or vice-versa: use_linux_wq).  And have a wrapping
> > interface and associated data struct(s) that can bridge between work
> > being driven/coordinated by either (depending on disposition of
> > modparam).
> 
> If we're talking about the lower level handling, I don't think it would
> be terribly hard.
> 
> > This work isn't trivial, I get that. But it serves to clearly showcase
> > shortcomings, areas for improvement, while pivoting to more standard
> > Linux interfaces that really should've been used from VDO's inception.
> >
> > Is this work that you feel you could focus on with urgency?
> >
> > Thanks,
> > Mike
> 
> I think so, once we're clear on exactly what we're talking about...

I'm talking about a comprehensive audit of how work is performed.  And
backfilling proper locking by factoring out adequate protection that
allows conditional use of locking (e.g. IFF using linux workqueues).

In the end, using either VDO workqueue or Linux workqueues must pass
all VDO tests.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


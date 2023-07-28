Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B100EC001DE
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jul 2023 08:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690532950;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MbvXceu8qdVUH6uSMmYxG7VrY9N4BEY+icAREcEuJZs=;
	b=TQGwqusiavNrGHeecuq+Apl68IrpU1fk+c2KoDscAYQWurM6xRxlQKwQE1GAr9jkHfUBNp
	m9T4dmkybe462ZordqSayfO1OMB6AW+icj9wvKdGDFJWkwZWw24X2W7EK5B9vVITC8jaTY
	pdzzjxKD4pp0ko7rgopqMVAlwvPHEbQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-tPXEVQlGOHaHtj1BBFfS3Q-1; Fri, 28 Jul 2023 04:29:06 -0400
X-MC-Unique: tPXEVQlGOHaHtj1BBFfS3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57BD7805C3F;
	Fri, 28 Jul 2023 08:29:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2CAFC585A0;
	Fri, 28 Jul 2023 08:28:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E1EB1946A75;
	Fri, 28 Jul 2023 08:28:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F16111946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 28 Jul 2023 08:28:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B39A72166B25; Fri, 28 Jul 2023 08:28:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC6BB2166B26
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 08:28:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9016E856F67
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 08:28:56 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-U7_81ZWNNTufhuogDNgoeQ-1; Fri, 28 Jul 2023 04:28:54 -0400
X-MC-Unique: U7_81ZWNNTufhuogDNgoeQ-1
Received: by mail-qk1-f200.google.com with SMTP id
 af79cd13be357-765ab532883so219300085a.0
 for <dm-devel@redhat.com>; Fri, 28 Jul 2023 01:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690532934; x=1691137734;
 h=mime-version:user-agent:message-id:in-reply-to:date:references
 :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=leIkqAudEGz78/ipkbxeymQs0lqhSaqKZ/Eo5h7Uujg=;
 b=RfuHHCQLOar0bJGXIGb8xYB4mLtf4qcUwHhOrDC7TcIpKkh6btkUmc87FvI9xvWMWf
 3OS4ZWWtAjsXmEJEfhj4JKsgfwEaRA7TfQeZ7H6jp8DlAijBmxE8C68jdAsY9KQJXf3J
 PCu4vSQQElZIz5GdLieqPKqD/iefx0m72zOdm47kdo5BnvfnPJehGg22QMgfES7CfSna
 8SnaRKN2I7pswFskoj0kjOpuT8Ir9+nk0KPp826n2afrBHwAkV79obVh7DfncpQ71i6M
 eVI7WlCkGOHXFPZi29mU1sttHnzq794evppML70b6l1Jc4pifbc9SQUq7y5OpkLzb/Tw
 7Sng==
X-Gm-Message-State: ABy/qLYv+chjhTvQNH30vd9X6zJUtMN3EGOpnRNoEAqAKfaD2yJ+d8HM
 zp2SGRoyH4w+ZlRLvqRRYVdLzqI78bfF5XeT8yaGeIcNda9G3czinvF1AFE359aFE74LLpWKiqU
 HEpEKqSXb8/w3/Vg=
X-Received: by 2002:a05:620a:4586:b0:767:f1f5:9986 with SMTP id
 bp6-20020a05620a458600b00767f1f59986mr2165214qkb.24.1690532934366; 
 Fri, 28 Jul 2023 01:28:54 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFJx/es0sujNTznp15UzhUi8RG+M8r9OGkm9Esn3oXJml0Fbp/KxtFMXuuT+zYZDctWoQQU4Q==
X-Received: by 2002:a05:620a:4586:b0:767:f1f5:9986 with SMTP id
 bp6-20020a05620a458600b00767f1f59986mr2165199qkb.24.1690532934021; 
 Fri, 28 Jul 2023 01:28:54 -0700 (PDT)
Received: from crash (c-24-218-80-208.hsd1.ma.comcast.net. [24.218.80.208])
 by smtp.gmail.com with ESMTPSA id
 27-20020a05620a079b00b00767da9b6ae9sm975473qka.11.2023.07.28.01.28.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 28 Jul 2023 01:28:53 -0700 (PDT)
From: Ken Raeburn <raeburn@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
 <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
 <87cz0e9rkn.fsf@redhat.com> <ZMKF24poWyKdeRHO@redhat.com>
Date: Fri, 28 Jul 2023 04:28:52 -0400
In-Reply-To: <ZMKF24poWyKdeRHO@redhat.com> (Mike Snitzer's message of "Thu, 27
 Jul 2023 10:57:31 -0400")
Message-ID: <874jloa18b.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
 ebiggers@kernel.org, tj@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Mike Snitzer <snitzer@kernel.org> writes:
> Thanks for the extra context, but a _big_ elephant in the room for
> this line of discussion is that: the Linux workqueue code has
> basically always been only available for use by GPL'd code.  Given
> VDO's historic non-GPL origins, it seems _to me_ that an alternative
> to Linux's workqueues had to be created to allow VDO to drive its
> work.  While understandable, I gave guidance 6 years ago that VDO
> engineering should work to definitively reconcile if using Linux
> workqueues viable now that VDO has been GPL'd.

Yes, initially that was a significant reason.

More recently, when we've tried switching, the performance loss made it
appear not worth the change. Especially since we also needed to ship a
usable version at the same time.

> But it appears there wasn't much in the way of serious effort put to
> completely converting to using Linux workqueues. That is a problem
> because all of the work item strategy deployed by VDO is quite
> bespoke.  I don't think the code lends itself to being properly
> maintained by more than a 1 or 2 engineers (if we're lucky at this
> point).

By "work item strategy" are you referring to the lower level handling of
queueing and executing the work items? Because I've done that. Well, the
first 90%, by making the VDO work queues function as a shim on top of
the kernel ones instead of creating their own threads. It would also
need the kernel workqueues modified to support the SYSFS and ORDERED
options together, because on NUMA systems the VDO performance really
tanks without tweaking CPU affinity, and one or two other small
additions. If we were to actually commit to that version there might be
additional work like tweaking some data structures and eliding some shim
functions if appropriate, but given the performance loss, we decided to
stop there.

Or do you mean the use of executing all actions affecting a data
structure in a single thread/queue via message passing to serialize
access to data structures instead of having a thread serially lock,
modify, and unlock the various different data structures on behalf of a
single I/O request, while another thread does the same for another I/O
request? The model we use can certainly make things more difficult to
follow. It reads like continuation-passing style code, not the
straight-line code many of us are more accustomed to.

"Converting to using Linux workqueues" really doesn't say the latter to
me, it says the former. But I thought I'd already mentioned I'd tried
the former out. (Perhaps not very clearly?)

> I would like to see a patch crafted that allows branching between the
> use of Linux and VDO workqueues. Initially have a dm-vdo modparam
> (e.g. use_vdo_wq or vice-versa: use_linux_wq).  And have a wrapping
> interface and associated data struct(s) that can bridge between work
> being driven/coordinated by either (depending on disposition of
> modparam).

If we're talking about the lower level handling, I don't think it would
be terribly hard.

> This work isn't trivial, I get that. But it serves to clearly showcase
> shortcomings, areas for improvement, while pivoting to more standard
> Linux interfaces that really should've been used from VDO's inception.
>
> Is this work that you feel you could focus on with urgency?
>
> Thanks,
> Mike

I think so, once we're clear on exactly what we're talking about...

Ken

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


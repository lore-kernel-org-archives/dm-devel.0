Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2393DC19F2D
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 22:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659047848;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=w8wfifEM6P43GCo4Y1veyQiJz6s3BQaOzVEg0M26l2s=;
	b=YRf9FMEP9SU5X4LqgagcImlQZAu/eI8OEylQ0jG/b3rq9BJ2i8Pl7H5hQ627ANP9XEca7f
	j7/M9hJuEiI6l94/CEK8tEVkM9Vo3VzFbJ9w87FG9wjI8axkRO/SdwzWjZxf/8W47qwtsz
	4A5NxEoZMix5s9xiF4o1Yw9pWMn83zU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-QktSDBdmN7mlhEaND4qfkw-1; Thu, 28 Jul 2022 18:37:24 -0400
X-MC-Unique: QktSDBdmN7mlhEaND4qfkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49CEF811E84;
	Thu, 28 Jul 2022 22:37:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B787290A04;
	Thu, 28 Jul 2022 22:37:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B35AE1945DA7;
	Thu, 28 Jul 2022 22:37:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6AA5B1945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 22:37:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5BFA6492CA2; Thu, 28 Jul 2022 22:37:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57D9C492C3B
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 22:37:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4009E28084EE
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 22:37:13 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-_u61eb78P4-GWdhpJOIwjA-1; Thu, 28 Jul 2022 18:37:12 -0400
X-MC-Unique: _u61eb78P4-GWdhpJOIwjA-1
Received: by mail-qt1-f197.google.com with SMTP id
 a18-20020a05622a02d200b0031ed7ae9abeso1864014qtx.8
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 15:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KiZXluae9bOrzzaCm+A9NCYqephj85Bpfnncyn8a4Cc=;
 b=SidxCGIKjQd8N88s/4u6irrJlVDGoJWf5btcbZ0yiJe3MOWBwKxvNHOhiy6T49e+E6
 X4qL8Zi4nJe8C2cMgOs+13rN4dXgBpt3I6zbYBZ+kqkpM+8mUlyfLRIcMP3+wm/I5MoV
 xMKlMw1PDR3s/b1id7OhodIy0uqX3+CWbBnvaT2/iDOW60oUnsY5M2mueUtoghXRTAle
 k1bLCrrQbgbFbQqvrsJHVhiV2wmspR8AmQJZ43IwzdzDViP/4rF0m0Np4YWf9Ko6CXQ+
 xOx9PYGRqyjAQxGbBKeixWXk4b6vDD0cIr4C+kb7jXAr21hGQCFsh1aW90TcC2wdufAo
 mVig==
X-Gm-Message-State: AJIora+tBOmg7sRbgTM0KfQ+Z3QHiS6QfA4No+i6pP6bHIb/stDUwf5v
 ld56dFP8dkqPOeSnNkyNJ9hrsp+uWRrZ6UtZzPm0NM4MrWz+vvZX2iy7BrF9FAbmg+aLydX77x0
 mOJKbr2z8vCMndw==
X-Received: by 2002:a05:622a:164b:b0:31e:fec2:d1d9 with SMTP id
 y11-20020a05622a164b00b0031efec2d1d9mr1049154qtj.631.1659047831365; 
 Thu, 28 Jul 2022 15:37:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u5LvzRXII3uNLT0f5aOIMo2uxDZ8H3yOaNMsHPO0S72DzHzJKYivcBlbtlYD5Zse63D8da6Q==
X-Received: by 2002:a05:622a:164b:b0:31e:fec2:d1d9 with SMTP id
 y11-20020a05622a164b00b0031efec2d1d9mr1049145qtj.631.1659047831104; 
 Thu, 28 Jul 2022 15:37:11 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 q9-20020a37f709000000b006b5a9e53105sm418046qkj.91.2022.07.28.15.37.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Jul 2022 15:37:10 -0700 (PDT)
Date: Thu, 28 Jul 2022 18:37:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Nathan Huckleberry <nhuck@google.com>
Message-ID: <YuMPlUzCvhEJIQXh@redhat.com>
References: <20220726160959.89247-1-snitzer@kernel.org>
 <20220726160959.89247-3-snitzer@kernel.org>
 <alpine.LRH.2.02.2207271055510.28280@file01.intranet.prod.int.rdu2.redhat.com>
 <YuFeL6J1gtFV63dW@redhat.com>
 <CAJkfWY7_W-o68=xvKga7=eTkDa4ygod2CV9MFdZbGw7xwE_U0w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJkfWY7_W-o68=xvKga7=eTkDa4ygod2CV9MFdZbGw7xwE_U0w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 2/6] dm bufio: Add
 DM_BUFIO_CLIENT_NO_SLEEP flag
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
Cc: Eric Biggers <ebiggers@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 27 2022 at  3:53P -0400,
Nathan Huckleberry <nhuck@google.com> wrote:

> On Wed, Jul 27, 2022 at 8:48 AM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > On Wed, Jul 27 2022 at 11:25P -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > > Hi
> > >
> > > I'd like to ask - why not use dm_bufio_trylock from an interrupt context?
> > >
> > > I would just add a new function "dm_bufio_get_trylock" that is equivalent
> > > to "dm_bufio_get", except that it uses dm_bufio_trylock - and if it fails,
> > > fallback to process context.
> > >
> > > I think using dm_bufio_trylock would be less hacky than introducing a
> > > new dm_bufio flag that changes mutex to spinlock.
> >
> > OK, I can drop the bufio hacks (patches 1 and 2) and replace with a
> > dm_bufio_get_trylock and see if that resolves the cryptsetup testing
> > issues Milan is reporting.  But on the flip side I feel like trylock
> > is far more prone to fail for at least one of a series of cached
> > buffers needed (via _get). And so it'll punt to workqueue more often
> > and _not_ provide the desired performance improvement.  BUT.. we shall
> > see.
> >
> > All said, I'm now dropping this patchset from the upcoming 5.20 merge.
> > This all clearly needs more development time.
> >
> > Huck: I'll run with Mikulas's suggestion and try to get the cryptsetup
> > tests passing. But I'll leave performance testing to you.
> >
> 
> Sounds like a reasonable fix. I expect that dm_bufio_get_trylock with
> WQ_HIGHPRI will give similar performance gains.

Hi,

Just wanted to share where I am with this line of work:

1) I tried to use a semaphore instead of spinlock in bufio along with
adding a dm_bufio_get_nowait that used dm_bufio_trylock. Turns out
that wasn't valid because dm_bufio_release used down() and schedule,
which isn't valid in tasklet. Mikulas and I discussed this situation
and he proposed one way forward to still use semaphore but it'd
require new dm-verity code that prepared a cookie (struct) pointer and
issued a callback then drop the lock (so it'd avoid excessive
locking).  But I abandoned that due to the uncharted territory it was
bringing us down.

2) Using Milan's cryptsetup branch and test procedure documented here:
https://listman.redhat.com/archives/dm-devel/2022-July/051666.html
I got the first "./verity-compat-test" to work with this branch:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-5.21
But then when I took the next step to always --use-tasklets I got
hangs in the verity workqueue.

I'm not sure how you got your code working, I cannot see any material
difference between my dm-5.21 branch and your original patchset.

If you'd like to have a look at the dm-5.21 branch to see if you can
make it work that'd be appreciated.

But I cannot put more time to this verity tasklet effort any more this
week.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


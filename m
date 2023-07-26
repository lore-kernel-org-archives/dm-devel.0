Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF925C001DF
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jul 2023 23:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690415206;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9avT3ADB8Nqmtf9CY5C7aGKz5p/5AFVaJYTuDqSS6o4=;
	b=Tdk8Ynibo0K58i9UWoxDeFr4RkgadxAmZvYKlU32+kJiGri1j70ObBkQvYQ65P39ikc3H1
	cnELX7YtlEnjkF4KJFD+1HjALNhDVuSpu11TH8OgHRWAiIJjKCG7RwVkOfMVKIuJjrl15B
	OW2WM5UCkhe8XSL7gQdXrgussVrIsEU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-6S3iLERkOaq_E766ewyaLQ-1; Wed, 26 Jul 2023 19:46:43 -0400
X-MC-Unique: 6S3iLERkOaq_E766ewyaLQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB6F78564EF;
	Wed, 26 Jul 2023 23:46:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7242492B01;
	Wed, 26 Jul 2023 23:46:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8097F1946A6E;
	Wed, 26 Jul 2023 23:46:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0EDBF1946A6C
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 23:33:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE0031121339; Wed, 26 Jul 2023 23:33:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E704D1121330
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 23:33:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB36E1C05AB1
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 23:33:00 +0000 (UTC)
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-P7YiDJyHOgeqEG5gqo6PNg-1; Wed, 26 Jul 2023 19:32:59 -0400
X-MC-Unique: P7YiDJyHOgeqEG5gqo6PNg-1
Received: by mail-vs1-f69.google.com with SMTP id
 ada2fe7eead31-44762a3d178so61039137.3
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 16:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690414379; x=1691019179;
 h=mime-version:user-agent:message-id:in-reply-to:date:references
 :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=NTp7hPOiEo8RsuNy0X/kowl3tsiOjf8HH084Hc7F5Q8=;
 b=O18aTIOi4Gtixcwx1PfjUshw2UjDvGGYJ8hRPqE1eAuIN4fGEM/kFuynPrnQM/941H
 Ts0EZqwR0ZE7vT6Hyl5SYg6mKNz4PsLalzOQpN6cRBLPAUcfdaf4tseJCUTWO3CmMf77
 dCG6lSivJTkgVkWbRQ7N84StG+tZQHOzXAkSY+4CTRlASaxJgVQEN67dnv1W+ux9ljBY
 tMq/o9eD7O46qGIwFDJxRRp5NnQfVqCAlJwY8yNlCqUA5GuLT1noq6A6BSqrgtlHhCnp
 SLtXDmHUBQaRj1g+SqX5toDNCaB52MQNMWEODWsl+FJaeP0qdJ2+dOMtRYHU4vnwlDUY
 BPaw==
X-Gm-Message-State: ABy/qLbuPP8+0wbp04DMVIN1vRIchGGlEDN2VuOiLu42UJ84wCg7m2M8
 QfI1/og7rE19aKYXMIeP9keurFMWYM7A5l6Cg7biRIqxniHeWpv0M50KQiJbJsgHllv/DRyyfJC
 9jZ+ifSahnJKuEpo=
X-Received: by 2002:a67:ebda:0:b0:446:e948:ebd4 with SMTP id
 y26-20020a67ebda000000b00446e948ebd4mr288252vso.21.1690414379021; 
 Wed, 26 Jul 2023 16:32:59 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEBWVn6oNGd3oafZjSwJyje7R1LaMoDnex87Y9R0nZDhsPnx78zVZxqLCqNQUhUZ02837TT9A==
X-Received: by 2002:a67:ebda:0:b0:446:e948:ebd4 with SMTP id
 y26-20020a67ebda000000b00446e948ebd4mr288240vso.21.1690414378735; 
 Wed, 26 Jul 2023 16:32:58 -0700 (PDT)
Received: from crash ([66.187.232.65]) by smtp.gmail.com with ESMTPSA id
 s25-20020a05620a16b900b00767ded911a3sm4703263qkj.116.2023.07.26.16.32.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jul 2023 16:32:57 -0700 (PDT)
From: Ken Raeburn <raeburn@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
 <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
Date: Wed, 26 Jul 2023 19:32:56 -0400
In-Reply-To: <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
 (Kenneth Raeburn's message of "Fri, 21 Jul 2023 21:59:05 -0400")
Message-ID: <87cz0e9rkn.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [vdo-devel] [PATCH v2 00/39] Add the dm-vdo
 deduplication and compression device mapper target.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


An offline discussion suggested maybe I should've gone into a little
more detail about how VDO uses its work queues.

VDO is sufficiently work-intensive that we found long ago that doing all
the work in one thread wouldn't keep up.

Our multithreaded design started many years ago and grew out of our
existing design for UDS (VDO's central deduplication index), which,
somewhat akin to partitioning and sharding in databases, does scanning
of the in-memory part of the "database" of values in some number (fixed
at startup) of threads, with the data and work divided up based on
certain bits of the hash value being looked up, and performs its I/O and
callbacks from certain other threads. We aren't splitting work to
multiple machines as database systems sometimes do, but to multiple
threads and potentially multiple NUMA nodes.

We try to optimize for keeping the busy case fast, even if it means
light usage loads don't perform quite as well as they could be made to.
We try to reduce instances of contention between threads by avoiding
locks when we can, preferring a fast queueing mechanism or loose
synchronization between threads. (We haven't kept to it strictly, but
we've mostly tried to.)

In VDO, at the first level, the work is split according to the
collection of data structures to be updated (e.g., recovery journal vs
disk block allocation vs block address mapping management).

For some data structures, we split the structures further based on
values of relevant bit-strings for the data structure in question (block
addresses, hash values). Currently we can split the work N ways for many
small values of N but it's hard to change N without restarting. The
processing of a read or write operation generally doesn't need to touch
more than one "zone" in any of these sets (or two, in a certain write
case).

Giving one thread exclusive access to the data structures means we can
do away with the locking. Of course, with so many different threads
owning data structures, we get a lot of queueing in exchange, but we
depend on a fast, nearly-lock-free MPSC queueing mechanism to keep that
reasonably efficient.

There's a little more to it in places where we need to preserve the
order of processing of multiple VIOs in a couple different sections of
the write path. So we do make some higher-level use of the fact that
we're adding work to queues with certain behavior, and not just turning
loose a bunch of threads to contend for a just-released mutex.

Some other bits of work like computing the hash value don't update any
other data structures, and not only would be amenable to kernel
workqueue conversion with concurrency greater than 1, but such a
conversion might open up some interesting options, like hashing on the
CPU or NUMA node where the data block is likely to reside in cache. But
for now, using one work management mechanism has been easier than two.

The experiment I referred to in my earlier email with using kernel
workqueues in VDO kept the same model of protecting data structures by
making them exclusive to specific threads (or in this case,
concurrency-1 workqueues) to serialize all access and using message
passing; it didn't change everything over to using mutexes instead.

I hope some of this helps. I'm happy to answer further questions.

Ken

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


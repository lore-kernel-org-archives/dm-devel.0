From: Shaohua Li <shli@kernel.org>
Subject: Re: Block regression since 3.1-rc3
Date: Sun, 9 Oct 2011 12:31:50 +0800
Message-ID: <CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
	<x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	<20111008161421.GA5743@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111008161421.GA5743@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>, Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

2011/10/9 Mike Snitzer <snitzer@redhat.com>:
> On Sat, Oct 08 2011 at =A07:02am -0400,
> Shaohua Li <shli@kernel.org> wrote:
>
>> Looks the dm request based flush logic is broken.
>>
>> saved_make_request_fn
>> =A0 __make_request
>> =A0 =A0 blk_insert_flush
>> but blk_insert_flush doesn't put the original request to list, inste=
ad, the
>> q->flush_rq is in list.
>> then
>> dm_request_fn
>> =A0 blk_peek_request
>> =A0 =A0 dm_prep_fn
>> =A0 =A0 =A0 clone_rq
>> =A0 map_request
>> =A0 =A0 blk_insert_cloned_request
>> so q->flush_rq is cloned, and get dispatched. but we can't clone q->=
flush_rq
>> and use it to do flush. map_request even could assign a different bl=
ockdev to
>> the cloned request.
>
> You haven't explained why cloning q->flush_rq is broken. =A0What is t=
he
> problem with map_request changing the blockdev? =A0For the purposes o=
f
> request-based DM the flush machinery has already managed the processi=
ng
> of the flush at the higher level request_queue.
hmm, looks I overlook the issue. cloned flush_rq has some problems but =
can
be fixed.
1. it doesn't set requet->bio, request->bio_tail
2. REQ_CLONE_MASK should set REQ_FLUSH_SEQ

> By the time request-based DM is cloning a flush request it really has=
 no
> need to reenter the flush machinery (even though Tejun wants it to --
> but in practice it doesn't buy us anything because we never stack
> request-based DM at the moment. =A0Instead it showcases how brittle t=
his
> path is).
if there is no benefit, we'd better not clone a flush request. Clearing=
 flush
bit and set it to cloned request is more clean and avoid unnecessary
overhead/complexity.

Thanks,
Shaohua

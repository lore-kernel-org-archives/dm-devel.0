From: Shaohua Li <shli@kernel.org>
Subject: Re: Block regression since 3.1-rc3
Date: Sun, 9 Oct 2011 15:16:39 +0800
Message-ID: <CANejiEV+Joc7qvWr1DF4cOR61GKy8MLX4TT4oWh7pxMkhb74Qg@mail.gmail.com>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
	<x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	<20111008161421.GA5743@redhat.com>
	<CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christophe Saout <christophe@saout.de>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

2011/10/9 Shaohua Li <shli@kernel.org>:
> 2011/10/9 Mike Snitzer <snitzer@redhat.com>:
>> On Sat, Oct 08 2011 at =A07:02am -0400,
>> Shaohua Li <shli@kernel.org> wrote:
>>
>>> Looks the dm request based flush logic is broken.
>>>
>>> saved_make_request_fn
>>> =A0 __make_request
>>> =A0 =A0 blk_insert_flush
>>> but blk_insert_flush doesn't put the original request to list, instead,=
 the
>>> q->flush_rq is in list.
>>> then
>>> dm_request_fn
>>> =A0 blk_peek_request
>>> =A0 =A0 dm_prep_fn
>>> =A0 =A0 =A0 clone_rq
>>> =A0 map_request
>>> =A0 =A0 blk_insert_cloned_request
>>> so q->flush_rq is cloned, and get dispatched. but we can't clone q->flu=
sh_rq
>>> and use it to do flush. map_request even could assign a different block=
dev to
>>> the cloned request.
>>
>> You haven't explained why cloning q->flush_rq is broken. =A0What is the
>> problem with map_request changing the blockdev? =A0For the purposes of
>> request-based DM the flush machinery has already managed the processing
>> of the flush at the higher level request_queue.
> hmm, looks I overlook the issue. cloned flush_rq has some problems but can
> be fixed.
> 1. it doesn't set requet->bio, request->bio_tail
> 2. REQ_CLONE_MASK should set REQ_FLUSH_SEQ
oh, don't need set REQ_FLUSH_SEQ, the low level queue will set it
anyway. sorry for
the noise. Jeff's patch looks ok then.

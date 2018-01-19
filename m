From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 09:23:35 -0700
Message-ID: <65a40164-275c-824b-64fc-b9e4cf781861@kernel.dk>
References: <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180119023212.GA25413@ming.t460p>
 <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
 <20180119072623.GB25369@ming.t460p>
 <047f68ec-f51b-190f-2f89-f413325c2540@kernel.dk>
 <20180119154047.GB14827@ming.t460p>
 <540e1239-c415-766b-d4ff-bb0b7f3517a7@kernel.dk>
 <20180119161336.GA22600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180119161336.GA22600@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On 1/19/18 9:13 AM, Mike Snitzer wrote:
> On Fri, Jan 19 2018 at 10:48am -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 1/19/18 8:40 AM, Ming Lei wrote:
>>>>>> Where does the dm STS_RESOURCE error usually come from - what's exact
>>>>>> resource are we running out of?
>>>>>
>>>>> It is from blk_get_request(underlying queue), see
>>>>> multipath_clone_and_map().
>>>>
>>>> That's what I thought. So for a low queue depth underlying queue, it's
>>>> quite possible that this situation can happen. Two potential solutions
>>>> I see:
>>>>
>>>> 1) As described earlier in this thread, having a mechanism for being
>>>>    notified when the scarce resource becomes available. It would not
>>>>    be hard to tap into the existing sbitmap wait queue for that.
>>>>
>>>> 2) Have dm set BLK_MQ_F_BLOCKING and just sleep on the resource
>>>>    allocation. I haven't read the dm code to know if this is a
>>>>    possibility or not.
> 
> Right, #2 is _not_ the way forward.  Historically request-based DM used
> its own mempool for requests, this was to be able to have some measure
> of control and resiliency in the face of low memory conditions that
> might be affecting the broader system.
> 
> Then Christoph switched over to adding per-request-data; which ushered
> in the use of blk_get_request using ATOMIC allocations.  I like the
> result of that line of development.  But taking the next step of setting
> BLK_MQ_F_BLOCKING is highly unfortunate (especially in that this
> dm-mpath.c code is common to old .request_fn and blk-mq, at least the
> call to blk_get_request is).  Ultimately dm-mpath like to avoid blocking
> for a request because for this dm-mpath device we have multiple queues
> to allocate from if need be (provided we have an active-active storage
> network topology).

If you can go to multiple devices, obviously it should not block on a
single device. That's only true for the case where you can only go to
one device, blocking at that point would probably be fine. Or if all
your paths are busy, then blocking would also be OK.

But it's a much larger change, and would entail changing more than just
the actual call to blk_get_request().

>> A simple test case would be to have a null_blk device with a queue depth
>> of one, and dm on top of that. Start a fio job that runs two jobs: one
>> that does IO to the underlying device, and one that does IO to the dm
>> device. If the job on the dm device runs substantially slower than the
>> one to the underlying device, then the problem isn't really fixed.
> 
> Not sure DM will allow the underlying device to be opened (due to
> master/slave ownership that is part of loading a DM table)?

There are many ways it could be setup - just partition the underlying
device then, and have one partition be part of the dm setup and the
other used directly.

>> That said, I'm fine with ensuring that we make forward progress always
>> first, and then we can come up with a proper solution to the issue. The
>> forward progress guarantee will be needed for the more rare failure
>> cases, like allocation failures. nvme needs that too, for instance, for
>> the discard range struct allocation.
> 
> Yeap, I'd be OK with that too.  We'd be better for revisted this and
> then have some time to develop the ultimate robust fix (#1, callback
> from above).

Yeah, we need the quick and dirty sooner, which just brings us back to
what we had before, essentially.

-- 
Jens Axboe

From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 09:27:46 -0700
Message-ID: <1f072086-533e-4b75-d0e3-9e621b2120d8@kernel.dk>
References: <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180119023212.GA25413@ming.t460p>
 <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
 <20180119072623.GB25369@ming.t460p>
 <047f68ec-f51b-190f-2f89-f413325c2540@kernel.dk>
 <20180119154047.GB14827@ming.t460p>
 <540e1239-c415-766b-d4ff-bb0b7f3517a7@kernel.dk>
 <20180119160518.GC14827@ming.t460p>
 <4a5c049f-0fab-bbaf-bfe2-eb5bca73f2c8@kernel.dk>
 <20180119162618.GD14827@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119162618.GD14827@ming.t460p>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On 1/19/18 9:26 AM, Ming Lei wrote:
> On Fri, Jan 19, 2018 at 09:19:24AM -0700, Jens Axboe wrote:
>> On 1/19/18 9:05 AM, Ming Lei wrote:
>>> On Fri, Jan 19, 2018 at 08:48:55AM -0700, Jens Axboe wrote:
>>>> On 1/19/18 8:40 AM, Ming Lei wrote:
>>>>>>>> Where does the dm STS_RESOURCE error usually come from - what's exact
>>>>>>>> resource are we running out of?
>>>>>>>
>>>>>>> It is from blk_get_request(underlying queue), see
>>>>>>> multipath_clone_and_map().
>>>>>>
>>>>>> That's what I thought. So for a low queue depth underlying queue, it's
>>>>>> quite possible that this situation can happen. Two potential solutions
>>>>>> I see:
>>>>>>
>>>>>> 1) As described earlier in this thread, having a mechanism for being
>>>>>>    notified when the scarce resource becomes available. It would not
>>>>>>    be hard to tap into the existing sbitmap wait queue for that.
>>>>>>
>>>>>> 2) Have dm set BLK_MQ_F_BLOCKING and just sleep on the resource
>>>>>>    allocation. I haven't read the dm code to know if this is a
>>>>>>    possibility or not.
>>>>>>
>>>>>> I'd probably prefer #1. It's a classic case of trying to get the
>>>>>> request, and if it fails, add ourselves to the sbitmap tag wait
>>>>>> queue head, retry, and bail if that also fails. Connecting the
>>>>>> scarce resource and the consumer is the only way to really fix
>>>>>> this, without bogus arbitrary delays.
>>>>>
>>>>> Right, as I have replied to Bart, using mod_delayed_work_on() with
>>>>> returning BLK_STS_NO_DEV_RESOURCE(or sort of name) for the scarce
>>>>> resource should fix this issue.
>>>>
>>>> It'll fix the forever stall, but it won't really fix it, as we'll slow
>>>> down the dm device by some random amount.
>>>>
>>>> A simple test case would be to have a null_blk device with a queue depth
>>>> of one, and dm on top of that. Start a fio job that runs two jobs: one
>>>> that does IO to the underlying device, and one that does IO to the dm
>>>> device. If the job on the dm device runs substantially slower than the
>>>> one to the underlying device, then the problem isn't really fixed.
>>>
>>> I remembered that I tried this test on scsi-debug & dm-mpath over scsi-debug,
>>> seems not observed this issue, could you explain a bit why IO over dm-mpath
>>> may be slower? Because both two IO contexts call same get_request(), and
>>> in theory dm-mpath should be a bit quicker since it uses direct issue for
>>> underlying queue, without io scheduler involved.
>>
>> Because if you lose the race for getting the request, you'll have some
>> arbitrary delay before trying again, potentially. Compared to the direct
> 
> But the restart still works, one request is completed, then the queue
> is return immediately because we use mod_delayed_work_on(0), so looks
> no such issue.

There are no pending requests for this case, nothing to restart the
queue. When you fail that blk_get_request(), you are idle, nothing
is pending.

-- 
Jens Axboe

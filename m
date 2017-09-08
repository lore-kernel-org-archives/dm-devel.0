From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm mpath: switch IO scheduler of underlying paths to
 "none" [was: Re: BFQ + dm-mpath]
Date: Fri, 8 Sep 2017 10:48:41 -0600
Message-ID: <113c15ac-75f5-ff5b-695d-920dc6d5f708@kernel.dk>
References: <1503611578.2899.69.camel@wdc.com>
 <AE77899A-0365-4C7C-91E4-5ACCC396B26B@linaro.org>
 <ED23C7AC-F202-40E3-8421-E714BF446399@linaro.org>
 <1504620914.4135.11.camel@wdc.com> <20170907155255.GA22848@redhat.com>
 <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
 <20170908164129.GA48286@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170908164129.GA48286@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/08/2017 10:41 AM, Mike Snitzer wrote:
> On Fri, Sep 08 2017 at  5:13P -0400,
> Paolo Valente <paolo.valente@linaro.org> wrote:
> 
>>
>>> Il giorno 07 set 2017, alle ore 17:52, Mike Snitzer <snitzer@redhat.com> ha scritto:
>>>
>>> On Tue, Sep 05 2017 at 10:15am -0400,
>>> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>>>
>>>> On Tue, 2017-09-05 at 09:56 +0200, Paolo Valente wrote:
>>>>> Ok, my suspects seem confirmed: the path dm_mq_queue_rq -> map_request
>>>>> -> setup_clone -> blk_rq_prep_clone creates a cloned request without
>>>>> invoking e->type->ops.mq.prepare_request for the target elevator e.
>>>>> The cloned request is therefore not initialized for the scheduler, but
>>>>> it is however inserted into the scheduler by
>>>>> blk_mq_sched_insert_request.  This seems an error for any scheduler
>>>>> that needs to initialize fields in the incoming request, or in general
>>>>> to take some preliminary action.
>>>>>
>>>>> Am I missing something here?
>>>>
>>>> (+Mike Snitzer)
>>>>
>>>> Mike, do you perhaps have the time to look into this memory leak?
>>>
>>> It isn't a memory leak, it is missing initialization in the case of
>>> cloned requests (if I'm understanding Paolo correctly).
>>>
>>
>> Exactly!
>>
>>> But cloned requests shouldn't be going through the scheduler.  Only the
>>> original requests should.
>>>
>>> Commit bd166ef18 ("blk-mq-sched: add framework for MQ capable IO
>>> schedulers") switched from blk_mq_insert_request() to
>>> blk_mq_sched_insert_request() and in doing so it opened dm-mpath up to
>>> this bug.
>>>
>>> Could be we need to take steps to ensure the block layer still
>>> supports bypassing the elevator by using direct insertion?
>>>
>>> Or blk_mq_sched_insert_request() needs updating to check if
>>> e->type->ops.mq.prepare_request were actually performed and to fallback
>>> to the !elevator case if not..
>>>
>>> Not sure on the fix, but I can look closer if others (like Jens or
>>> Paolo) don't have quicker suggestions.
>>>
>>
>> No quick suggestion from me :(
>>
>> Thanks for analyzing this bug,
> 
> Please see the following untested patch.  All
> testing/review/comments/acks appreciated.
> 
> I elected to use elevator_change() rather than fiddle with adding a new
> blk-mq elevator hook (e.g. ->request_prepared) to verify that each
> blk-mq elevator enabled request did in fact get prepared.
> 
> Bart, please test this patch and reply with your review/feedback.
> 
> Jens, if you're OK with this solution please reply with your Ack and
> I'll send it to Linus along with the rest of the handful of DM changes I
> have for 4.14.

I am not - we used to have this elevator change functionality from
inside the kernel, and finally got rid of it when certain drivers killed
it. I don't want to be bringing it back.

Sounds like we have two issues here. One is that we run into issues with
stacking IO schedulers, and the other is that we'd rather not have
multiple schedulers in play for a stacked setup.

Maybe it'd be cleaner to have the dm-mq side of things not insert
through the scheduler, but rather just FIFO on the target end?

-- 
Jens Axboe

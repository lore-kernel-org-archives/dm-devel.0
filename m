From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [dm-devel] [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Fri, 30 Jun 2017 22:59:37 -0600
Message-ID: <0aedc83b-17a0-14bd-bacd-e11e1b7c263c@kernel.dk>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
 <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
 <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk>
 <07ba10a8-6369-c1bc-dc9a-b550d9394c22@kernel.dk>
 <8f4ff428-e158-0df5-cf54-ae3cdea7ad1f@kernel.dk>
 <CACVXFVOW21vSOM0RGa-g0UFPRm91b9U16bruqXXYd=D+u7GKFQ@mail.gmail.com>
 <b462c167-53e9-11f8-583a-9984ef81fe0c@kernel.dk>
 <3729482c-fcca-2af5-4d05-7e44bcd71159@linux.vnet.ibm.com>
 <0759ff58-caa0-9e55-b5ac-6324d9ba521b@kernel.dk>
 <cf23ad83-5938-8256-5b32-f40c0d261508@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cf23ad83-5938-8256-5b32-f40c0d261508@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Ming Lei <tom.leiming@gmail.com>
Cc: linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 06/30/2017 10:17 PM, Jens Axboe wrote:
> On 06/30/2017 08:08 AM, Jens Axboe wrote:
>> On 06/30/2017 07:05 AM, Brian King wrote:
>>> On 06/29/2017 09:17 PM, Jens Axboe wrote:
>>>> On 06/29/2017 07:20 PM, Ming Lei wrote:
>>>>> On Fri, Jun 30, 2017 at 2:42 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 06/29/2017 10:00 AM, Jens Axboe wrote:
>>>>>>> On 06/29/2017 09:58 AM, Jens Axboe wrote:
>>>>>>>> On 06/29/2017 02:40 AM, Ming Lei wrote:
>>>>>>>>> On Thu, Jun 29, 2017 at 5:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>> On 06/28/2017 03:12 PM, Brian King wrote:
>>>>>>>>>>> This patch converts the in_flight counter in struct hd_struct from a
>>>>>>>>>>> pair of atomics to a pair of percpu counters. This eliminates a couple
>>>>>>>>>>> of atomics from the hot path. When running this on a Power system, to
>>>>>>>>>>> a single null_blk device with 80 submission queues, irq mode 0, with
>>>>>>>>>>> 80 fio jobs, I saw IOPs go from 1.5M IO/s to 11.4 IO/s.
>>>>>>>>>>
>>>>>>>>>> This has been done before, but I've never really liked it. The reason is
>>>>>>>>>> that it means that reading the part stat inflight count now has to
>>>>>>>>>> iterate over every possible CPU. Did you use partitions in your testing?
>>>>>>>>>> How many CPUs were configured? When I last tested this a few years ago
>>>>>>>>>> on even a quad core nehalem (which is notoriously shitty for cross-node
>>>>>>>>>> latencies), it was a net loss.
>>>>>>>>>
>>>>>>>>> One year ago, I saw null_blk's IOPS can be decreased to 10%
>>>>>>>>> of non-RQF_IO_STAT on a dual socket ARM64(each CPU has
>>>>>>>>> 96 cores, and dual numa nodes) too, the performance can be
>>>>>>>>> recovered basically if per numa-node counter is introduced and
>>>>>>>>> used in this case, but the patch was never posted out.
>>>>>>>>> If anyone is interested in that, I can rebase the patch on current
>>>>>>>>> block tree and post out. I guess the performance issue might be
>>>>>>>>> related with system cache coherency implementation more or less.
>>>>>>>>> This issue on ARM64 can be observed with the following userspace
>>>>>>>>> atomic counting test too:
>>>>>>>>>
>>>>>>>>>        http://kernel.ubuntu.com/~ming/test/cache/
>>>>>>>>
>>>>>>>> How well did the per-node thing work? Doesn't seem to me like it would
>>>>>>>> go far enough. And per CPU is too much. One potential improvement would
>>>>>>>> be to change the part_stat_read() to just loop online CPUs, instead of
>>>>>>>> all possible CPUs. When CPUs go on/offline, use that as the slow path to
>>>>>>>> ensure the stats are sane. Often there's a huge difference between
>>>>>>>> NR_CPUS configured and what the system has. As Brian states, RH ships
>>>>>>>> with 2048, while I doubt a lot of customers actually run that...
>>>>>>>>
>>>>>>>> Outside of coming up with a more clever data structure that is fully
>>>>>>>> CPU topology aware, one thing that could work is just having X cache
>>>>>>>> line separated read/write inflight counters per node, where X is some
>>>>>>>> suitable value (like 4). That prevents us from having cross node
>>>>>>>> traffic, and it also keeps the cross cpu traffic fairly low. That should
>>>>>>>> provide a nice balance between cost of incrementing the inflight
>>>>>>>> counting, and the cost of looping for reading it.
>>>>>>>>
>>>>>>>> And that brings me to the next part...
>>>>>>>>
>>>>>>>>>> I do agree that we should do something about it, and it's one of those
>>>>>>>>>> items I've highlighted in talks about blk-mq on pending issues to fix
>>>>>>>>>> up. It's just not great as it currently stands, but I don't think per
>>>>>>>>>> CPU counters is the right way to fix it, at least not for the inflight
>>>>>>>>>> counter.
>>>>>>>>>
>>>>>>>>> Yeah, it won't be a issue for non-mq path, and for blk-mq path, maybe
>>>>>>>>> we can use some blk-mq knowledge(tagset?) to figure out the
>>>>>>>>> 'in_flight' counter. I thought about it before, but never got a
>>>>>>>>> perfect solution, and looks it is a bit hard, :-)
>>>>>>>>
>>>>>>>> The tags are already a bit spread out, so it's worth a shot. That would
>>>>>>>> remove the need to do anything in the inc/dec path, as the tags already
>>>>>>>> do that. The inlight count could be easily retrieved with
>>>>>>>> sbitmap_weight(). The only issue here is that we need separate read and
>>>>>>>> write counters, and the weight would obviously only get us the total
>>>>>>>> count. But we can have a slower path for that, just iterate the tags and
>>>>>>>> count them. The fast path only cares about total count.
>>>>>>>>
>>>>>>>> Let me try that out real quick.
>>>>>>>
>>>>>>> Well, that only works for whole disk stats, of course... There's no way
>>>>>>> around iterating the tags and checking for this to truly work.
>>>>>>
>>>>>> Totally untested proof of concept for using the tags for this. I based
>>>>>> this on top of Brian's patch, so it includes his patch plus the
>>>>>> _double() stuff I did which is no longer really needed.
>>>>>>
>>>>>>
>>>>>> diff --git a/block/bio.c b/block/bio.c
>>>>>> index 9cf98b29588a..ec99d9ba0f33 100644
>>>>>> --- a/block/bio.c
>>>>>> +++ b/block/bio.c
>>>>>> @@ -1737,7 +1737,7 @@ void generic_start_io_acct(int rw, unsigned long sectors,
>>>>>>         part_round_stats(cpu, part);
>>>>>>         part_stat_inc(cpu, part, ios[rw]);
>>>>>>         part_stat_add(cpu, part, sectors[rw], sectors);
>>>>>> -       part_inc_in_flight(part, rw);
>>>>>> +       part_inc_in_flight(cpu, part, rw);
>>>>>>
>>>>>>         part_stat_unlock();
>>>>>>  }
>>>>>> @@ -1751,7 +1751,7 @@ void generic_end_io_acct(int rw, struct hd_struct *part,
>>>>>>
>>>>>>         part_stat_add(cpu, part, ticks[rw], duration);
>>>>>>         part_round_stats(cpu, part);
>>>>>> -       part_dec_in_flight(part, rw);
>>>>>> +       part_dec_in_flight(cpu, part, rw);
>>>>>>
>>>>>>         part_stat_unlock();
>>>>>>  }
>>>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>>>> index af393d5a9680..6ab2efbe940b 100644
>>>>>> --- a/block/blk-core.c
>>>>>> +++ b/block/blk-core.c
>>>>>> @@ -2434,8 +2434,13 @@ void blk_account_io_done(struct request *req)
>>>>>>
>>>>>>                 part_stat_inc(cpu, part, ios[rw]);
>>>>>>                 part_stat_add(cpu, part, ticks[rw], duration);
>>>>>> -               part_round_stats(cpu, part);
>>>>>> -               part_dec_in_flight(part, rw);
>>>>>> +
>>>>>> +               if (req->q->mq_ops)
>>>>>> +                       part_round_stats_mq(req->q, cpu, part);
>>>>>> +               else {
>>>>>> +                       part_round_stats(cpu, part);
>>>>>> +                       part_dec_in_flight(cpu, part, rw);
>>>>>> +               }
>>>>>>
>>>>>>                 hd_struct_put(part);
>>>>>>                 part_stat_unlock();
>>>>>> @@ -2492,8 +2497,12 @@ void blk_account_io_start(struct request *rq, bool new_io)
>>>>>>                         part = &rq->rq_disk->part0;
>>>>>>                         hd_struct_get(part);
>>>>>>                 }
>>>>>> -               part_round_stats(cpu, part);
>>>>>> -               part_inc_in_flight(part, rw);
>>>>>> +               if (rq->q->mq_ops)
>>>>>> +                       part_round_stats_mq(rq->q, cpu, part);
>>>>>> +               else {
>>>>>> +                       part_round_stats(cpu, part);
>>>>>> +                       part_inc_in_flight(cpu, part, rw);
>>>>>> +               }
>>>>>>                 rq->part = part;
>>>>>>         }
>>>>>>
>>>>>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>>>>>> index 99038830fb42..3b5eb2d4b964 100644
>>>>>> --- a/block/blk-merge.c
>>>>>> +++ b/block/blk-merge.c
>>>>>> @@ -634,7 +634,7 @@ static void blk_account_io_merge(struct request *req)
>>>>>>                 part = req->part;
>>>>>>
>>>>>>                 part_round_stats(cpu, part);
>>>>>> -               part_dec_in_flight(part, rq_data_dir(req));
>>>>>> +               part_dec_in_flight(cpu, part, rq_data_dir(req));
>>>>>>
>>>>>>                 hd_struct_put(part);
>>>>>>                 part_stat_unlock();
>>>>>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>>>>>> index d0be72ccb091..a7b897740c47 100644
>>>>>> --- a/block/blk-mq-tag.c
>>>>>> +++ b/block/blk-mq-tag.c
>>>>>> @@ -214,7 +214,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
>>>>>>                 bitnr += tags->nr_reserved_tags;
>>>>>>         rq = tags->rqs[bitnr];
>>>>>>
>>>>>> -       if (rq->q == hctx->queue)
>>>>>> +       if (rq && rq->q == hctx->queue)
>>>>>>                 iter_data->fn(hctx, rq, iter_data->data, reserved);
>>>>>>         return true;
>>>>>>  }
>>>>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>>>>> index 05dfa3f270ae..cad4d2c26285 100644
>>>>>> --- a/block/blk-mq.c
>>>>>> +++ b/block/blk-mq.c
>>>>>> @@ -43,6 +43,58 @@ static LIST_HEAD(all_q_list);
>>>>>>  static void blk_mq_poll_stats_start(struct request_queue *q);
>>>>>>  static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb);
>>>>>>
>>>>>> +struct mq_inflight {
>>>>>> +       struct hd_struct *part;
>>>>>> +       unsigned int inflight;
>>>>>> +};
>>>>>> +
>>>>>> +static void blk_mq_check_inflight(struct blk_mq_hw_ctx *hctx,
>>>>>> +                                 struct request *rq, void *priv,
>>>>>> +                                 bool reserved)
>>>>>> +{
>>>>>> +       struct mq_inflight *mi = priv;
>>>>>> +
>>>>>> +       if (rq->part == mi->part &&
>>>>>> +           test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
>>>>>> +               mi->inflight++;
>>>>>> +}
>>>>>> +
>>>>>> +unsigned long part_in_flight_mq(struct request_queue *q,
>>>>>> +                               struct hd_struct *part)
>>>>>> +{
>>>>>> +       struct mq_inflight mi = { .part = part, .inflight = 0 };
>>>>>> +
>>>>>> +       blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
>>>>>> +       return mi.inflight;
>>>>>> +}
>>>>>
>>>>> Compared with the totally percpu approach, this way might help 1:M or
>>>>> N:M mapping, but won't help 1:1 map(NVMe), when hctx is mapped to
>>>>> each CPU(especially there are huge hw queues on a big system), :-(
>>>>
>>>> Not disagreeing with that, without having some mechanism to only
>>>> loop queues that have pending requests. That would be similar to the
>>>> ctx_map for sw to hw queues. But I don't think that would be worthwhile
>>>> doing, I like your pnode approach better. However, I'm still not fully
>>>> convinced that one per node is enough to get the scalability we need.
>>>>
>>>> Would be great if Brian could re-test with your updated patch, so we
>>>> know how it works for him at least.
>>>
>>> I'll try running with both approaches today and see how they compare.
>>
>> Focus on Ming's, a variant of that is the most likely path forward,
>> imho. It'd be great to do a quick run on mine as well, just to establish
>> how it compares to mainline, though.
> 
> Here's a cleaned up series:
> 
> http://git.kernel.dk/cgit/linux-block/log/?h=mq-inflight
> 
> (it's against mainline for now, I will update it to be against
> for-4.13/block in a rebase).
> 
> One optimization on top of this I want to do is to only iterate once,
> even for a partition - pass in both parts, and increment two different
> counts. If we collapse the two part time stamps, then that's doable, and
> it means we only have to iterate once.
> 
> Essentially this series makes the inc/dec a noop, since we don't have to
> do anything. The reading is basically no worse than a cpu online
> iteration, since we never have more queues than online CPUs. That's an
> improvement over per-cpu for-each-possible loops. For a lot of cases,
> it's much less, since we have fewer queues than CPUs. I'll need an hour
> or two to hone this a bit more, but then it would be great if you can
> retest. I'll send out an email when that's done, it'll be some time over
> this weekend.

Did the double-read with one iteration change, it was pretty trivial:

http://git.kernel.dk/cgit/linux-block/commit/?h=mq-inflight&id=b841804f826df072f706ae86d0eb533342f0297a

And updated the branch here:

http://git.kernel.dk/cgit/linux-block/log/?h=mq-inflight

to include that, and be based on top of for-4.13/block. If you prefer just
pulling a branch, pull:

git://git.kernel.dk/linux-block mq-inflight

-- 
Jens Axboe

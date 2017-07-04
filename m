From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [dm-devel] [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Tue, 4 Jul 2017 09:20:57 +0800
Message-ID: <CACVXFVNQa_6Wrnx7Px1VRU+YuXqX+0y5SwyUvWGrv=ZrF_qPFg@mail.gmail.com>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk> <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
 <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk> <07ba10a8-6369-c1bc-dc9a-b550d9394c22@kernel.dk>
 <8f4ff428-e158-0df5-cf54-ae3cdea7ad1f@kernel.dk> <CACVXFVOW21vSOM0RGa-g0UFPRm91b9U16bruqXXYd=D+u7GKFQ@mail.gmail.com>
 <b462c167-53e9-11f8-583a-9984ef81fe0c@kernel.dk> <3729482c-fcca-2af5-4d05-7e44bcd71159@linux.vnet.ibm.com>
 <0759ff58-caa0-9e55-b5ac-6324d9ba521b@kernel.dk> <ca8ccbe7-beb6-bc0a-046c-b999004f0157@linux.vnet.ibm.com>
 <CACVXFVPpJBB5ieHg5nwyC4NF3Qd+W-TKJMFB-Qm4cVYK2B6M1w@mail.gmail.com>
 <599ba934-902d-d6ce-5a5a-9b32657b4a08@kernel.dk> <3053d21a-3619-498f-bf3c-921ee3e8c532@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <3053d21a-3619-498f-bf3c-921ee3e8c532@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Sat, Jul 1, 2017 at 10:18 AM, Brian King <brking@linux.vnet.ibm.com> wrote:
> On 06/30/2017 06:26 PM, Jens Axboe wrote:
>> On 06/30/2017 05:23 PM, Ming Lei wrote:
>>> Hi Bian,
>>>
>>> On Sat, Jul 1, 2017 at 2:33 AM, Brian King <brking@linux.vnet.ibm.com> wrote:
>>>> On 06/30/2017 09:08 AM, Jens Axboe wrote:
>>>>>>>> Compared with the totally percpu approach, this way might help 1:M or
>>>>>>>> N:M mapping, but won't help 1:1 map(NVMe), when hctx is mapped to
>>>>>>>> each CPU(especially there are huge hw queues on a big system), :-(
>>>>>>>
>>>>>>> Not disagreeing with that, without having some mechanism to only
>>>>>>> loop queues that have pending requests. That would be similar to the
>>>>>>> ctx_map for sw to hw queues. But I don't think that would be worthwhile
>>>>>>> doing, I like your pnode approach better. However, I'm still not fully
>>>>>>> convinced that one per node is enough to get the scalability we need.
>>>>>>>
>>>>>>> Would be great if Brian could re-test with your updated patch, so we
>>>>>>> know how it works for him at least.
>>>>>>
>>>>>> I'll try running with both approaches today and see how they compare.
>>>>>
>>>>> Focus on Ming's, a variant of that is the most likely path forward,
>>>>> imho. It'd be great to do a quick run on mine as well, just to establish
>>>>> how it compares to mainline, though.
>>>>
>>>> On my initial runs, the one from you Jens, appears to perform a bit better, although
>>>> both are a huge improvement from what I was seeing before.
>>>>
>>>> I ran 4k random reads using fio to nullblk in two configurations on my 20 core
>>>> system with 4 NUMA nodes and 4-way SMT, so 80 logical CPUs. I ran both 80 threads
>>>> to a single null_blk as well as 80 threads to 80 null_block devices, so one thread
>>>
>>> Could you share what the '80 null_block devices' is?  It means you
>>> create 80 null_blk
>>> devices? Or you create one null_blk and make its hw queue number as 80
>>> via module
>>> parameter of ''submit_queues"?
>>
>> That's a valid question, was going to ask that too. But I assumed that Brian
>> used submit_queues to set as many queues as he has logical CPUs in the system.
>>>
>>> I guess we should focus on multi-queue case since it is the normal way of NVMe.
>>>
>>>> per null_blk. This is what I saw on this machine:
>>>>
>>>> Using the Per node atomic change from Ming Lei
>>>> 1 null_blk, 80 threads
>>>> iops=9376.5K
>>>>
>>>> 80 null_blk, 1 thread
>>>> iops=9523.5K
>>>>
>>>>
>>>> Using the alternate patch from Jens using the tags
>>>> 1 null_blk, 80 threads
>>>> iops=9725.8K
>>>>
>>>> 80 null_blk, 1 thread
>>>> iops=9569.4K
>>>
>>> If 1 thread means single fio job, looks the number is too too high, that means
>>> one random IO can complete in about 0.1us(100ns) on single CPU, not sure if it
>>> is possible, :-)
>>
>> It means either 1 null_blk device, 80 threads running IO to it. Or 80 null_blk
>> devices, each with a thread running IO to it. See above, he details that it's
>> 80 threads on 80 devices for that case.
>
> Right. So the two modes I'm running in are:
>
> 1. 80 null_blk devices, each with one submit_queue, with one fio job per null_blk device,
>    so 80 threads total. 80 logical CPUs
> 2. 1 null_blk device, with 80 submit_queues, 80 fio jobs, 80 logical CPUs.
>
> In theory, the two should result in similar numbers.
>
> Here are the commands and fio configurations:
>
> Scenario #1
> modprobe null_blk submit_queues=80 nr_devices=1 irqmode=0
>
> FIO config:
> [global]
> buffered=0
> invalidate=1
> bs=4k
> iodepth=64
> numjobs=80
> group_reporting=1
> rw=randrw
> rwmixread=100
> rwmixwrite=0
> ioengine=libaio
> runtime=60
> time_based
>
> [job1]
> filename=/dev/nullb0
>
>
> Scenario #2
> modprobe null_blk submit_queues=1 nr_devices=80 irqmode=0
>
> FIO config
> [global]
> buffered=0
> invalidate=1
> bs=4k
> iodepth=64
> numjobs=1
> group_reporting=1
> rw=randrw
> rwmixread=100
> rwmixwrite=0
> ioengine=libaio
> runtime=60
> time_based
>
> [job1]
> filename=/dev/nullb0
> [job2]
> filename=/dev/nullb1
> [job3]
> filename=/dev/nullb2
> [job4]
> filename=/dev/nullb3
> [job5]
> filename=/dev/nullb4
> [job6]
> filename=/dev/nullb5
> [job7]
> filename=/dev/nullb6
> [job8]
> filename=/dev/nullb7
> [job9]
> filename=/dev/nullb8
> [job10]
> filename=/dev/nullb9
> [job11]
> filename=/dev/nullb10
> [job12]
> filename=/dev/nullb11
> [job13]
> filename=/dev/nullb12
> [job14]
> filename=/dev/nullb13
> [job15]
> filename=/dev/nullb14
> [job16]
> filename=/dev/nullb15
> [job17]
> filename=/dev/nullb16
> [job18]
> filename=/dev/nullb17
> [job19]
> filename=/dev/nullb18
> [job20]
> filename=/dev/nullb19
> [job21]
> filename=/dev/nullb20
> [job22]
> filename=/dev/nullb21
> [job23]
> filename=/dev/nullb22
> [job24]
> filename=/dev/nullb23
> [job25]
> filename=/dev/nullb24
> [job26]
> filename=/dev/nullb25
> [job27]
> filename=/dev/nullb26
> [job28]
> filename=/dev/nullb27
> [job29]
> filename=/dev/nullb28
> [job30]
> filename=/dev/nullb29
> [job31]
> filename=/dev/nullb30
> [job32]
> filename=/dev/nullb31
> [job33]
> filename=/dev/nullb32
> [job34]
> filename=/dev/nullb33
> [job35]
> filename=/dev/nullb34
> [job36]
> filename=/dev/nullb35
> [job37]
> filename=/dev/nullb36
> [job38]
> filename=/dev/nullb37
> [job39]
> filename=/dev/nullb38
> [job40]
> filename=/dev/nullb39
> [job41]
> filename=/dev/nullb40
> [job42]
> filename=/dev/nullb41
> [job43]
> filename=/dev/nullb42
> [job44]
> filename=/dev/nullb43
> [job45]
> filename=/dev/nullb44
> [job46]
> filename=/dev/nullb45
> [job47]
> filename=/dev/nullb46
> [job48]
> filename=/dev/nullb47
> [job49]
> filename=/dev/nullb48
> [job50]
> filename=/dev/nullb49
> [job51]
> filename=/dev/nullb50
> [job52]
> filename=/dev/nullb51
> [job53]
> filename=/dev/nullb52
> [job54]
> filename=/dev/nullb53
> [job55]
> filename=/dev/nullb54
> [job56]
> filename=/dev/nullb55
> [job57]
> filename=/dev/nullb56
> [job58]
> filename=/dev/nullb57
> [job59]
> filename=/dev/nullb58
> [job60]
> filename=/dev/nullb59
> [job61]
> filename=/dev/nullb60
> [job62]
> filename=/dev/nullb61
> [job63]
> filename=/dev/nullb62
> [job64]
> filename=/dev/nullb63
> [job65]
> filename=/dev/nullb64
> [job66]
> filename=/dev/nullb65
> [job67]
> filename=/dev/nullb66
> [job68]
> filename=/dev/nullb67
> [job69]
> filename=/dev/nullb68
> [job70]
> filename=/dev/nullb69
> [job71]
> filename=/dev/nullb70
> [job72]
> filename=/dev/nullb71
> [job73]
> filename=/dev/nullb72
> [job74]
> filename=/dev/nullb73
> [job75]
> filename=/dev/nullb74
> [job76]
> filename=/dev/nullb75
> [job77]
> filename=/dev/nullb76
> [job78]
> filename=/dev/nullb77
> [job79]
> filename=/dev/nullb78
> [job80]
> filename=/dev/nullb79

IMO it should be more reasonable to use single null_blk with 80 queues
via setting submit_queues as 80 than simply 80 null_blks.  So suggest to switch
to test 80 queues in your future test.


thanks,
Ming Lei

From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Fri, 30 Jun 2017 13:33:53 -0500
Message-ID: <ca8ccbe7-beb6-bc0a-046c-b999004f0157@linux.vnet.ibm.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <0759ff58-caa0-9e55-b5ac-6324d9ba521b@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>
Cc: linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 06/30/2017 09:08 AM, Jens Axboe wrote:
>>>> Compared with the totally percpu approach, this way might help 1:M or
>>>> N:M mapping, but won't help 1:1 map(NVMe), when hctx is mapped to
>>>> each CPU(especially there are huge hw queues on a big system), :-(
>>>
>>> Not disagreeing with that, without having some mechanism to only
>>> loop queues that have pending requests. That would be similar to the
>>> ctx_map for sw to hw queues. But I don't think that would be worthwhile
>>> doing, I like your pnode approach better. However, I'm still not fully
>>> convinced that one per node is enough to get the scalability we need.
>>>
>>> Would be great if Brian could re-test with your updated patch, so we
>>> know how it works for him at least.
>>
>> I'll try running with both approaches today and see how they compare.
> 
> Focus on Ming's, a variant of that is the most likely path forward,
> imho. It'd be great to do a quick run on mine as well, just to establish
> how it compares to mainline, though.

On my initial runs, the one from you Jens, appears to perform a bit better, although
both are a huge improvement from what I was seeing before.

I ran 4k random reads using fio to nullblk in two configurations on my 20 core
system with 4 NUMA nodes and 4-way SMT, so 80 logical CPUs. I ran both 80 threads
to a single null_blk as well as 80 threads to 80 null_block devices, so one thread
per null_blk. This is what I saw on this machine:

Using the Per node atomic change from Ming Lei
1 null_blk, 80 threads
iops=9376.5K

80 null_blk, 1 thread
iops=9523.5K


Using the alternate patch from Jens using the tags
1 null_blk, 80 threads
iops=9725.8K

80 null_blk, 1 thread
iops=9569.4K

Its interesting that with this change the single device, 80 threads scenario
actually got better than the 80 null_blk scenario. I'll try on a larger machine
as well. I've got a 32 core machine I can try this on too. Next week I can
work with our performance team on running this on a system with a bunch of nvme
devices so we can then test the disk partition case as well and see if there is
any noticeable overhead.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

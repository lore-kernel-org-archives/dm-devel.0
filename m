From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from atomic to
 percpu
Date: Thu, 29 Jun 2017 12:31:05 -0500
Message-ID: <dc7cf367-534d-d9fc-27b1-7cfd5edcb74c@linux.vnet.ibm.com>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
 <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
 <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk>
 <CACVXFVPvbJ1vD5-7aBeNQ6D6bDvhhd8aQQJ++vVZwJ5AM8TMjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CACVXFVPvbJ1vD5-7aBeNQ6D6bDvhhd8aQQJ++vVZwJ5AM8TMjg@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 06/29/2017 11:25 AM, Ming Lei wrote:
> On Thu, Jun 29, 2017 at 11:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 06/29/2017 02:40 AM, Ming Lei wrote:
>>> On Thu, Jun 29, 2017 at 5:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 06/28/2017 03:12 PM, Brian King wrote:
>>>>> This patch converts the in_flight counter in struct hd_struct from a
>>>>> pair of atomics to a pair of percpu counters. This eliminates a couple
>>>>> of atomics from the hot path. When running this on a Power system, to
>>>>> a single null_blk device with 80 submission queues, irq mode 0, with
>>>>> 80 fio jobs, I saw IOPs go from 1.5M IO/s to 11.4 IO/s.
>>>>
>>>> This has been done before, but I've never really liked it. The reason is
>>>> that it means that reading the part stat inflight count now has to
>>>> iterate over every possible CPU. Did you use partitions in your testing?
>>>> How many CPUs were configured? When I last tested this a few years ago
>>>> on even a quad core nehalem (which is notoriously shitty for cross-node
>>>> latencies), it was a net loss.
>>>
>>> One year ago, I saw null_blk's IOPS can be decreased to 10%
>>> of non-RQF_IO_STAT on a dual socket ARM64(each CPU has
>>> 96 cores, and dual numa nodes) too, the performance can be
>>> recovered basically if per numa-node counter is introduced and
>>> used in this case, but the patch was never posted out.
>>> If anyone is interested in that, I can rebase the patch on current
>>> block tree and post out. I guess the performance issue might be
>>> related with system cache coherency implementation more or less.
>>> This issue on ARM64 can be observed with the following userspace
>>> atomic counting test too:
>>>
>>>        http://kernel.ubuntu.com/~ming/test/cache/
>>
>> How well did the per-node thing work? Doesn't seem to me like it would
> 
> Last time, on ARM64, I remembered that the IOPS was basically recovered,
> but now I don't have a such machine to test. Could Brian test the attached patch
> to see if it works on big Power machine?
> 
> And the idea is simple, just make the atomic counter per-node.

I tried loading the patch and get an oops right away on boot. Haven't been able to 
debug anything yet. This is on top of an older kernel, so not sure if that is
the issue or not. I can try upstream and see if i have different results...

[-1;-1fUbuntu 16.04[-1;-1f.  .  .  .Unable to handle kernel paging request for data at address 0xc00031313a333532
Faulting instruction address: 0xc0000000002552c4
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA 
PowerNV
Modules linked in: dm_round_robin vmx_crypto powernv_rng leds_powernv powernv_op_panel led_class rng_core dm_multipath autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq multipath dm_mirror dm_region_hash dm_log cxlflash bnx2x mdio libcrc32c nvme nvme_core lpfc cxl crc_t10dif crct10dif_generic crct10dif_common
CPU: 9 PID: 3485 Comm: multipathd Not tainted 4.9.10-dirty #7
task: c000000fba0d0000 task.stack: c000000fb8a1c000
NIP: c0000000002552c4 LR: c000000000255274 CTR: 0000000000000000
REGS: c000000fb8a1f350 TRAP: 0300   Not tainted  (4.9.10-dirty)
MSR: 900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24028848  XER: 00000000
CFAR: c000000000008a60 DAR: c00031313a333532 DSISR: 40000000 SOFTE: 1 
GPR00: c0000000001f8980 c000000fb8a1f5d0 c000000000f24300 c000000fc4007c00 
GPR04: 00000000024000c0 c0000000002fc0ac 000000000000025d c000000fc5d346e0 
GPR08: 0000000fc50d6000 0000000000000000 c00031313a333532 c000000fbc836240 
GPR12: 0000000000002200 c00000000ff02400 00003fff79cfebf0 0000000000000000 
GPR16: 00000000c138fd03 000001003a12bf70 00003fff79ae75e0 00003fff79d269e8 
GPR20: 0000000000000001 00003fff79cfebf0 000001003a393aa0 00003fff79d067b8 
GPR24: 0000000000000000 c000000000b04948 000000000000a1ff c0000000002fc0ac 
GPR28: 00000000024000c0 0000000000000007 c0000000002fc0ac c000000fc4007c00 
NIP [c0000000002552c4] __kmalloc_track_caller+0x94/0x2f0
LR [c000000000255274] __kmalloc_track_caller+0x44/0x2f0
Call Trace:
[c000000fb8a1f5d0] [c000000fb8a1f610] 0xc000000fb8a1f610 (unreliable)
[c000000fb8a1f620] [c0000000001f8980] kstrdup+0x50/0xb0
[c000000fb8a1f660] [c0000000002fc0ac] __kernfs_new_node+0x4c/0x140
[c000000fb8a1f6b0] [c0000000002fd9f4] kernfs_new_node+0x34/0x80
[c000000fb8a1f6e0] [c000000000300708] kernfs_create_link+0x38/0xf0
[c000000fb8a1f720] [c000000000301cb8] sysfs_do_create_link_sd.isra.0+0xa8/0x160
[c000000fb8a1f770] [c00000000054a658] device_add+0x2b8/0x740
[c000000fb8a1f830] [c00000000054ae58] device_create_groups_vargs+0x178/0x190
[c000000fb8a1f890] [c0000000001fcd70] bdi_register+0x80/0x1d0
[c000000fb8a1f8c0] [c0000000001fd244] bdi_register_owner+0x44/0x80
[c000000fb8a1f940] [c000000000453bbc] device_add_disk+0x1cc/0x500
[c000000fb8a1f9f0] [c000000000764dec] dm_create+0x33c/0x5f0
[c000000fb8a1fa90] [c00000000076d9ac] dev_create+0x8c/0x3e0
[c000000fb8a1fb40] [c00000000076d1fc] ctl_ioctl+0x38c/0x580
[c000000fb8a1fd20] [c00000000076d410] dm_ctl_ioctl+0x20/0x30
[c000000fb8a1fd40] [c0000000002799ac] do_vfs_ioctl+0xcc/0x8f0
[c000000fb8a1fde0] [c00000000027a230] SyS_ioctl+0x60/0xc0
[c000000fb8a1fe30] [c00000000000bfe0] system_call+0x38/0xfc
Instruction dump:
39290008 7cc8482a e94d0030 e9230000 7ce95214 7d49502a e9270010 2faa0000 
419e007c 2fa90000 419e0074 e93f0022 <7f4a482a> 39200000 88ad023a 992d023a 
---[ end trace dcdac2d3f668d033 ]---



> 
>> go far enough. And per CPU is too much. One potential improvement would
>> be to change the part_stat_read() to just loop online CPUs, instead of
>> all possible CPUs. When CPUs go on/offline, use that as the slow path to
>> ensure the stats are sane. Often there's a huge difference between
>> NR_CPUS configured and what the system has. As Brian states, RH ships
>> with 2048, while I doubt a lot of customers actually run that...
> 
> One observation I saw on arm64 dual socket before is that atomic inc/dec on
> counter stored in local numa node is much cheaper than cross-node, that is
> why I tried the per-node counter. And wrt. in-flight atomic counter, both inc
> and dec should happen on CPUs belonging to same numa node in case of
> blk-mq.
> 
>>
>> Outside of coming up with a more clever data structure that is fully
>> CPU topology aware, one thing that could work is just having X cache
>> line separated read/write inflight counters per node, where X is some
>> suitable value (like 4). That prevents us from having cross node
>> traffic, and it also keeps the cross cpu traffic fairly low. That should
>> provide a nice balance between cost of incrementing the inflight
>> counting, and the cost of looping for reading it.
>>
>> And that brings me to the next part...
>>
>>>> I do agree that we should do something about it, and it's one of those
>>>> items I've highlighted in talks about blk-mq on pending issues to fix
>>>> up. It's just not great as it currently stands, but I don't think per
>>>> CPU counters is the right way to fix it, at least not for the inflight
>>>> counter.
>>>
>>> Yeah, it won't be a issue for non-mq path, and for blk-mq path, maybe
>>> we can use some blk-mq knowledge(tagset?) to figure out the
>>> 'in_flight' counter. I thought about it before, but never got a
>>> perfect solution, and looks it is a bit hard, :-)
>>
>> The tags are already a bit spread out, so it's worth a shot. That would
>> remove the need to do anything in the inc/dec path, as the tags already
>> do that. The inlight count could be easily retrieved with
>> sbitmap_weight(). The only issue here is that we need separate read and
>> write counters, and the weight would obviously only get us the total
>> count. But we can have a slower path for that, just iterate the tags and
>> count them. The fast path only cares about total count.
>>
>> Let me try that out real quick.
>>
>> --
>> Jens Axboe
>>
> 
> 
> 
> Thanks,
> Ming Lei
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

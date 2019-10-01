From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: Fix "dm kcopyd: Fix bug causing workqueue stalls"
 causes dead lock
Date: Tue, 1 Oct 2019 15:43:42 +0300
Message-ID: <e15bb4d9-d19b-f954-f71d-2985dd6e455a@arrikto.com>
References: <CAHSpA58dehDfou0ogCYnkziBt4oU5yo1SGHLhJb7vFKy9HhJPQ@mail.gmail.com>
	<db9a2b56-244b-1285-208c-14944f559f36@arrikto.com>
	<CAHSpA58H_Vuhub6Eqqmi2QZ2g4AAUX8KCCUMzMvyc87hDaVDKg@mail.gmail.com>
	<1b2b06a1-0b68-c265-e211-48273f26efaf@arrikto.com>
	<CAHSpA59rG7qhEDjtUUTNv5evyWHS_iTL0o8utRCr9MQvMDsEgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAHSpA59rG7qhEDjtUUTNv5evyWHS_iTL0o8utRCr9MQvMDsEgw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guruswamy Basavaiah <guru2018@gmail.com>
Cc: dm-devel@redhat.com, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, iliastsi@arrikto.com
List-Id: dm-devel.ids

On 10/1/19 3:27 PM, Guruswamy Basavaiah wrote:
> Hello Nikos,
>  Yes, issue is consistently reproducible with us, in a particular
> set-up and test case.
>  I will get the access to set-up next week, will try to test and let
> you know the results before end of next week.
> 

That sounds great!

Thanks a lot,
Nikos

> Guru
> 
> On Tue, 1 Oct 2019 at 17:42, Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>
>> On 9/29/19 5:36 PM, Guruswamy Basavaiah wrote:
>>> Hello Nikos,
>>>  Thanks for pointing out the lvcreate write lock.
>>>
>>> Guru
>>>
>>
>> Hi Guru,
>>
>> I have sent a fix for this and I have Cc-ed you.
>>
>> Is this something you are able to consistently reproduce? If so, it
>> would be great if you could also test the fix.
>>
>> Thanks,
>> Nikos
>>
>>>
>>> On Sat, 28 Sep 2019 at 01:03, Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>>>
>>>> On 9/27/19 4:19 PM, Guruswamy Basavaiah wrote:
>>>>> Hello,
>>>>>  We have drbd partition on top of lvm partition. when node having
>>>>> secondary drbd partition is coming up, large amount of data will be
>>>>> synced between primary to secondary drbd partitions.
>>>>>
>>>>> During this time, we see the drbd Sync(Resync) stops at some point.
>>>>> After 120 seconds we see hung-task-timeout warnings in the logs.(see
>>>>> at the end of this email)
>>>>>
>>>>> If i increase the cow_count semaphore value from 2048 to 8192 or
>>>>> remove the below patch, drbd sync works seamlessly.
>>>>>
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/?id=721b1d98fb517ae99ab3b757021cf81db41e67be
>>>>>
>>>>> I am not familiar with dm code, from hung task back traces what i
>>>>> understand is, when thread is trying to queue work to kcopyd, holding
>>>>> "&_origins_lock" and blocked on cow_count lock,
>>>>> jobs from kcopyd is trying to queue work to same kcopyd and blocked on
>>>>> "&_origins_lock" and dead lock.
>>>>>
>>>>
>>>> Hello Guruswamy,
>>>>
>>>> I am Cc-ing the maintainers, so they can be in the loop.
>>>>
>>>> I examined the attached logs and I believe the following happens:
>>>>
>>>> 1. DRBD issues a number of writes to the snapshot origin device. These
>>>>    writes cause COW, which is performed by kcopyd.
>>>>
>>>> 2. At some point DRBD reaches the cow_count semaphore limit (2048) and
>>>>    blocks in down(&s->cow_count), holding a read lock on _origins_lock.
>>>>
>>>> 3. Someone tries to create a new snapshot. This involves taking a write
>>>>    lock on _origins_lock, which blocks because DRBD at step (2) already
>>>>    holds a read lock on it. That's the blocked lvcreate at the end of
>>>>    the trace.
>>>>
>>>> 4. A COW operation, issued by step (1), completes and kcopyd runs
>>>>    dm-snapshot's completion callback, which tries to take a read lock on
>>>>    _origins_lock, before signaling the cow_count semaphore. This read
>>>>    lock blocks, the semaphore is never signaled and we have the deadlock
>>>>    you experienced.
>>>>
>>>> At first glance this seemed strange, because DRBD at step (2) holds a
>>>> read lock on _origins_lock, so taking another read lock should be
>>>> possible.
>>>>
>>>> But, if I am not missing something, the read-write semaphore
>>>> implementation gives priority to writers, meaning that as soon as a
>>>> writer tries to enter the critical section, the lvcreate in our case, no
>>>> readers will be allowed in until all writers have completed their work.
>>>>
>>>> That's what I believe is causing the deadlock you are experiencing.
>>>>
>>>> I will send a patch fixing this and I will let you now.
>>>>
>>>> Thanks,
>>>> Nikos
>>>>
>>>>> Below is the hung task back traces.
>>>>> Sep 24 12:08:48.974658 err CFPU-1 kernel: [  279.991760] INFO: task
>>>>> kworker/1:1:170 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:48.974658 err CFPU-1 kernel: [  279.998569]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:48.974658 err CFPU-1 kernel: [  280.006593] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:48.974658 info CFPU-1 kernel: [  280.014435] kworker/1:1
>>>>>    D ffffffff80e1db78     0   170      2 0x00100000
>>>>> Sep 24 12:08:48.974658 info CFPU-1 kernel: [  280.014482] Workqueue:
>>>>> kcopyd do_work [dm_mod]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487] Stack :
>>>>> 0000000000000000 0000000000000001 0003000300000000 80000007fde8bac8
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> 80000007fe759b00 0000000000000002 ffffffffc0285294 80000007f8d1ca00
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> ffffffffc027eda8 0000000000000001 ffffffff80b30000 0000000000000100
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> 8000000784c098c8 ffffffff80e1db78 80000007fe759b00 ffffffff80e204b8
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> 8000000788ef79c0 800000078505ba70 80000007fe759b00 00000001852b4620
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> ffffffffc0280000 80000007852b4620 80000007eebf5758 ffffffffc027edec
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> 0000000000000000 80000007852b4620 80000007835d8e80 ffffffffc027f38c
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> 8000000787ac0580 0000000000000001 80000007f8d1ca60 8000000785aeb080
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> 0000000000000000 0000000000000000 0000000000000200 ffffffffc0282488
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]
>>>>> 0000000000000200 80000007f8d1ca00 ffffffffc0280000 ffffffffc027db90
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014487]   ...
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014558] Call Trace:
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014570]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014580]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014590]
>>>>> [<ffffffff80e204b8>] __down_read+0xa8/0xf0
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014609]
>>>>> [<ffffffffc027edec>] do_origin.isra.13+0x44/0x110 [dm_snapshot]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014625]
>>>>> [<ffffffffc027f38c>] pending_complete+0x1ac/0x378 [dm_snapshot]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014642]
>>>>> [<ffffffffc0282488>] persistent_commit_exception+0x140/0x218
>>>>> [dm_snapshot]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014659]
>>>>> [<ffffffffc027db90>] copy_callback+0x108/0x1a0 [dm_snapshot]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014688]
>>>>> [<ffffffffc01eb6a4>] run_complete_job+0x8c/0x148 [dm_mod]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014724]
>>>>> [<ffffffffc01eaae8>] process_jobs+0xc8/0x1e0 [dm_mod]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014759]
>>>>> [<ffffffffc01eb1e0>] do_work+0xb8/0x110 [dm_mod]
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014783]
>>>>> [<ffffffff808b18e0>] process_one_work+0x190/0x480
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014791]
>>>>> [<ffffffff808b1d18>] worker_thread+0x148/0x580
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014801]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014811]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:48.974658 warn CFPU-1 kernel: [  280.014817]
>>>>> Sep 24 12:08:48.974658 err CFPU-1 kernel: [  280.015046] INFO: task
>>>>> drbd_r_r1:7772 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:48.974658 err CFPU-1 kernel: [  280.021766]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:48.974658 err CFPU-1 kernel: [  280.029781] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:48.982578 info CFPU-1 kernel: [  280.037637] drbd_r_r1
>>>>>    D ffffffff80e1db78     0  7772      2 0x00100002
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648] Stack :
>>>>> 00000000000207e8 ffffffff80b35530 8000000788e77860 8000000788e77860
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> 7fffffffffffffff 80000007f8d1cb28 8000000788e0a880 0000000000000002
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> ffffffff80e20000 80000007f9306480 00000000000207e8 ffffffff808dfe58
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> 80000007eebf5168 ffffffff80e1db78 0000000002411200 ffffffff80e208d8
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> 80000007eab5b440 ffffffff8097b25c 00000000000207a0 ffffffff808dfe58
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> 80000007f8d1ca00 ffffffff809ce014 80000007f9306000 0000000002011200
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> 7fffffffffffffff 80000007f8d1cb28 8000000788e0a880 0000000000000002
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> ffffffff80e20000 ffffffff80e1f8d8 80000007f8d1cb30 80000007f8d1cb30
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> 8000000788e0a880 00ffffff808db9e8 0000000000000000 80000007f8d1cb28
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]
>>>>> 80000007f9306480 ffffffffc02834d0 ffffffff808e0000 ffffffff808dfba4
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037648]   ...
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037774] Call Trace:
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037797]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037849]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037865]
>>>>> [<ffffffff80e208d8>] schedule_timeout+0x240/0x2a0
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037874]
>>>>> [<ffffffff80e1f8d8>] __down+0x90/0xd8
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037884]
>>>>> [<ffffffff808dfba4>] down+0x54/0x70
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037901]
>>>>> [<ffffffffc027da48>] start_copy+0x98/0xd8 [dm_snapshot]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037934]
>>>>> [<ffffffffc027e7d4>] __origin_write+0x184/0x2c0 [dm_snapshot]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.037968]
>>>>> [<ffffffffc027ee4c>] do_origin.isra.13+0xa4/0x110 [dm_snapshot]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038016]
>>>>> [<ffffffffc01dc2c0>] __map_bio+0xb0/0x258 [dm_mod]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038071]
>>>>> [<ffffffffc01deb94>] __split_and_process_bio+0x274/0x488 [dm_mod]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038126]
>>>>> [<ffffffffc01dee3c>] dm_make_request+0x94/0x128 [dm_mod]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038174]
>>>>> [<ffffffff80b3347c>] generic_make_request+0x114/0x290
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038238]
>>>>> [<ffffffffc0511090>] drbd_submit_peer_request+0x258/0x618 [drbd]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038337]
>>>>> [<ffffffffc05121f8>] receive_RSDataReply+0x3b8/0x770 [drbd]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038426]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:48.983234 warn CFPU-1 kernel: [  280.038526]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:48.985184 warn CFPU-1 kernel: [  280.038588]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:48.985184 warn CFPU-1 kernel: [  280.038604]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:48.985184 warn CFPU-1 kernel: [  280.038612]
>>>>> Sep 24 12:08:48.985184 err CFPU-1 kernel: [  280.038629] INFO: task
>>>>> drbd_r_r5:7910 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:48.990218 err CFPU-1 kernel: [  280.045351]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:48.998215 err CFPU-1 kernel: [  280.053372] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.006141 info CFPU-1 kernel: [  280.061248] drbd_r_r5
>>>>>    D ffffffff80e1db78     0  7910      2 0x00100002
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257] Stack :
>>>>> 0000000000000001 ffffffff80b35530 8000000788ef7950 8000000788ef7950
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> 8000000787936c00 0000000000000002 ffffffffc0285294 00000000000049ba
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> 0000000000000001 00000000000049ba 0000000000000001 ffffffff80b2aa90
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> 0000000000000001 ffffffff80e1db78 8000000787936c00 ffffffff80e204b8
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> 800000078785b9c0 80000007fde8bb30 8000000787936c00 0000000100000000
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> ffffffffc0280000 80000007eff43920 8000000788ca0198 ffffffffc027edec
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> 80000007eff43900 c000000001f5b080 80000007eff43920 ffffffffc01dc2c0
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> 80000007eb29bd80 0000000000000000 0000000002400000 80000007eff42900
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> 00000000000049ba ffffffff80b2abec 8000000788ef7a50 8000000788ef7a50
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]
>>>>> ffffffffc01dbad8 c000000001f5b080 c000000001f5b080 80000007eff43900
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061257]   ...
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061375] Call Trace:
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061392]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061435]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061445]
>>>>> [<ffffffff80e204b8>] __down_read+0xa8/0xf0
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061463]
>>>>> [<ffffffffc027edec>] do_origin.isra.13+0x44/0x110 [dm_snapshot]
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061509]
>>>>> [<ffffffffc01dc2c0>] __map_bio+0xb0/0x258 [dm_mod]
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061563]
>>>>> [<ffffffffc01deb94>] __split_and_process_bio+0x274/0x488 [dm_mod]
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061598]
>>>>> [<ffffffffc01dee3c>] dm_make_request+0x94/0x128 [dm_mod]
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061624]
>>>>> [<ffffffff80b3347c>] generic_make_request+0x114/0x290
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061674]
>>>>> [<ffffffffc0511090>] drbd_submit_peer_request+0x258/0x618 [drbd]
>>>>> Sep 24 12:08:49.006513 warn CFPU-1 kernel: [  280.061739]
>>>>> [<ffffffffc0512c78>] receive_Data+0x6c8/0x1368 [drbd]
>>>>> Sep 24 12:08:49.007987 warn CFPU-1 kernel: [  280.061816]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:49.007987 warn CFPU-1 kernel: [  280.061882]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:49.007987 warn CFPU-1 kernel: [  280.061922]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:49.007987 warn CFPU-1 kernel: [  280.061931]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:49.007987 warn CFPU-1 kernel: [  280.061937]
>>>>> Sep 24 12:08:49.007987 err CFPU-1 kernel: [  280.061948] INFO: task
>>>>> drbd_r_r6:7991 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:49.013584 err CFPU-1 kernel: [  280.068669]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:49.021541 err CFPU-1 kernel: [  280.076683] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.029370 info CFPU-1 kernel: [  280.084523] drbd_r_r6
>>>>>    D ffffffff80e1db78     0  7991      2 0x00100002
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532] Stack :
>>>>> 0000000000000001 ffffffff80b35530 800000078785b950 800000078785b950
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> 8000000787b79b00 0000000000000002 ffffffffc0285294 000000000000049a
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> 0000000000000001 000000000000049a 0000000000000001 ffffffff80b2aa90
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> 0000000000000001 ffffffff80e1db78 8000000787b79b00 ffffffff80e204b8
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> 800000078465b940 8000000788ef79c0 8000000787b79b00 0000000100000000
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> ffffffffc0280000 80000007e90d6c20 80000007878cf2d8 ffffffffc027edec
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> 80000007e90d6c00 c000000001fcc080 80000007e90d6c20 ffffffffc01dc2c0
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> 80000007f93fd900 0000000000000000 0000000002400000 80000007e90d6a00
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> 000000000000049a ffffffff80b2abec 800000078785ba50 800000078785ba50
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]
>>>>> ffffffffc01dbad8 c000000001fcc080 c000000001fcc080 80000007e90d6c00
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084532]   ...
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084610] Call Trace:
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084621]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084631]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084641]
>>>>> [<ffffffff80e204b8>] __down_read+0xa8/0xf0
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084659]
>>>>> [<ffffffffc027edec>] do_origin.isra.13+0x44/0x110 [dm_snapshot]
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084696]
>>>>> [<ffffffffc01dc2c0>] __map_bio+0xb0/0x258 [dm_mod]
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084729]
>>>>> [<ffffffffc01deb94>] __split_and_process_bio+0x274/0x488 [dm_mod]
>>>>> Sep 24 12:08:49.029567 warn CFPU-1 kernel: [  280.084777]
>>>>> [<ffffffffc01dee3c>] dm_make_request+0x94/0x128 [dm_mod]
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.084810]
>>>>> [<ffffffff80b3347c>] generic_make_request+0x114/0x290
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.084863]
>>>>> [<ffffffffc0511090>] drbd_submit_peer_request+0x258/0x618 [drbd]
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.084928]
>>>>> [<ffffffffc0512c78>] receive_Data+0x6c8/0x1368 [drbd]
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.084992]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.085057]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.085097]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.085106]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:49.031000 warn CFPU-1 kernel: [  280.085112]
>>>>> Sep 24 12:08:49.031000 err CFPU-1 kernel: [  280.085121] INFO: task
>>>>> drbd_r_r7:8046 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:49.036834 err CFPU-1 kernel: [  280.091854]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:49.044747 err CFPU-1 kernel: [  280.099876] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.056612 info CFPU-1 kernel: [  280.107739] drbd_r_r7
>>>>>    D ffffffff80e1db78     0  8046      2 0x00100000
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749] Stack :
>>>>> 0000000000000000 0000000000000010 ffffffff811b3a80 0000000000000000
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> 7fffffffffffffff 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> 8000000788fcfa98 0000000000000000 ffffffffc053baa8 ffffffff80be4360
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> ffffffffc0550000 ffffffff80e1db78 ffffffff81070660 ffffffff80e208d8
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> 8000000797a43600 ffffffff808c4878 80000007ff2f4100 0000000000000000
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> 80000007f93fdb40 0000000000000000 80000007ff007000 ffffffff81070660
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> 8000000788fcfa90 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> 8000000788fcfa98 ffffffff80e1e8a0 0000000100000000 8000000797a42880
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> ffffffff808c4b60 8000000788fcfaa0 8000000788fcfaa0 ffffffffc053baa8
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]
>>>>> ffffffff80be4360 ffffffff81cb4540 ffffffff81cb0000 80000007f93fdb40
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107749]   ...
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107821] Call Trace:
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107833]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107842]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107850]
>>>>> [<ffffffff80e208d8>] schedule_timeout+0x240/0x2a0
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107859]
>>>>> [<ffffffff80e1e8a0>] wait_for_common+0xd8/0x1b0
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107873]
>>>>> [<ffffffff808acc20>] call_usermodehelper_exec+0x110/0x188
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107932]
>>>>> [<ffffffffc053da3c>] drbd_khelper+0x1c4/0x310 [drbd]
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.107998]
>>>>> [<ffffffffc0500a14>] drbd_start_resync+0x534/0x968 [drbd]
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.108060]
>>>>> [<ffffffffc05037dc>] receive_sync_uuid+0x2d4/0x5a0 [drbd]
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.108124]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.108189]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.108229]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.108239]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:49.056612 warn CFPU-1 kernel: [  280.108245]
>>>>> Sep 24 12:08:49.056612 err CFPU-1 kernel: [  280.108471] INFO: task
>>>>> drbd_r_r8:8120 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:49.060085 err CFPU-1 kernel: [  280.115194]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:49.075924 err CFPU-1 kernel: [  280.123218] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.075924 info CFPU-1 kernel: [  280.131070] drbd_r_r8
>>>>>    D ffffffff80e1db78     0  8120      2 0x00100002
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083] Stack :
>>>>> 0000000000000000 0000000000000010 ffffffff811b3a80 0000000000000000
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> 7fffffffffffffff 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> 80000007851d3a98 0000000000000000 ffffffffc053baa8 ffffffff80be4360
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> ffffffffc0550000 ffffffff80e1db78 ffffffff81070660 ffffffff80e208d8
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> 80000007f96f6c00 ffffffff808c4878 80000007ff2f4100 0000000000000000
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> 80000007ee99f360 0000000000000000 80000007ff007000 ffffffff81070660
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> 80000007851d3a90 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> 80000007851d3a98 ffffffff80e1e8a0 0000000100000000 8000000784ba3600
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> ffffffff808c4b60 80000007851d3aa0 80000007851d3aa0 ffffffffc053baa8
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]
>>>>> ffffffff80be4360 ffffffff81cb4540 ffffffff81cb0000 80000007ee99f360
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131083]   ...
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131162] Call Trace:
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131174]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131183]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131195]
>>>>> [<ffffffff80e208d8>] schedule_timeout+0x240/0x2a0
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131204]
>>>>> [<ffffffff80e1e8a0>] wait_for_common+0xd8/0x1b0
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131216]
>>>>> [<ffffffff808acc20>] call_usermodehelper_exec+0x110/0x188
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131274]
>>>>> [<ffffffffc053da3c>] drbd_khelper+0x1c4/0x310 [drbd]
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131341]
>>>>> [<ffffffffc0500a14>] drbd_start_resync+0x534/0x968 [drbd]
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131403]
>>>>> [<ffffffffc05037dc>] receive_sync_uuid+0x2d4/0x5a0 [drbd]
>>>>> Sep 24 12:08:49.076256 warn CFPU-1 kernel: [  280.131482]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:49.077857 warn CFPU-1 kernel: [  280.131557]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:49.077857 warn CFPU-1 kernel: [  280.131597]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:49.077857 warn CFPU-1 kernel: [  280.131606]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:49.077857 warn CFPU-1 kernel: [  280.131612]
>>>>> Sep 24 12:08:49.077857 err CFPU-1 kernel: [  280.131641] INFO: task
>>>>> drbd_r_r9:8173 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:49.091245 err CFPU-1 kernel: [  280.138358]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:49.091245 err CFPU-1 kernel: [  280.146373] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.099067 info CFPU-1 kernel: [  280.154219] drbd_r_r9
>>>>>    D ffffffff80e1db78     0  8173      2 0x00100002
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229] Stack :
>>>>> 0000000000000000 0000000000000010 ffffffff811b3a80 0000000000000000
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> 7fffffffffffffff 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> 8000000783c9fa98 0000000000000000 ffffffffc053baa8 ffffffff80be4360
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> ffffffffc0550000 ffffffff80e1db78 ffffffff81070660 ffffffff80e208d8
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> 8000000797a45100 ffffffff808c4878 80000007ff2f4100 0000000000000000
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> 8000000788ca9d20 0000000000000000 80000007ff007000 ffffffff81070660
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> 8000000783c9fa90 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> 8000000783c9fa98 ffffffff80e1e8a0 0000000100000000 80000007843d4380
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> ffffffff808c4b60 8000000783c9faa0 8000000783c9faa0 ffffffffc053baa8
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]
>>>>> ffffffff80be4360 ffffffff81cb4540 ffffffff81cb0000 8000000788ca9d20
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154229]   ...
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154305] Call Trace:
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154315]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154325]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154333]
>>>>> [<ffffffff80e208d8>] schedule_timeout+0x240/0x2a0
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154342]
>>>>> [<ffffffff80e1e8a0>] wait_for_common+0xd8/0x1b0
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154354]
>>>>> [<ffffffff808acc20>] call_usermodehelper_exec+0x110/0x188
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154410]
>>>>> [<ffffffffc053da3c>] drbd_khelper+0x1c4/0x310 [drbd]
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154475]
>>>>> [<ffffffffc0500a14>] drbd_start_resync+0x534/0x968 [drbd]
>>>>> Sep 24 12:08:49.099314 warn CFPU-1 kernel: [  280.154540]
>>>>> [<ffffffffc05037dc>] receive_sync_uuid+0x2d4/0x5a0 [drbd]
>>>>> Sep 24 12:08:49.100714 warn CFPU-1 kernel: [  280.154612]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:49.100714 warn CFPU-1 kernel: [  280.154678]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:49.100714 warn CFPU-1 kernel: [  280.154717]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:49.100714 warn CFPU-1 kernel: [  280.154726]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:49.100714 warn CFPU-1 kernel: [  280.154732]
>>>>> Sep 24 12:08:49.100714 err CFPU-1 kernel: [  280.154742] INFO: task
>>>>> drbd_r_r10:8254 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:49.106539 err CFPU-1 kernel: [  280.161554]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:49.114430 err CFPU-1 kernel: [  280.169569] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.129749 info CFPU-1 kernel: [  280.177434] drbd_r_r10
>>>>>    D ffffffff80e1db78     0  8254      2 0x00100002
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445] Stack :
>>>>> 0000000000000000 0000000000000010 ffffffff811b3a80 0000000000000000
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> 7fffffffffffffff 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> 80000007846efa98 0000000000000000 ffffffffc053baa8 ffffffff80be4360
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> ffffffffc0550000 ffffffff80e1db78 ffffffff81070660 ffffffff80e208d8
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> 8000000784893600 ffffffff808c4878 80000007ff2f4100 0000000000000000
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> 80000007e9498180 0000000000000000 80000007ff007000 ffffffff81070660
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> 80000007846efa90 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> 80000007846efa98 ffffffff80e1e8a0 0000000100000000 8000000783cf8d80
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> ffffffff808c4b60 80000007846efaa0 80000007846efaa0 ffffffffc053baa8
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]
>>>>> ffffffff80be4360 ffffffff81cb4540 ffffffff81cb0000 80000007e9498180
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177445]   ...
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177517] Call Trace:
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177529]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177539]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177547]
>>>>> [<ffffffff80e208d8>] schedule_timeout+0x240/0x2a0
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177556]
>>>>> [<ffffffff80e1e8a0>] wait_for_common+0xd8/0x1b0
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177569]
>>>>> [<ffffffff808acc20>] call_usermodehelper_exec+0x110/0x188
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177631]
>>>>> [<ffffffffc053da3c>] drbd_khelper+0x1c4/0x310 [drbd]
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177697]
>>>>> [<ffffffffc0500a14>] drbd_start_resync+0x534/0x968 [drbd]
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177760]
>>>>> [<ffffffffc05037dc>] receive_sync_uuid+0x2d4/0x5a0 [drbd]
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177823]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177888]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177928]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177938]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:49.129749 warn CFPU-1 kernel: [  280.177944]
>>>>> Sep 24 12:08:49.129749 err CFPU-1 kernel: [  280.177960] INFO: task
>>>>> drbd_r_r11:8328 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:49.129749 err CFPU-1 kernel: [  280.184775]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:49.137674 err CFPU-1 kernel: [  280.192793] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.152797 info CFPU-1 kernel: [  280.200644] drbd_r_r11
>>>>>    D ffffffff80e1db78     0  8328      2 0x00100002
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654] Stack :
>>>>> 0000000000000000 0000000000000010 ffffffff811b3a80 0000000000000000
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> 7fffffffffffffff 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> 8000000783c5fa98 0000000000000000 ffffffffc053baa8 ffffffff80be4360
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> ffffffffc0550000 ffffffff80e1db78 ffffffff81070660 ffffffff80e208d8
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> 8000000787935100 ffffffff808c4878 80000007ff2f4100 0000000000000000
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> 80000007eebd25a0 0000000000000000 80000007ff007000 ffffffff81070660
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> 8000000783c5fa90 7fffffffffffffff 0000000000000000 0000000000000002
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> 8000000783c5fa98 ffffffff80e1e8a0 0000000100000000 800000078371de80
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> ffffffff808c4b60 8000000783c5faa0 8000000783c5faa0 ffffffffc053baa8
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]
>>>>> ffffffff80be4360 ffffffff81cb4540 ffffffff81cb0000 80000007eebd25a0
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200654]   ...
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200726] Call Trace:
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200739]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200749]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200757]
>>>>> [<ffffffff80e208d8>] schedule_timeout+0x240/0x2a0
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200766]
>>>>> [<ffffffff80e1e8a0>] wait_for_common+0xd8/0x1b0
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200778]
>>>>> [<ffffffff808acc20>] call_usermodehelper_exec+0x110/0x188
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200840]
>>>>> [<ffffffffc053da3c>] drbd_khelper+0x1c4/0x310 [drbd]
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200906]
>>>>> [<ffffffffc0500a14>] drbd_start_resync+0x534/0x968 [drbd]
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.200969]
>>>>> [<ffffffffc05037dc>] receive_sync_uuid+0x2d4/0x5a0 [drbd]
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.201032]
>>>>> [<ffffffffc0515b30>] drbd_receiver+0x210/0x420 [drbd]
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.201097]
>>>>> [<ffffffffc0523a3c>] drbd_thread_setup+0x74/0x1a8 [drbd]
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.201137]
>>>>> [<ffffffff808b813c>] kthread+0xdc/0xf8
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.201147]
>>>>> [<ffffffff8086bf28>] ret_from_kernel_thread+0x14/0x1c
>>>>> Sep 24 12:08:49.152797 warn CFPU-1 kernel: [  280.201153]
>>>>> Sep 24 12:08:49.152797 err CFPU-1 kernel: [  280.201183] INFO: task
>>>>> lvcreate:8585 blocked for more than 120 seconds.
>>>>> Sep 24 12:08:49.152797 err CFPU-1 kernel: [  280.207823]
>>>>> Tainted: P           O    4.4.184-octeon-distro.git-v2.96-4-rc-wnd #1
>>>>> Sep 24 12:08:49.160715 err CFPU-1 kernel: [  280.215860] "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>> Sep 24 12:08:49.168570 info CFPU-1 kernel: [  280.223704] lvcreate
>>>>>    D ffffffff80e1db78     0  8585   8582 0x00100000
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719] Stack :
>>>>> ffffffff809ce420 ffffffffc027e170 80000007ea05c720 ffffffff809ce014
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> ffffffffc0285294 ffffffffc0285290 8000000797bdb600 0000000000000002
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> ffffffffc02834d0 ffffffffc0280000 ffffffff809ce420 ffffffffc027e170
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> 80000007f9275d80 ffffffff80e1db78 ffffffffc0285294 ffffffff80e20584
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> 80000007fde8bb30 ffffffffc0285298 8000000797bdb600 0000000000000000
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> c00000000205a080 0000000000000000 c00000000205a080 80000007ea05c600
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> 80000007fec10300 ffffffffc027fd20 8000000780cb0150 ffffffffc01e2e9c
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> 00000008c0284b30 00000002c0284b30 80000007ea05c620 ffffffffc0280000
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> c00000000205a080 80000007ea05de00 0000000000000000 8000000780cb0150
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]
>>>>> 8000000780cb0160 0000000001d4c000 0000000000000000 8000000780cb0000
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223719]   ...
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223796] Call Trace:
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223805]
>>>>> [<ffffffff80e1d4a8>] __schedule+0x3c0/0xa58
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223814]
>>>>> [<ffffffff80e1db78>] schedule+0x38/0x98
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223824]
>>>>> [<ffffffff80e20584>] __down_write_nested+0x84/0xe8
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223843]
>>>>> [<ffffffffc027fd20>] snapshot_ctr+0x4d0/0x868 [dm_snapshot]
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223886]
>>>>> [<ffffffffc01e31d4>] dm_table_add_target+0x164/0x418 [dm_mod]
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223921]
>>>>> [<ffffffffc01e7bdc>] table_load+0x194/0x478 [dm_mod]
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.223956]
>>>>> [<ffffffffc01e8e1c>] ctl_ioctl+0x424/0x678 [dm_mod]
>>>>> Sep 24 12:08:49.168796 warn CFPU-1 kernel: [  280.224006]
>>>>> [<ffffffffc01e90a0>] dm_ctl_ioctl+0x30/0x40 [dm_mod]
>>>>> Sep 24 12:08:49.170177 warn CFPU-1 kernel: [  280.224040]
>>>>> [<ffffffff809f29cc>] do_vfs_ioctl+0x38c/0x5f8
>>>>> Sep 24 12:08:49.170177 warn CFPU-1 kernel: [  280.224049]
>>>>> [<ffffffff809f2c98>] SyS_ioctl+0x60/0xc8
>>>>> Sep 24 12:08:49.170177 warn CFPU-1 kernel: [  280.224059]
>>>>> [<ffffffff80879b70>] syscall_common+0x34/0x58
>>>>> Sep 24 12:08:49.170177 warn CFPU-1 kernel: [  280.224065]
>>>>>
>>>
>>>
>>>
>>> --
>>> Guruswamy Basavaiah
>>>
> 
> 
> 

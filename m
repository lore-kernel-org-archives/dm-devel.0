From: jing xia <jing.xia.mail@gmail.com>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Thu, 14 Jun 2018 15:18:58 +0800
Message-ID: <CAN=25QMQiJ7wvfvYvmZnEnrkeb-SA7_hPj+N2RnO8y-aVO8wOQ@mail.gmail.com>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com>
 <20180612212007.GA22717@redhat.com> <alpine.LRH.2.02.1806131001250.15845@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1806131001250.15845@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Thanks for your comment.

On Wed, Jun 13, 2018 at 10:02 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Tue, 12 Jun 2018, Mike Snitzer wrote:
>
>> On Tue, Jun 12 2018 at  4:03am -0400,
>> Jing Xia <jing.xia.mail@gmail.com> wrote:
>>
>> > Performance test in android reports that the phone sometimes gets
>> > hanged and shows black screen for about several minutes.The sysdump shows:
>> > 1. kswapd and other tasks who enter the direct-reclaim path are waiting
>> > on the dm_bufio_lock;
>>
>> Do you have an understanding of where they are waiting?  Is it in
>> dm_bufio_shrink_scan()?
>>
>> > 2. the task who gets the dm_bufio_lock is stalled for IO completions,
>> > the relevant stack trace as :
>> >
>> > PID: 22920  TASK: ffffffc0120f1a00  CPU: 1   COMMAND: "kworker/u8:2"
>> >  #0 [ffffffc0282af3d0] __switch_to at ffffff8008085e48
>> >  #1 [ffffffc0282af3f0] __schedule at ffffff8008850cc8
>> >  #2 [ffffffc0282af450] schedule at ffffff8008850f4c
>> >  #3 [ffffffc0282af470] schedule_timeout at ffffff8008853a0c
>> >  #4 [ffffffc0282af520] schedule_timeout_uninterruptible at ffffff8008853aa8
>> >  #5 [ffffffc0282af530] wait_iff_congested at ffffff8008181b40
>> >  #6 [ffffffc0282af5b0] shrink_inactive_list at ffffff8008177c80
>> >  #7 [ffffffc0282af680] shrink_lruvec at ffffff8008178510
>> >  #8 [ffffffc0282af790] mem_cgroup_shrink_node_zone at ffffff80081793bc
>> >  #9 [ffffffc0282af840] mem_cgroup_soft_limit_reclaim at ffffff80081b6040
>
> Please send the full stacktrace of this task.
>
> Then, we can see, why is it waiting here.
>
Please refer to:

PID: 22920  TASK: ffffffc0120f1a00  CPU: 1   COMMAND: "kworker/u8:2"
 #0 [ffffffc0282af3d0] __switch_to at ffffff8008085e48
 #1 [ffffffc0282af3f0] __schedule at ffffff8008850cc8
 #2 [ffffffc0282af450] schedule at ffffff8008850f4c
 #3 [ffffffc0282af470] schedule_timeout at ffffff8008853a0c
 #4 [ffffffc0282af520] schedule_timeout_uninterruptible at ffffff8008853aa8
 #5 [ffffffc0282af530] wait_iff_congested at ffffff8008181b40
 #6 [ffffffc0282af5b0] shrink_inactive_list at ffffff8008177c80
 #7 [ffffffc0282af680] shrink_lruvec at ffffff8008178510
 #8 [ffffffc0282af790] mem_cgroup_shrink_node_zone at ffffff80081793bc
 #9 [ffffffc0282af840] mem_cgroup_soft_limit_reclaim at ffffff80081b6040
#10 [ffffffc0282af8f0] do_try_to_free_pages at ffffff8008178b6c
#11 [ffffffc0282af990] try_to_free_pages at ffffff8008178f3c
#12 [ffffffc0282afa30] __perform_reclaim at ffffff8008169130
#13 [ffffffc0282afab0] __alloc_pages_nodemask at ffffff800816c9b8
#14 [ffffffc0282afbd0] __get_free_pages at ffffff800816cd6c
#15 [ffffffc0282afbe0] alloc_buffer at ffffff8008591a94
#16 [ffffffc0282afc20] __bufio_new at ffffff8008592e94
#17 [ffffffc0282afc70] dm_bufio_prefetch at ffffff8008593198
#18 [ffffffc0282afd20] verity_prefetch_io at ffffff8008598384
#19 [ffffffc0282afd70] process_one_work at ffffff80080b5b3c
#20 [ffffffc0282afdc0] worker_thread at ffffff80080b64fc
#21 [ffffffc0282afe20] kthread at ffffff80080bae34

> Mikulas

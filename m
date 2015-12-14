From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: corruption causing crash in __queue_work
Date: Mon, 14 Dec 2015 10:41:18 +0200
Message-ID: <566E80AE.7020502@kyup.com>
References: <566819D8.5090804@kyup.com>
 <20151209160803.GK30240@mtj.duckdns.org> <56685573.1020805@kyup.com>
 <20151209162744.GN30240@mtj.duckdns.org> <566945A2.1050208@kyup.com>
 <20151210152901.GR30240@mtj.duckdns.org> <566AF262.8050009@kyup.com>
 <20151211170805.GT30240@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151211170805.GT30240@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids



On 12/11/2015 07:08 PM, Tejun Heo wrote:
> Hello, Nikolay.
> 
> On Fri, Dec 11, 2015 at 05:57:22PM +0200, Nikolay Borisov wrote:
>> So I had a server with the patch just crash on me:
>>
>> Here is how the queue looks like:
>>  crash> struct workqueue_struct 0xffff8802420a4a00
>> struct workqueue_struct {
>>   pwqs = {
>>     next = 0xffff8802420a4c00,
>>     prev = 0xffff8802420a4a00
> 
> Hmmm... pwq list is already corrupt.  ->prev is terminated but ->next
> isn't.
> 
>>   },
>>   list = {
>>     next = 0xffff880351f9b210,
>>     prev = 0xdead000000200200
> 
> Followed by by 0xdead000000200200 which is likely from
> CONFIG_ILLEGAL_POINTER_VALUE.
> 
> ...
>>   name =
>> "dm-thin\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
>>   rcu = {
>>     next = 0xffff8802531c4c20,
>>     func = 0xffffffff810692e0 <rcu_free_wq>
> 
> and call_rcu_sched() already called.  The workqueue has already been
> destroyed.
> 
>>   },
>>   flags = 131082,
>>   cpu_pwqs = 0x0,
>>   numa_pwq_tbl = 0xffff8802420a4b10
>> }
>>
>> crash> rd 0xffff8802420a4b10 2 (the machine has 2 NUMA nodes hence the
>> '2' argument)
>> ffff8802420a4b10:  0000000000000000 0000000000000000   ................
>>
>> At the same time searching for 0xffff8802420a4a00 in the debug output
>> shows nothing IOW it seems that the numa_pwq_tbl is never installed for
>> this workqueue apparently:
>>
>> [root@smallvault8 ~]# grep 0xffff8802420a4a00 /var/log/messages
>>
>> Also dumping all the logs from the dmesg contained in the vmcore image I
>> find nothing and when I do the following correlation:
>> [root@smallvault8 ~]# grep \(null\) wq.log | wc -l
>> 1940
>> [root@smallvault8 ~]# wc -l wq.log
>> 1940 wq.log
>>
>> It seems what's happening is really just changing the numa_pwq_tbl on
>> workqueue creation i.e. it is never re-assigned. So at this point I
>> think it seems that there is a situation where the wqattr are not being
>> applied at all.
> 
> Hmmm... No idea why it didn't show up in the debug log but the only
> way a workqueue could be in the above state is either it got
> explicitly destroyed or somehow pwq refcnting is messed up, in both
> cases it should have shown up in the log.

Had another poke at the backtrace that is produced and here what the
delayed_work looks like:

crash> struct delayed_work ffff88036772c8c0
struct delayed_work {
  work = {
    data = {
      counter = 1537
    },
    entry = {
      next = 0xffff88036772c8c8,
      prev = 0xffff88036772c8c8
    },
    func = 0xffffffffa0211a30 <do_waker>
  },
  timer = {
    entry = {
      next = 0x0,
      prev = 0xdead000000200200
    },
    expires = 4349463655,
    base = 0xffff88047fd2d602,
    function = 0xffffffff8106da40 <delayed_work_timer_fn>,
    data = 18446612146934696128,
    slack = -1,
    start_pid = -1,
    start_site = 0x0,
    start_comm =
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
  },
  wq = 0xffff88030cf65400,
  cpu = 21
}

From this it seems that the timer is also cancelled/expired judging by
the values in timer -> entry. But then again in dm-thin the pool is
first suspended, which implies the following functions were called:

cancel_delayed_work(&pool->waker);
cancel_delayed_work(&pool->no_space_timeout);
flush_workqueue(pool->wq);

so at that point dm-thin's workqueue should be empty and it shouldn't be
possible to queue any more delayed work. But the crashdump clearly shows
that the opposite is happening. So far all of this points to a race
condition and inserting some sleeps after umount and after vgchange -Kan
(command to disable volume group and suspend, so the cancel_delayed_work
is invoked) seems to reduce the frequency of crashes, though it doesn't
eliminate them.

> 
> cc'ing dm people.  Is there any chance dm-think could be using
> workqueue after destroying it?
> 
> Thanks.
> 

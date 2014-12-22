From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Mon, 22 Dec 2014 16:28:29 +0100
Message-ID: <5498389D.6070909@acm.org>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
	<5491F906.1090004@kernel.dk>
	<20141217230622.GC15390@redhat.com> <54943714.2040704@acm.org>
	<20141219153801.GA8697@redhat.com>
	<20141219171438.GA6347@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141219171438.GA6347@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, hch@infradead.org, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On 12/19/14 18:14, Mike Snitzer wrote:
> On Fri, Dec 19 2014 at 10:38am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Fri, Dec 19 2014 at  9:32am -0500,
>> Bart Van Assche <bvanassche@acm.org> wrote:
>>
>>> On 12/18/14 00:06, Mike Snitzer wrote:
>>>> So if you know someone with relevant blk-mq hardware who might benefit
>>>> from blk-mq multipathing please point them at this code and have them
>>>> report back!
>>>
>>> Hello Mike,
>>>
>>> Great to see that you are working on blk-mq multipathing. Unfortunately
>>> a test with the SRP initiator and your dm-for-3.20-blk-mq tree merged
>>> with Linus' latest tree was not successful. This is what was reported
>>> when I tried to start multipathd (without call trace, followed by a
>>> hard lockup):
>>>
>>> =========================================================
>>> [ INFO: possible irq lock inversion dependency detected ]
>>> 3.18.0-debug+ #1 Tainted: G        W     
>>> ---------------------------------------------------------
>>> kdmwork-253:0/5347 just changed the state of lock:
>>>  (&(&m->lock)->rlock){+.....}, at: [<ffffffffa080eb80>] __multipath_map.isra.15+0x40/0x1f0 [dm_multipath]
>>> but this lock was taken by another, HARDIRQ-safe lock in the past:
>>>  (&(&q->__queue_lock)->rlock){-.-...}
>>>  
>>> and interrupts could create inverse lock ordering between them.
>>>  
>>> other info that might help us debug this:
>>>  Possible interrupt unsafe locking scenario:
>>
>> This "dm: submit stacked requests in irq enabled context" commit
>> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20-blk-mq&id=1844ba7e2e013fa38c45d646248c517eb363e26c
>>
>> changed the locking needed in the multipath target.  I altered
>> __multipath_map but didn't audit elsewhere.  I'll work through it.
> 
> Hi Bart,
> 
> This patch silences the lockdep inversion splat on my testbed, but I'd
> really appreciate it if you could see if it works for you since you hit
> an actual hang:
> 
> [ ... ]

Hello Mike,

Good news: with this patch my standard SRP multipath test ran fine for
several hours, after which I stopped the test. The only issue I hit
during this test is the one mentioned on
https://lkml.org/lkml/2014/10/29/523 but that's a bug in the e1000
driver that is not related to multipath.

Bart.

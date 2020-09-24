From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-raid: stack limits instead of overwriting
 them.
Date: Thu, 24 Sep 2020 12:58:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2009241250280.28814@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh87GLea=7_4qGuPhMj0WKnB-596HzkKQDafLirHiBpSzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh87GLea=7_4qGuPhMj0WKnB-596HzkKQDafLirHiBpSzQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Thu, 24 Sep 2020, John Dorminy wrote:

> I don't understand how this works...
> 
> Can chunk_size_bytes be 0? If not, how is discard_granularity being set to 0?

Yes - chunk_size_bytes is 0 here.

> I think also limits is local to the ti in question here, initialized
> by blk_set_stacking_limits() via dm-table.c, and therefore has only
> default values and not anything to do with the underlying queue. So

In dm_calculate_queue_limits, there's
	blk_set_stacking_limits(limits);
- that will initialize the default limits (discard_granularity == 0)

Then, there's:
	ti->type->iterate_devices(ti, dm_set_device_limits, &ti_limits);
- that will unify limits for all RAID legs (in this case, it sets 
discard_granularity == 1024)

Then, there's
	if (ti->type->io_hints) ti->type->io_hints(ti, &ti_limits);
And that will incorrectly overwrite discard_granularity with zero.

> setting discard_granularity=max(discard_granularity, chunk_size_bytes)
> doesn't seem like it should be working, unless I'm not understanding
> what it's there for...
> 
> And shouldn't melding in the target's desired io_hints into the
> existing queue limits be happening in blk_stack_limits() instead?
> (Also, it does lcm_not_zero() for stacking granularity, instead of
> max()...)

Well, you can add blk_stack_limits to raid_io_hints and use it to stack 
the limits, but that would just complicate that function.

Mikulas

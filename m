From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH] dm-writecache: fix a crash when unloading
Date: Wed, 12 Feb 2020 11:41:46 -0500
Message-ID: <CAMeeMh9NyhQAEVOhHMTOBMxXM4Tt=_k5UwY_M2uXZmwwsRBhZw@mail.gmail.com>
References: <alpine.LRH.2.02.2002121015310.19039@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2002121015310.19039@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Corey Marthaler <cmarthal@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Also, the test "!dm_suspended(wc->ti)" in writecache_writeback is not
> sufficient, because dm_suspended returns zero while writecache_suspend is
> in progress. We add a variable wc->suspending and set it in
> writecache_suspend. Without this variable, drain_workqueue would spit
> warnings:
> workqueue writecache-writeback: drain_workqueue() isn't complete after 10 tries
> workqueue writecache-writeback: drain_workqueue() isn't complete after 100 tries
> workqueue writecache-writeback: drain_workqueue() isn't complete after 200 tries
> workqueue writecache-writeback: drain_workqueue() isn't complete after 300 tries
> workqueue writecache-writeback: drain_workqueue() isn't complete after 400 tries

This I don't understand.

writecache_suspend is a postsuspend function.

Here's a partial call chain representing suspending a table:
dm_suspend()
  __dm_suspend(...,DMF_SUSPENDED)
    ...do suspend stuff...
    set_bit(dmf_suspended_flags, ...) // DMF_SUSPENDED
  dm_table_postsuspend_targets()
    // for each segment, call that segments' postsuspend function

And dm_suspended() calls dm_suspended_md() which checks whether
DMF_SUSPENDED is set.

So, by the time the targets' postsuspend function gets called,
dm_suspended() should be returning 1, and the existing conditional
should be preventing requeuing. So I worry there's something deeper
going on here...

Additionally, I don't think wc->suspending is multithread safe -- it's
getting set on one thread and getting checked on another thread,
right? So the CPU running the workqueue thread is free to read
wc->suspending and then later on write it to the value it read, even
if the other thread has attempted to write a different value in
between.

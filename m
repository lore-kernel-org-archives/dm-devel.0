From: Tejun Heo <tj@kernel.org>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of the verity
 target)
Date: Thu, 8 Mar 2012 16:51:18 -0800
Message-ID: <20120309005118.GC2968@htj.dyndns.org>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
 <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
 <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
 <20120308231521.GA2968@htj.dyndns.org>
 <20120308153048.4a80de34.akpm@linux-foundation.org>
 <20120309003309.GB2968@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120309003309.GB2968@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>, Steffen Klassert <steffen.klassert@secunet.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: dm-devel.ids

Adding a bit..

On Thu, Mar 08, 2012 at 04:33:09PM -0800, Tejun Heo wrote:
> ISTR there was something already broken about having specific CPU
> assumption w/ workqueue even before cmwq when using queue_work_on()
> unless it was explicitly synchronizing using cpu hotplug callback.
> Hmmm... what was it... I think it was that there was no protection
> against queueing on workqueue on dead CPU and workqueue was flushed
> only once during cpu shutdown meaning that queue_work_on() or
> requeueing work items could end up queued on a workqueue of a dead
> CPU.

I think the crux of the problem is that we didn't have the interface
to indicate the intention of workqueue users.  Per-cpu workqueues were
the normal ones and the per-cpuness is used both as optimization
(local queueing is much cheaper and a work item is likely to access
the same stuff its queuer was accessing) and pinning.  Single-threaded
workqueues were used for both non-reentrancy and resource
optimization.

For the short term, the easiest fix would be adding flush_work_sync()
from cpu hotplug callback for the pinned ones.  For the longer term, I
think the most natural fix would be making work items queued with
explicit queue_work_on() handled differently and adding debug code to
enforce it.

Thanks.

-- 
tejun

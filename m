From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH] dm-ioband-v1.12.2: I/O bandwidth controller
Date: Thu, 30 Jul 2009 17:53:21 +0900 (JST)
Message-ID: <20090730.175321.193708040.ryov@valinux.co.jp>
References: <20090730.115454.226775179.ryov@valinux.co.jp>
	<20090730054204.GA11291@verge.net.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20090730054204.GA11291@verge.net.au>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: horms@verge.net.au
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Simon,

> Hi Tsuruta-san,
> 
> have you run sparse over this code? There seem to be a few interesting
> warnings generated (and some at the top noise too).

Thank you for your comment.
I'll do sparse every time from now on.
 
> $ make C=1 CF="-D__CHECK_ENDIAN__"
> [snip]
> include/trace/events/dm-ioband.h:9:1: warning: symbol 'ftrace_raw_output_ioband_hold_urgent_bio' was not declared. Should it be static?
[snip ftrace warnings]

> drivers/md/dm-ioband-ctl.c:178:2: warning: context problem in 'suspend_ioband_device': '_spin_unlock_irqrestore' expected different context
> drivers/md/dm-ioband-ctl.c:178:2:    context 'lock': wanted >= 1, got 0
> drivers/md/dm-ioband-ctl.c:600:3: warning: context imbalance in 'prevent_burst_bios': unexpected unlock
> drivers/md/dm-ioband-ctl.c:600:3:    context '<noident>': wanted 0, got -1
> drivers/md/dm-ioband-ctl.c:816:3: warning: context imbalance in 'ioband_map': __context__ statement expected different context
> drivers/md/dm-ioband-ctl.c:816:3:    context '<noident>': wanted >= 0, got -1
> drivers/md/dm-ioband-rangebw.c:287:4: warning: context imbalance in 'range_bw_queue_full': __context__ statement expected different context
> drivers/md/dm-ioband-rangebw.c:287:4:    context '<noident>': wanted >= 0, got -1

These imbalances are not warned by the latest sparse command retrieved
from the git repository, and actually they are not imbalanced.

> drivers/md/dm-ioband-rangebw.c:592:6: warning: symbol 'range_bw_timeover' was not declared. Should it be static?
> drivers/md/dm-ioband-rangebw.c:210: warning: 'io_mode' may be used uninitialized in this function

I'll fix these warnings and post the update soon.

Thanks,
Ryo Tsuruta

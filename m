From: Dave Chinner <david@fromorbit.com>
Subject: Re: A review of dm-writeboost
Date: Wed, 16 Oct 2013 17:07:50 +1100
Message-ID: <20131016060750.GE4446@dastard>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
 <52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
 <alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Akira Hayakawa <ruby.wktk@gmail.com>, tj@kernel.org, dm-devel@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, xfs@oss.sgi.com, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com
List-Id: dm-devel.ids

[cc xfs@oss.sgi.com]

On Tue, Oct 15, 2013 at 08:01:45PM -0400, Mikulas Patocka wrote:
> On Mon, 14 Oct 2013, Akira Hayakawa wrote:
> > But, XFS stalls ...
> > -------------------
> > For testing,
> > I manually turns `blockup` to 1
> > when compiling Ruby is in progress
> > on XFS on a writeboost device.
> > As soon as I do it,
> > XFS starts to dump error message 
> > like "metadata I/O error: ... ("xlog_iodone") error ..."
> > and after few seconds it then starts to dump
> > like "BUG: soft lockup -CPU#3 stuck for 22s!".
> > The system stalls and doesn't accept the keyboard.
> > 
> > I think this behavior is caused by
> > the device always returning -EIO after turning 
> > the variable to 1.
> > But why XFS goes stalling on I/O error?
> 
> Because it is bloated and buggy.

How did I know you'd take that cheap shot, Mikulas? You are so
predictable...

> We have bug 924301 for XFS crash on I/O 
> error...

Which is a problem with memory corruption after filling a dm
snapshot volume to 100% and shortly after XFS has shut down the
kernel panics from memory corruption. Can't be reproduced without
filling the dm-snapshot volume to 100%, can't be reproduced with any
other filesystem. Crashes are also occurring randomly in printk and
the worker thread infrastructure. Memory and list poisoning clearly
indicates worker thread lists have freed objects on them. There are
lockdep messages from the DM snapshot code, etc.

There's actually very little to point at XFS problems other than the
first hang that was reported where XFS was stuck in a tight loop due
to memory corruption.  It reminds me of a very similar bug report
and triage we went through last week:

http://oss.sgi.com/pipermail/xfs/2013-October/030681.html

Further analysis and bisects pointed to the zram driver being buggy,
not XFS:

http://oss.sgi.com/pipermail/xfs/2013-October/030707.html

XFS has historically exposing bugs in block device drivers that no
other filesystem exposes, and so when a new block device driver gets
tested with XFS and we start seeing memory corruption symptoms, it's
a fair bet that it's not XFS that is causing it....

Just sayin'.

---

Akira, can you please post the entire set of messages you are
getting when XFS showing problems? That way I can try to confirm
whether it's a regression in XFS or something else.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

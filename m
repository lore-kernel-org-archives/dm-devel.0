From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Thu, 10 Mar 2011 16:04:12 +1100
Message-ID: <20110310050412.GZ15097@dastard>
References: <4D766199.4010307@gmail.com>
 <20110308174308.GP10767@agk-dp.fab.redhat.com>
 <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
 <20110309142325.GA11312@agk-dp.fab.redhat.com>
 <20110309213629.GV15097@dastard>
 <20110309214927.GI11312@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110309214927.GI11312@agk-dp.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Wendy Cheng <s.wendy.cheng@gmail.com>, Ric Wheeler <ricwheeler@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Karel
List-Id: dm-devel.ids

On Wed, Mar 09, 2011 at 09:49:28PM +0000, Alasdair G Kergon wrote:
> On Thu, Mar 10, 2011 at 08:36:29AM +1100, Dave Chinner wrote:
> > I can see how this would be advantageous from a management
> > perspective for growing LVM pools, but I can see quite a few
> > problems with extending that to automatically growing filesystems
> > above LVM. e.g. The LUN resizes, the PV is expanded, the VG is
> > expanded, but which LV in the VG is going to make use the new space?
>  
> You'd handle that by configuration settings under sysadmin control.

So you have to set it up ahead of time, and then remember that you
have set it up to automatically expand LV X when PV Y expands
because device Z was expanded.

> There are plenty of situations where there would be an 'obvious' LV 
> to extend.

Sure, but that's the easy case. My concern is always the hard cases
- what to do when there isn't an obvious LV to expand, or you want
an LV that isn't the obvious or configured LV to expand when the
PV is grown, or you just want to grow the PV ready to add new LVs
rather than expand an LV....

> > Similarly, you can't safely shrink a filesystem from the bottom up -
> > the filesystem has to empty the space first before it is safe to
> > shrink it.  How would you handle this from a bottom-up driven
> > change?
>  
> Obviously there are limits, and passing a message "Prepare to
> be made smaller by X" up the stack probably isn't very feasible.

Agreed, especially as it can take hours of IO before an "ok to be
made smaller now " message can be sent or the attempt to shrink the
filesystem fails...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

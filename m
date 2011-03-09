From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Thu, 10 Mar 2011 08:36:29 +1100
Message-ID: <20110309213629.GV15097@dastard>
References: <4D766199.4010307@gmail.com>
 <20110308174308.GP10767@agk-dp.fab.redhat.com>
 <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
 <20110309142325.GA11312@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110309142325.GA11312@agk-dp.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Wendy Cheng <s.wendy.cheng@gmail.com>, Ric Wheeler <ricwheeler@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel
List-Id: dm-devel.ids

On Wed, Mar 09, 2011 at 02:23:26PM +0000, Alasdair G Kergon wrote:
> On Tue, Mar 08, 2011 at 10:05:40AM -0800, Wendy Cheng wrote:
> > So the "resize" is on the filesystem, not the volume ? The "grow" part
> > is probably easy. Unfortunately, the "shrink" may not be easy for some
> > of the filesystems:
> 
> The LVM situation today works both ways around.
> 
> You can use 'lvresize' with an option to resize the filesystem too,
> or use 'fsadm' with an option to resize the LV.  We felt that 'fsadm'
> was a more-natural approach: allow the user to resize their filesystem 
> and automatically adjust the things underneath as necessary.
> 
> Long term, we'd like it to be possible to configure a system for resizing
> entire device stacks both top down (fsadm) and bottom up (triggered by the
> appropriate Unit Attention).

I can see how this would be advantageous from a management
perspective for growing LVM pools, but I can see quite a few
problems with extending that to automatically growing filesystems
above LVM. e.g. The LUN resizes, the PV is expanded, the VG is
expanded, but which LV in the VG is going to make use the new space?

Similarly, you can't safely shrink a filesystem from the bottom up -
the filesystem has to empty the space first before it is safe to
shrink it.  How would you handle this from a bottom-up driven
change?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

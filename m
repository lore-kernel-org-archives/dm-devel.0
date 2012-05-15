From: Charles Nordlund <iueras@hotmail.com>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Tue, 15 May 2012 00:50:25 +0000 (UTC)
Message-ID: <loom.20120515T024500-794@post.gmane.org>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com>
	<20111104074652.7b5eacb3@notabene.brown>
	<20111103210810.GM4417@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Tejun Heo <tj <at> kernel.org> writes:

> 
> On Fri, Nov 04, 2011 at 07:46:52AM +1100, NeilBrown wrote:
> > What exactly do you mean by "expose both sizes" ??
> > A new ioctl - BLKGETHPASIZE64 ??
> > 
> > That might work, but I think it would be good if there were also an ioctl
> > BLKHBALOCK which changed BLKGETSIZE64 to match BLKGETHPASIZE64.
> > Then some user-space tools could examine the device with a full understanding
> > of md, dm, dmraid, partitions, filesystems etc etc and make a reasonably
> > informed decision.  And then put that decision into effect.
> 
> In kernel, just another size field.  Out of kernel, I was thinking
> more along the line of a new /sysfs field, but yeah maybe another
> ioctl.  At this point, I don't really think making unlocking
> selectable is a good idea.  That has to go through device detach /
> attach cycle and what if someone else is already using first half of
> the disk?  We can try to be sneaky and slip in device size change
> underneath it but that just sounds too crazy to me.  IMHO, we should
> unlock by default and just let everyone know what the size before
> unlocking was in case that could be useful.
> 
> Thank you.
> 


Just wanted to pop in and say that thanks to your "intelligent HPA unlock" code
you submitted to the kernel, I am completely unable to mount and use an NTFS
RAID0. The way it ignores the ignore_hpa=0 parameter causes the fakeraid to
fail; since the first disk in the array reports a partition size that goes
beyond EOD, the code you submitted goes ahead and unlocks it to native -- not
HPA limited -- capacity, with the expected result that it completely trashes the
array as far as Linux is concerned. What was the point of the huge debate over
locking/unlocking by default and the associated parameters if the kernel is
going to simply ignore all that -- and my explicit parameter to NOT unlock past
HPA size -- and unlock it anyway (which was determined to be a very very bad
idea way back in 2009)?

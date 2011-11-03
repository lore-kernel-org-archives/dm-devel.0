From: Tejun Heo <tj@kernel.org>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Thu, 3 Nov 2011 14:08:10 -0700
Message-ID: <20111103210810.GM4417@google.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com>
	<20111104074652.7b5eacb3@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111104074652.7b5eacb3@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

On Fri, Nov 04, 2011 at 07:46:52AM +1100, NeilBrown wrote:
> What exactly do you mean by "expose both sizes" ??
> A new ioctl - BLKGETHPASIZE64 ??
> 
> That might work, but I think it would be good if there were also an ioctl
> BLKHBALOCK which changed BLKGETSIZE64 to match BLKGETHPASIZE64.
> Then some user-space tools could examine the device with a full understanding
> of md, dm, dmraid, partitions, filesystems etc etc and make a reasonably
> informed decision.  And then put that decision into effect.

In kernel, just another size field.  Out of kernel, I was thinking
more along the line of a new /sysfs field, but yeah maybe another
ioctl.  At this point, I don't really think making unlocking
selectable is a good idea.  That has to go through device detach /
attach cycle and what if someone else is already using first half of
the disk?  We can try to be sneaky and slip in device size change
underneath it but that just sounds too crazy to me.  IMHO, we should
unlock by default and just let everyone know what the size before
unlocking was in case that could be useful.

Thank you.

-- 
tejun

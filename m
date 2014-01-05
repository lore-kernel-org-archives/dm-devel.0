From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
Date: Sat, 4 Jan 2014 19:48:23 -0800
Message-ID: <20140105034823.GE22595@kroah.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
 <52C84F76.6010505@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52C84F76.6010505@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com, mingo@kernel.org
List-Id: dm-devel.ids

On Sat, Jan 04, 2014 at 01:14:14PM -0500, Jeff Mahoney wrote:
> On 1/4/14, 1:06 PM, Mikulas Patocka wrote:
> > Hi
> > 
> > I noticed that Jeff Mahoney added a new structure kobj_completion, defined 
> > in include/linux/kobj_completion.h to the kernel 3.13-rc1 in the patch 
> > eee031649707db3c9920d9498f8d03819b74fc23. In the current upstream kernel, 
> > this interface is still unused.
> > 
> > However, converting the drivers to use kobj_completion is not trivial 
> > (note that all users of the original kobject interface are buggy - so all 
> > of them need to be converted).
> > 
> > I came up with a simpler patch to achieve the same purpose - this patch 
> > makes fixing the drivers easy - the driver is fixed just by replacing 
> > "kobject_put" with "kobject_put_wait" in the unload routine.
> > 
> > I'd like to ask if you could revert 
> > eee031649707db3c9920d9498f8d03819b74fc23 (no code uses it) and replace it 
> > with this patch.
> 
> I have no objections to reverting it. There were concerns from Al Viro
> that it'd be tough to get right by callers and I had assumed it got
> dropped after that. I had planned on using it in my btrfs sysfs exports
> patchset but came up with a better way.

Ok, thanks, I'll revert it for 3.14.

greg k-h

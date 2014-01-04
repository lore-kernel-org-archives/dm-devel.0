From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
Date: Sat, 4 Jan 2014 18:34:03 +0000
Message-ID: <20140104183403.GG10323@ZenIV.linux.org.uk>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
 <20140104181620.GA2087@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140104181620.GA2087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com, mingo@kernel.org
List-Id: dm-devel.ids

On Sat, Jan 04, 2014 at 10:16:20AM -0800, Greg Kroah-Hartman wrote:

> > I came up with a simpler patch to achieve the same purpose - this patch 
> > makes fixing the drivers easy - the driver is fixed just by replacing 
> > "kobject_put" with "kobject_put_wait" in the unload routine.
> 
> No, that's not ok at all.

Agreed - all it takes is one cargo-culter who religoiusly does such
conversion and drops a ref to parent before that to child.

> > However, this pattern is buggy with respect to modules. The release method
> > is placed in the driver's module. When the driver exits, the module
> > reference count is zero, thus the module may be freed. However, there may
> > still be references to the kobject. If the module is unloaded and then the
> > release method is called, a crash happens.
> 
> Yes, module unloading while a kobject is still "active" is not a good
> thing, what modules do you have that cause this problem?  Why not just
> grab the module reference in your kobject if you need this type of
> protection?  It's not the kobject's code fault that this issue is there,
> or that we now have a "delayed release" function to expose this type of
> thing, it's the user of the kobject.
> 
> Please fix the broken users of the kobject first.

<snide> Are you saying that there is another kind? </snide>

When would you grab that reference to module?  More to the point, when
would you *drop* it?  Doing so from module_exit is not going to work,
obviously...

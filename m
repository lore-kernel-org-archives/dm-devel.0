From: Greg KH <greg@kroah.com>
Subject: Re: FW: Re: [dm-devel] [BUG 3.12.rc4] Oops: unable to handle kernel
 paging request during shutdown
Date: Wed, 30 Oct 2013 10:18:44 -0700
Message-ID: <20131030171844.GA16462@kroah.com>
References: <20131028140015.GA14612@agk-dp.fab.redhat.com>
 <alpine.LRH.2.02.1310301133180.4090@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1310301133180.4090@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, =?iso-8859-1?B?RnLvv71k77+9cmlj?= Weisbecker <fweisbec@gmail.com>, Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>
List-Id: dm-devel.ids

On Wed, Oct 30, 2013 at 12:37:04PM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 28 Oct 2013, Alasdair G Kergon wrote:
> 
> > On Fri, Oct 25, 2013 at 11:48 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > Yes, but nobody has actually been able to trigger it with those. It's
> > > pretty rare, and the debug options are so expensive that they aren't
> > > reasonable to enable generally...
> > >
> > > So we need to try to figure out how to trigger it, or narrow things
> > > down some way..
> > 
> > Ok, still trying to figure this out, and I do have another bug as a
> > result. I don't think this one is really the fundamental one either
> > that caused my crash during "yum upgrade", nor necessarily Knut's
> > problem during shutdown, but I'll keep looking.
> > 
> > And who knows.. Maybe this *does* explain Knut's issue.
> > 
> > Appended is a warning I get with DEBUG_TIMER_OBJECTS. Seems to be a
> > device-mapper issue. Alasdair, Neil, comments? It looks like
> > dm_destroy() is freeing an delayed_work entry that is still active...
> > 
> > I don't know exactly which field in the 'struct mapped_device' has
> > that delayed-work thing, but I assume it's the kobject.. Somebody who
> > knows this code better, please take a look!
> >
> >                    Linus
> 
> No field in device mapper has 'struct delayed_work' in it --- except 
> struct kobject:
> #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
>         struct delayed_work     release;
> #endif
> 
> - so this is kobject manipulation bug. Dm calls dm_sysfs_exit, which calls 
> kobject_put. Dm then frees the structure that contained the kobject with 
> kfree and it triggers this warning.
> 
> Documentation/kobject.txt says that kobjects shouldn't be used this way - 
> that the structure should be freed from the release method. However, using 
> the API the correct way is impossible.
> 
> Unloading of a device driver is supposed to work like this:
> 1) you call the unload routine
> 2) it calls kobject_put (but the kobject may still be referenced by other 
> kernel code release method will be called when the references are dropped)
> 3) you don't free the driver structure
> 4) you exit the unload routing
> 
> ...
> 
> 5) the other references to kobject are dropped
> 6) release method is called, it calls kfree on the driver routine
> 7) the release method exits
> 
> Now, the problem is that between steps 4) and 5), someone may unload the 
> module and trigger the crash. It is impossible to protect against it. 
> 
> Another problem is that between steps 4) and 5), the driver is essentially 
> dead, but it must still respond to attr_show and attr_store methods on the 
> kobect - it is possible to handle it correctly, but it is not easy to test 
> - there is a possibility of a lot of bugs in drivers.
> 
> 
> I suggest that you implement a function kobject_put_free, that decrements 
> the kobject reference count and waits until others stop using the kobject 
> and the reference count drops to zero. Then, you change drivers to use 
> kobject_put_free instead of kobject_put in their unload routine - that 
> will fix this sort of module unload races.

The "module unload" issue is rare, thankfully, but yes, this type of
function will be showing up in 3.13-rc1 through the btrfs tree as it
needs that functionality, so feel free to use it to resolve this issue
if you need it.

thanks,

greg k-h

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: FW: Re: [dm-devel] [BUG 3.12.rc4] Oops: unable to handle kernel
 paging request during shutdown
Date: Wed, 30 Oct 2013 20:08:41 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1310301944310.22093@file01.intranet.prod.int.rdu2.redhat.com>
References: <20131028140015.GA14612@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1310301133180.4090@file01.intranet.prod.int.rdu2.redhat.com> <20131030171844.GA16462@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131030171844.GA16462@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, =?ISO-8859-1?Q?Fr=EF=BF=BDd=EF=BF=BDric_Weisbecker?= <fweisbec@gmail.com>, Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>
List-Id: dm-devel.ids



On Wed, 30 Oct 2013, Greg KH wrote:

> > I suggest that you implement a function kobject_put_free, that decrements 
> > the kobject reference count and waits until others stop using the kobject 
> > and the reference count drops to zero. Then, you change drivers to use 
> > kobject_put_free instead of kobject_put in their unload routine - that 
> > will fix this sort of module unload races.
> 
> The "module unload" issue is rare, thankfully, but yes, this type of
> function will be showing up in 3.13-rc1 through the btrfs tree as it
> needs that functionality, so feel free to use it to resolve this issue
> if you need it.
> 
> thanks,
> 
> greg k-h

With CONFIG_DEBUG_KOBJECT_RELEASE this issue is not rare - 
CONFIG_DEBUG_KOBJECT_RELEASE deliberately provokes it.

Nice to hear that it will be fixed. You should patch other drivers to use 
this new function in the unload routine as well.

What is the name of the function? I didn't find it in linux-btrfs.git or 
btrfs-next.git.

Mikulas

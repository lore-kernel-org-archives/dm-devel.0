From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [dm-devel] [PATCH] kobject: provide kobject_put_wait to fix
 module unload race
Date: Mon, 6 Jan 2014 11:23:53 -0800
Message-ID: <20140106192353.GA32664@kroah.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
 <52C98BCC.9040900@acm.org>
 <20140105182640.GA2522@kroah.com>
 <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org, device-mapper development <dm-devel@redhat.com>, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@kernel.org
List-Id: dm-devel.ids

On Mon, Jan 06, 2014 at 01:55:11PM -0500, Mikulas Patocka wrote:
> 
> 
> On Sun, 5 Jan 2014, Greg Kroah-Hartman wrote:
> 
> > On Sun, Jan 05, 2014 at 05:43:56PM +0100, Bart Van Assche wrote:
> > > On 01/04/14 19:06, Mikulas Patocka wrote:
> > > > -	if (t && !t->release)
> > > > -		pr_debug("kobject: '%s' (%p): does not have a release() "
> > > > -			 "function, it is broken and must be fixed.\n",
> > > > -			 kobject_name(kobj), kobj);
> > > > -
> > > 
> > > Has it been considered to issue a warning if no release function has
> > > been defined and free_completion == NULL instead of removing the above
> > > debug message entirely ? I think even with this patch applied it is
> > > still wrong to invoke kobject_put() on an object without defining a
> > > release function.
> > 
> > This patch isn't going to be applied, and I've reverted the original
> > commit, so there shouldn't be any issues anymore with this code.
> 
> Why? This patch does the same thing as 
> eee031649707db3c9920d9498f8d03819b74fc23, but it's smaller. So why did you 
> accept eee031649707db3c9920d9498f8d03819b74fc23 and not this?

I have now reverted that commit, it will not be in 3.14, so consider it
rejected as well :)

thanks,

greg k-h

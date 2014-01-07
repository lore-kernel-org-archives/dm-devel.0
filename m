From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: kobject: provide kobject_put_wait to fix module unload race
Date: Tue, 7 Jan 2014 13:16:05 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401071306160.8158@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <52C98BCC.9040900@acm.org> <20140105182640.GA2522@kroah.com> <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com> <20140106213111.GA2536@redhat.com>
 <alpine.LRH.2.02.1401062249020.17811@file01.intranet.prod.int.rdu2.redhat.com> <20140107141622.GA32290@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140107141622.GA32290@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jeff Mahoney <jeffm@suse.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, tglx@linutronix.de, paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, mingo@kernel.org
List-Id: dm-devel.ids



On Tue, 7 Jan 2014, Greg Kroah-Hartman wrote:

> > Index: linux-3.13-rc7/drivers/md/dm-sysfs.c
> > ===================================================================
> > --- linux-3.13-rc7.orig/drivers/md/dm-sysfs.c	2014-01-07 02:06:08.000000000 +0100
> > +++ linux-3.13-rc7/drivers/md/dm-sysfs.c	2014-01-07 02:07:09.000000000 +0100
> > @@ -79,6 +79,11 @@ static const struct sysfs_ops dm_sysfs_o
> >  	.show	= dm_attr_show,
> >  };
> >  
> > +static void dm_kobject_release(struct kobject *kobj)
> > +{
> > +	complete(dm_get_completion_from_kobject(kobj));
> > +}
> 
> Please read the kobject documentation in the kernel tree for why this
> isn't ok.  The fact that you didn't have a release function at all means
> this code has always been broken, why have you been ignoring the kernel
> complaining about this for so long before?

I read that file and I say that the usage pattern presented in that file 
is broken w.r.t. module unload.

I don't want to fix one race condition and introduce another one (albeit 
smaller).

> You need to free the memory in the release function, not just sit around
> and wait for potentially forever.

How could that code wait forever? Even if userspace keeps the appropriate 
files in sysfs open, the dm device can be unloaded, it doesn't wait 
forever.

> thanks,
> 
> greg k-h

Mikulas

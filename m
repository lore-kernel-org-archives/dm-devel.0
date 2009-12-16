From: Greg KH <greg@kroah.com>
Subject: Re: dm: sysfs add empty release function to avoid debug warning
Date: Wed, 16 Dec 2009 05:45:38 -0800
Message-ID: <20091216134538.GA20857@kroah.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758193AbZLPNwP@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B28AC09.2000302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 16, 2009 at 10:44:41AM +0100, Milan Broz wrote:
> On 12/16/2009 01:47 AM, Greg KH wrote:
> > On Tue, Dec 15, 2009 at 05:35:08PM +0000, James Bottomley wrote:
> >> commit: d2bb7df8cac647b92f51fb84ae735771e7adbfa7
> >> From: Milan Broz <mbroz@redhat.com>
> >> Date: Thu, 10 Dec 2009 23:51:53 +0000
> >> Subject: [PATCH] dm: sysfs add empty release function to avoid debug warning
> >>
> >> This patch just removes an unnecessary warning:
> >>  kobject: 'dm': does not have a release() function,
> >>  it is broken and must be fixed.
> >>
> >> The kobject is embedded in mapped device struct, so
> >> code does not need to release memory explicitly here.
> > 
> 
> > Please, this is totally and completly wrong.  And if you feel that it is
> > needed, then your design is wrong and it needs to be fixed.
> 
> There are several places in kernel, where kobject have not defined release
> method. Yes, something is wrong here.

Where are those instances, becides the use of static kobjects, which is
being worked on?

That still does not make this change acceptable, it is incorrect.

> So quietly ignoring warning is ok? Why is not there BUG_ON(!release) then?

I was trying to be nice and not crash your machine and give you the
opportunity to fix it easily.

> The sysfs attributes here just represents attributes of block device object,
> this device is always removed before release here is called.

Then why use a kobject at all?  Your reference counting will be all
wrong if you use it incorrectly like this.

> So if there is preferred to do another alloc/free, no problem.

Please do.

Also, with the addition of this patch, your comments for the kobject are
now incorrect as well.

thanks,

greg k-h

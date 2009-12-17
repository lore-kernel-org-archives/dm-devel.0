From: Greg KH <greg@kroah.com>
Subject: Re: Re: dm: sysfs add empty release function to avoid
	debug	warning
Date: Wed, 16 Dec 2009 16:30:21 -0800
Message-ID: <20091217003021.GB3512@kroah.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org>
	<20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com>
	<20091216134538.GA20857@kroah.com> <4B290B95.10306@redhat.com>
	<20091216174632.GA12473@kroah.com> <4B29299B.5080704@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B29299B.5080704@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 16, 2009 at 07:40:27PM +0100, Milan Broz wrote:
> On 12/16/2009 06:46 PM, Greg KH wrote:
> > You will find that all of these are modules, right?  That's being worked
> > on still.
> 
> probably. I see that this implementation is in kernel since import to git...

And you will also note that I didn't paper over the issue by trying to
provide an empty release function :)

> What's the right solution in this particular case?
> It is exactly the same situation (using embedded kobj like module handle does).
> 
> In DM, the whole problem here is that kobject is used for attribute representation
> of mapped device, mapped device struct is using its own reference counting
> and can dissappear before the kobject. So it must properly solve this situation.

Then dynamically create the kobject, as it obviously has a different
lifespan.

Or do something else, but as it is now, you can not have two reference
counts with different lifespan rules, within the same object, and expect
things to work properly.

thanks,

greg k-h

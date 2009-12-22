From: Greg KH <greg@kroah.com>
Subject: Re: [dm-devel] Re: dm: sysfs add empty release function to avoid
	debug warning
Date: Mon, 21 Dec 2009 21:31:55 -0800
Message-ID: <20091222053155.GA16888@kroah.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com> <20091216134538.GA20857@kroah.com> <4B290B95.10306@redhat.com> <20091216174632.GA12473@kroah.com> <4B29299B.5080704@redhat.com> <20091217003021.GB3512@kroah.com> <4B2A518B.1030800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752001AbZLVGAj@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B2A518B.1030800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Dec 17, 2009 at 04:43:07PM +0100, Milan Broz wrote:
> On 12/17/2009 01:30 AM, Greg KH wrote:
> > On Wed, Dec 16, 2009 at 07:40:27PM +0100, Milan Broz wrote:
> >> On 12/16/2009 06:46 PM, Greg KH wrote:
> >>> You will find that all of these are modules, right?  That's being worked
> >>> on still.
> >>
> >> probably. I see that this implementation is in kernel since import to git...
> > 
> > And you will also note that I didn't paper over the issue by trying to
> > provide an empty release function :)
> 
> Alasdair, can we request revert of that last patch for now
> (which introduced the empty release function)?

Ping?  Any word on the revert?

thanks,

greg k-h

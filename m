From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [dm-devel] [PATCH] dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Tue, 20 Aug 2013 14:28:38 -0700
Message-ID: <1377034118.24869.48.camel@bobble.lax.corp.google.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	 <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, 2013-08-20 at 17:22 -0400, Mikulas Patocka wrote:
> On Fri, 16 Aug 2013, Frank Mayhar wrote:
> > The device mapper and some of its modules allocate memory pools at
> > various points when setting up a device.  In some cases, these pools are
> > fairly large, for example the multipath module allocates a 256-entry
> > pool and the dm itself allocates three of that size.  In a
> > memory-constrained environment where we're creating a lot of these
> > devices, the memory use can quickly become significant.  Unfortunately,
> > there's currently no way to change the size of the pools other than by
> > changing a constant and rebuilding the kernel.
> I think it would be better to set the values to some low value (1 should 
> be enough, there is 16 in some places that is already low enough). There 
> is no need to make it user-configurable, because the user will see no 
> additional benefit from bigger mempools.
> 
> Maybe multipath is the exception - but other dm targets don't really need 
> big mempools so there is no need to make the size configurable.

The point is not to make the mempools bigger, the point is to be able to
make them _smaller_ for memory-constrained environments.  In some cases,
even 16 can be too big, especially when creating a large number of
devices.

In any event, it seems unfortunate to me that these values are
hard-coded.  One shouldn't have to rebuild the kernel to change them,
IMHO.
-- 
Frank Mayhar
310-460-4042

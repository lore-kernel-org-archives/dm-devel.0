From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Tue, 20 Aug 2013 17:44:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308201742350.8826@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com> <20130819140016.GB27167@redhat.com> <1376934845.24869.43.camel@bobble.lax.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376934845.24869.43.camel@bobble.lax.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids



On Mon, 19 Aug 2013, Frank Mayhar wrote:

> On Mon, 2013-08-19 at 10:00 -0400, Mike Snitzer wrote:
> > Performance isn't the concern.  The concern is: does DM allow for
> > forward progress if the system's memory is completely exhausted?
> > 
> > This is why request-based has such an extensive reserve, because it
> > needs to account for cloning the largest possible request that comes in
> > (with multiple bios).
> 
> Thanks for the response.  In our particular case, I/O will be file
> system based and over a network, which makes it pretty easy for us to be
> sure that large I/Os never happen.  That notwithstanding, however, as
> you said it just seems reasonable to make these values configurable.
> 
> I'm also looking at making some similar constants in dm-verity and
> dm-bufio configurable in the same way and for similar reasons.

Regarding dm-bufio: the user of dm-bufio sets the pool size as an argument 
in dm_bufio_client_create. There is no need to make it configurable - if 
the user selects too low value, deadlock is possible, if the user selects 
too high value, there is no additional advantage.

Regarding dm-verity: the mempool size is 4, there is no need to make it 
bigger, there is no advantage from that.

Mikulas

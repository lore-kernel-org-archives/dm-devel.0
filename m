From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Wed, 8 Apr 2009 08:44:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904080839200.28196@hs20-bc2-1.build.redhat.com>
References: <20090324150517.GX27476@kernel.dk>
	<Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	<20090326084205.GG27476@kernel.dk>
	<Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	<20090331104933.GJ5178@kernel.dk>
	<Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	<20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>
	<20090405012839.GF7553@mit.edu> <49D89C06.1060700@gmail.com>
	<75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lee Revell <rlrevell@joe-job.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, ak@linux.intel.com, Theodore Tso <tytso@mit.edu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>
List-Id: dm-devel.ids

On Sun, 5 Apr 2009, Lee Revell wrote:

> On Sun, Apr 5, 2009 at 7:54 AM, Ric Wheeler <ricwheeler@gmail.com> wrote:
> > One thing to point out here is that there are a lot of "servers" in high end
> > data centers that do not have UPS backup. Those racks full of 1U and 2U
> > boxes that are used to make "grids", "clouds" and so on often are built with
> > as much gear as you can stuff in a rack - no batteries or UPS to be seen, so
> > they are really quite similar to the normal desktop or home systems that we
> > normally run at home :-)
> 
> These days even bargain basement data centers provide UPS functionality for
> you, via generator backup and A/B power.

I have seen an installation having generator backup, but with another 
serious flaw --- if someone plugged a computer causing short-circuit, it 
turned off the circuit breaker for the whole rack :)

Mikulas

> Lee

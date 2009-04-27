From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: [PATCH 12/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 19:48:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904271947080.9362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
	<20090427223421.GH23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271941200.9362@hs20-bc2-1.build.redhat.com>
	<20090427234406.GO23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090427234406.GO23302@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 28 Apr 2009, Alasdair G Kergon wrote:

> On Mon, Apr 27, 2009 at 07:41:47PM -0400, Mikulas Patocka wrote:
> > There is separate read_delay and write_delay. Flushes are governed by 
> > write_delay.
>  
> And the value of read_delay has no impact on the flush?

No.

> (Because of the "wait for all outstanding I/O" bit that eventually I
> want to see removed to facilitate true barrier passing?)

With dm-delay, "true barrier passing" doesn't have sense. Dm-delay is 
designed to delay requests, so no one wants high performance from it :)

> Alasdair
> -- 
> agk@redhat.com

Mikulas

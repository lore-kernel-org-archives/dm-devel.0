From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: [PATCH 12/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 19:32:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904271928030.9362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
	<20090427220644.GG23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271907150.9362@hs20-bc2-1.build.redhat.com>
	<20090427232108.GJ23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090427232108.GJ23302@agk.fab.redhat.com>
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

> On Mon, Apr 27, 2009 at 07:09:32PM -0400, Mikulas Patocka wrote:
> > The code is correct as it is.
>  
> I don't see that.
> 
> > The difference is the zero-barrier flush request --- it should have 
> > bi_sector always 0.
> 
> But I'm asking at what point that is defined?

It is not defined, the Linux way is that there is no specification and the 
code is considered the specification.

The point is that any code in the Linux kernel that creates zero-length 
barrier creates it with sector number 0. So I'm doing it the same way. I 
have no capability to review all the drivers if they accept zero-barriers 
with non-zero sector number or not. So I set it to zero.

> 0 before calling the target's map function?
> In which case it is wrong to perform:
> 	bio->bi_sector = dc->start_write + (bio->bi_sector - ti->begin);
> 
> Or if it's not set to zero until the
> 	bio->bi_sector = 0 
> line, then what does it hold on entry to the function and what does that
> mean?

On entry to the function it holds zero if it is processing zero-length 
barrier. The line "bio->bi_sector = dc->start_write + (bio->bi_sector - 
ti->begin)" can set it to non-zero, so I set it to zero again. If you 
want, you can somehow rearrange the code so that "bio->bi_sector = 
dc->start_write + (bio->bi_sector - ti->begin)" is performed only if the 
request has non-zero length.

Mikulas

> Alasdair
> -- 
> agk@redhat.com
> 

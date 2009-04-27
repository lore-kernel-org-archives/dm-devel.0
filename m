From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: [PATCH 12/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 19:42:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904271942380.9362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
	<20090427220644.GG23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271907150.9362@hs20-bc2-1.build.redhat.com>
	<20090427232108.GJ23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271928030.9362@hs20-bc2-1.build.redhat.com>
	<20090427234156.GN23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090427234156.GN23302@agk.fab.redhat.com>
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

> On Mon, Apr 27, 2009 at 07:32:00PM -0400, Mikulas Patocka wrote:
> > On entry to the function it holds zero if it is processing zero-length 
> > barrier. 
> 
> OK - so that is a clear definition the writer of a target map function can
> rely upon, good.
> 
> > The line "bio->bi_sector = dc->start_write + (bio->bi_sector - 
> > ti->begin)" can set it to non-zero, so I set it to zero again. If you 
> > want, you can somehow rearrange the code so that "bio->bi_sector = 
> > dc->start_write + (bio->bi_sector - ti->begin)" is performed only if the 
> > request has non-zero length.
>  
> Please do that.  In dm I try to enforce a rule that the values of variables
> always correspond to their definitions - if a calculation needs intermediate
> steps then different and meaningful intermediate variables are used
> instead.  Here, bi_sector seems to be set to a meaningless intermediate
> value which is a recipe for confusion.

OK.

Mikulas

> Alasdair
> -- 
> agk@redhat.com
> 

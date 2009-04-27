From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 12/17] bottom-layer barrier support
Date: Tue, 28 Apr 2009 00:21:08 +0100
Message-ID: <20090427232108.GJ23302@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
	<20090427220644.GG23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271907150.9362@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904271907150.9362@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 27, 2009 at 07:09:32PM -0400, Mikulas Patocka wrote:
> The code is correct as it is.
 
I don't see that.

> The difference is the zero-barrier flush request --- it should have 
> bi_sector always 0.

But I'm asking at what point that is defined?
0 before calling the target's map function?
In which case it is wrong to perform:
	bio->bi_sector = dc->start_write + (bio->bi_sector - ti->begin);

Or if it's not set to zero until the
	bio->bi_sector = 0 
line, then what does it hold on entry to the function and what does that
mean?

Alasdair
-- 
agk@redhat.com

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA
 support for request-based dm
Date: Wed, 1 Sep 2010 14:59:07 -0400
Message-ID: <20100901185907.GA26411@redhat.com>
References: <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
	<4C7BD202.4040700@kernel.org> <20100830194731.GA10702@redhat.com>
	<Pine.LNX.4.64.1009010625070.16035@hs20-bc2-1.build.redhat.com>
	<4C7E36E8.2000705@kernel.org>
	<Pine.LNX.4.64.1009010811001.23591@hs20-bc2-1.build.redhat.com>
	<20100901152053.GA25644@redhat.com>
	<Pine.LNX.4.64.1009011133300.21130@hs20-bc2-1.build.redhat.com>
	<20100901170743.GB25644@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100901170743.GB25644@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 01 2010 at  1:07pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Sep 01 2010 at 11:35am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > On Wed, 1 Sep 2010, Mike Snitzer wrote:
> > > 
> > > Mikulas,
> > > 
> > > Current bio-based barrier support also defers IO if a flush is in
> > > progress.  See _dm_request:
> > 
> > I know. But it doesn't hurt with flush/fua requests. It just lowers 
> > performance (it defers i/os when it doesn't have to) but doesn't damage 
> > data.
> > 
> > So I think that we can let it be this way until flush/fua patch is 
> > finalized.
> 
> Neither Tejun nor I see the point in waiting when we have a window of
> time to address the issues now.  We want DM to realize the benefit
> associated with the kernel-wide FLUSH+FUA conversion too.

But we can meet in the middle.  I've reordered the DM FLUSH+FUA patches
so that the more intrusive bio-based relaxed ordering patch is at the
very end.

My hope was that the request-based deadlock I'm seeing would disappear
if that relaxed ordering patch wasn't applied.  Unfortunately, I still
see the hang.

Anyway, I've made the patches available here:
http://people.redhat.com/msnitzer/patches/flush-fua/

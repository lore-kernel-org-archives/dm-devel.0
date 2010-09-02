From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA
 support for request-based dm
Date: Thu, 2 Sep 2010 11:11:02 -0400
Message-ID: <20100902151100.GA1909@redhat.com>
References: <20100830194731.GA10702@redhat.com>
	<Pine.LNX.4.64.1009010625070.16035@hs20-bc2-1.build.redhat.com>
	<4C7E36E8.2000705@kernel.org>
	<Pine.LNX.4.64.1009010811001.23591@hs20-bc2-1.build.redhat.com>
	<20100901152053.GA25644@redhat.com>
	<Pine.LNX.4.64.1009011133300.21130@hs20-bc2-1.build.redhat.com>
	<20100901170743.GB25644@redhat.com>
	<20100901185907.GA26411@redhat.com>
	<20100902032246.GA31484@redhat.com> <4C7F7B43.9030602@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C7F7B43.9030602@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: hch@infradead.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 02 2010 at  6:24am -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 09/02/2010 05:22 AM, Mike Snitzer wrote:
> >> But we can meet in the middle.  I've reordered the DM FLUSH+FUA patches
> >> so that the more intrusive bio-based relaxed ordering patch is at the
> >> very end.
> >>
> >> My hope was that the request-based deadlock I'm seeing would disappear
> >> if that relaxed ordering patch wasn't applied.  Unfortunately, I still
> >> see the hang.
> 
> I don't think it would make any difference.  AFAICS, the patch doesn't
> touch anything requested based dm uses.

Right, I was stacking bio-based on request-based so it initially seemed
like they were related (based on traces I had seen).

> > Turns out I can reproduce the hang on a stock 2.6.36-rc3 (without _any_
> > FLUSH+FUA patches)!
> 
> Hmmm... that's interesting.

Definitely, and I just tested a recent RHEL6 kernel.. it works perfectly
fine.

So now I'll be doing a git bisect to try to pinpoint where upstream went
wrong.

> > I'll try to pin-point the root cause but I think my test is somehow
> > exposing a bug in my virt setup.
> > 
> > So this hang is definitely starting to look like a red herring.
> > 
> > Tejun,
> > 
> > This news should clear the way for you to re-post your patches.  I think
> > it would be best if you reordered the DM patches like I did here in this
> > series: http://people.redhat.com/msnitzer/patches/flush-fua/series
> > 
> > In particular, the dm-relax-ordering-of-bio-based-flush-implementation
> > patch should go at the end.  I think it makes for a more logical
> > evolution of the DM code.
> 
> Sure, I'll.  I still think having the queue kicking mechanism is a
> good idea tho.  I'll integrate that into series, reorder and repost
> it.

Sounds good.

Thanks,
Mike

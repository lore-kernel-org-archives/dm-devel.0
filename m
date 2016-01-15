From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM ATTEND] plan to deprecate old .request_fn
 request-based code path?
Date: Fri, 15 Jan 2016 11:19:26 -0500
Message-ID: <20160115161926.GA15922@redhat.com>
References: <20160112185947.GA29176@redhat.com>
	<alpine.LRH.2.02.1601121835590.29321@file01.intranet.prod.int.rdu2.redhat.com>
	<56960904.5060006@suse.de>
	<20160115152814.GG24960@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160115152814.GG24960@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf-pc@lists.linux-foundation.org
List-Id: dm-devel.ids

On Fri, Jan 15 2016 at 10:28am -0500,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> On Wed, Jan 13, 2016 at 09:21:24AM +0100, Hannes Reinecke wrote:
> > On 01/13/2016 12:39 AM, Mikulas Patocka wrote:
> > >
> > >
> > >On Tue, 12 Jan 2016, Mike Snitzer wrote:
> > >
> > >>Hi,
> > >>
> > >>I'd like to attend LSF/MM and as the subject covers I'd like to at least
> > >>participate in a discussion about plans (realistic or not) for
> > >>removing/deprecating the old .request_fn path in block core and block
> > >>drivers.
> > >>
> > >>The request-based DM code (only used for multipath) has gotten more
> > >>complex to support both old .request_fn and blk-mq (and stacking
> > >>combinations: .request_fn ontop of blk-mq paths, blk-mq ontop of
> > >>.request_fn paths).  Simplifying DM core in this area would be nice.
> > >>
> > >>One of the hurdles has been blk-mq doesn't yet have a scheduler.  I know
> > >>Jens had/has something in the works.  But there is also the question of
> > >>whether DM's top-level blk-mq request_queue should be trained to
> > >>leverage/stack underlying blk-mq request_queue capabilities (Keith Busch
> > >>was going to look at this aspect in the context of multipath on NVMe but
> > >>I never heard anything from Keith on that).  As of now DM multipath's
> > >>blk-mq request_queue only supports a single (virtual) hw queue.
> > >>
> > >>In addition to the above topic, I'd be open to discussing Linux MD
> > >>maintainership options with others if for some reason that is still an
> > >>unresolved situation come mid April.
> > >>
> > >>Thanks,
> > >>Mike
> > >
> > >Convert multipath from request-based to bio-based and these problems in
> > >device mapper core will disappear :-)
> > >
> > We have been down that road already. It doesn't work.
> > There is a reason why we switched to request-based multipathing.
> 
> I have been wondering lately if devices that don't benefit from
> reordering or lots of time spent coalescing requests would do better (or
> at least equally well) if we we brought back the option of bio based
> multipathing.  However, I still think that for devices where reordering
> and coalescing provides a significant performance boost, there will be
> improvements by using request based multipath.  So unfortunately, this
> would mean supporting both, which is adding instead of removing
> complexity.  But we would then we would be in better shape if/when we
> eventually do decide to deprecate request-based dm.
> 
> Also, I think we could improve on round-robin as a path selector to try
> and get adjacent IOs going down the same path.

Even fast storage benefits from deadline or noop schedulers.

I'm not eager to prop up a bio-based DM multipath target.. I think it
best to put more energy to optimizing the exisiting request-based DM
blk-mq support before we seriously consider punting back to bio-based.

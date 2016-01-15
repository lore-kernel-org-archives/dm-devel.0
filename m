From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [LSF/MM ATTEND] plan to deprecate old .request_fn
 request-based code path?
Date: Fri, 15 Jan 2016 09:28:14 -0600
Message-ID: <20160115152814.GG24960@octiron.msp.redhat.com>
References: <20160112185947.GA29176@redhat.com>
	<alpine.LRH.2.02.1601121835590.29321@file01.intranet.prod.int.rdu2.redhat.com>
	<56960904.5060006@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56960904.5060006@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-block@vger.kernel.org, lsf-pc@lists.linux-foundation.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 13, 2016 at 09:21:24AM +0100, Hannes Reinecke wrote:
> On 01/13/2016 12:39 AM, Mikulas Patocka wrote:
> >
> >
> >On Tue, 12 Jan 2016, Mike Snitzer wrote:
> >
> >>Hi,
> >>
> >>I'd like to attend LSF/MM and as the subject covers I'd like to at least
> >>participate in a discussion about plans (realistic or not) for
> >>removing/deprecating the old .request_fn path in block core and block
> >>drivers.
> >>
> >>The request-based DM code (only used for multipath) has gotten more
> >>complex to support both old .request_fn and blk-mq (and stacking
> >>combinations: .request_fn ontop of blk-mq paths, blk-mq ontop of
> >>.request_fn paths).  Simplifying DM core in this area would be nice.
> >>
> >>One of the hurdles has been blk-mq doesn't yet have a scheduler.  I know
> >>Jens had/has something in the works.  But there is also the question of
> >>whether DM's top-level blk-mq request_queue should be trained to
> >>leverage/stack underlying blk-mq request_queue capabilities (Keith Busch
> >>was going to look at this aspect in the context of multipath on NVMe but
> >>I never heard anything from Keith on that).  As of now DM multipath's
> >>blk-mq request_queue only supports a single (virtual) hw queue.
> >>
> >>In addition to the above topic, I'd be open to discussing Linux MD
> >>maintainership options with others if for some reason that is still an
> >>unresolved situation come mid April.
> >>
> >>Thanks,
> >>Mike
> >
> >Convert multipath from request-based to bio-based and these problems in
> >device mapper core will disappear :-)
> >
> We have been down that road already. It doesn't work.
> There is a reason why we switched to request-based multipathing.

I have been wondering lately if devices that don't benefit from
reordering or lots of time spent coalescing requests would do better (or
at least equally well) if we we brought back the option of bio based
multipathing.  However, I still think that for devices where reordering
and coalescing provides a significant performance boost, there will be
improvements by using request based multipath.  So unfortunately, this
would mean supporting both, which is adding instead of removing
complexity.  But we would then we would be in better shape if/when we
eventually do decide to deprecate request-based dm.

Also, I think we could improve on round-robin as a path selector to try
and get adjacent IOs going down the same path.

-Ben
 =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

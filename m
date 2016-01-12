From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [LSF/MM ATTEND] plan to deprecate old .request_fn
 request-based code path?
Date: Tue, 12 Jan 2016 18:39:21 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601121835590.29321@file01.intranet.prod.int.rdu2.redhat.com>
References: <20160112185947.GA29176@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160112185947.GA29176@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, lsf-pc@lists.linux-foundation.org
List-Id: dm-devel.ids



On Tue, 12 Jan 2016, Mike Snitzer wrote:

> Hi,
> 
> I'd like to attend LSF/MM and as the subject covers I'd like to at least
> participate in a discussion about plans (realistic or not) for
> removing/deprecating the old .request_fn path in block core and block
> drivers.
> 
> The request-based DM code (only used for multipath) has gotten more
> complex to support both old .request_fn and blk-mq (and stacking
> combinations: .request_fn ontop of blk-mq paths, blk-mq ontop of
> .request_fn paths).  Simplifying DM core in this area would be nice.
> 
> One of the hurdles has been blk-mq doesn't yet have a scheduler.  I know
> Jens had/has something in the works.  But there is also the question of
> whether DM's top-level blk-mq request_queue should be trained to
> leverage/stack underlying blk-mq request_queue capabilities (Keith Busch
> was going to look at this aspect in the context of multipath on NVMe but
> I never heard anything from Keith on that).  As of now DM multipath's
> blk-mq request_queue only supports a single (virtual) hw queue.
> 
> In addition to the above topic, I'd be open to discussing Linux MD
> maintainership options with others if for some reason that is still an
> unresolved situation come mid April.
> 
> Thanks,
> Mike

Convert multipath from request-based to bio-based and these problems in 
device mapper core will disappear :-)

Mikulas

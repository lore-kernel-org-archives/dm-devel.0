From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM ATTEND] plan to deprecate old .request_fn
 request-based code path?
Date: Wed, 13 Jan 2016 13:16:03 +0200
Message-ID: <569631F3.1060106@dev.mellanox.co.il>
References: <20160112185947.GA29176@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


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

I strongly agree we can do better here. Initial measurements of
request-based DM multipath over the (soon to come) nvme-loop driver
shows improvement from the bio-based code, but instrumentation reveals
we have plenty of room for improvement.

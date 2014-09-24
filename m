From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: Work with blk multi-queue drivers
Date: Wed, 24 Sep 2014 11:02:30 +0200
Message-ID: <542288A6.3010606@suse.de>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/23/2014 07:03 PM, Keith Busch wrote:
> I'm working with multipathing nvme devices using the blk-mq version of
> the nvme driver, but dm-mpath only works with the older request based
> drivers. This patch proposes to enable dm-mpath to work with both types
> of request queues and is succesfull with my dual ported nvme drives.
> =

> I think there may still be fix ups to do around submission side error
> handling, but I think it's at a decent stopping point to solicit feedback
> before I pursue taking it further. I hear there may be some resistance
> to add blk-mq support to dm-mpath anyway, but it seems too easy to add
> support to not at least try. :)
> =

> To work, this has dm allocate requests from the request_queue for
> the device-mapper type rather than allocate one on its own, so the
> cloned request is properly allocated and initialized for the device's
> request_queue. The original request's 'special' now points to the
> dm_rq_target_io rather than at the cloned request because the clone
> is allocated later by the block layer rather than by dm, and then all
> the other back referencing to the original seems to work out. The block
> layer then inserts the cloned reqest using the appropriate function for
> the request_queue type rather than just calling q->request_fn().
> =

> Compile tested on 3.17-rc6; runtime teseted on Matias Bjorling's
> linux-collab nvmemq_review using 3.16.
> =

The resistance wasn't so much for enabling multipath for block-mq,
it was _how_ multipath should be modelled on top of block-mq.

With a simple enabling we actually have two layers of I/O
scheduling; once in multipathing to select between the individual
queues, and once in block-mq to select the correct hardware context.
So we end up with a four-tiered hierarchy:

m priority groups - n pg_paths/request_queues -> o cpus -> p hctx

Giving us a full m * n * p (hctx are tagged per cpu) variety where
the I/Os might be send.

Performance wise it might be beneficial to tag a hardware context
to a given path, effectively removing I/O scheduling from
block-mq. But this would require some substantial update to the
current blk-mq design (blocked paths, dynamic reconfiguration).

However, this looks like a good starting point.
I'll give it a go and see how far I'll be getting with it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

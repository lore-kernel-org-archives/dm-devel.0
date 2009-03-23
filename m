From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Mon, 23 Mar 2009 14:10:28 -0500
Message-ID: <49C7DEA4.5070100@redhat.com>
References: <49C7DD3C.2020401@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C7DD3C.2020401@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Eric Sandeen wrote:

(oops, get Andi's email right!)

> I've noticed that on 2.6.29-rcX, with Andi's patch
> (ab4c1424882be9cd70b89abf2b484add355712fa, dm: support barriers on
> simple devices) barriers are still getting rejected on these simple devices.
> 
> The problem is in __generic_make_request():
> 
>                 if (bio_barrier(bio) && bio_has_data(bio) &&
>                     (q->next_ordered == QUEUE_ORDERED_NONE)) {
>                         err = -EOPNOTSUPP;
>                         goto end_io;
>                 }
> 
> and dm isn't flagging its queue as supporting ordered writes, so it's
> rejected here.
> 
> Doing something like this:
> 
> + if (t->barriers_supported)
> +         blk_queue_ordered(q, QUEUE_ORDERED_DRAIN, NULL);
> 
> somewhere in dm (I stuck it in dm_table_set_restrictions() - almost
> certainly the wrong thing to do) did get my dm-linear device to mount
> with xfs, w/o xfs complaining that its mount-time barrier tests failed.
> 
> So what's the right way around this?  What should dm (or md for that
> matter) advertise on their queues about ordered-ness?  Should there be
> some sort of "QUEUE_ORDERED_PASSTHROUGH" or something to say "this level
> doesn't care, ask the next level" or somesuch?  Or should it inherit the
> flag from the next level down?  Ideas?
> 
> Thanks,
> -Eric
> 

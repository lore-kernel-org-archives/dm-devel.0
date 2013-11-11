From: Hannes Reinecke <hare@suse.de>
Subject: Re: Fwd: Re: [PATCH] dm-mpath: push back requests
 instead of queueing
Date: Mon, 11 Nov 2013 12:44:06 +0100
Message-ID: <5280C306.7080805@suse.de>
References: <527CE4A1.90707@linux.vnet.ibm.com>
	<5280BEBC.4040500@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5280BEBC.4040500@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>
List-Id: dm-devel.ids

On 11/11/2013 12:25 PM, Steffen Maier wrote:
> =

> Regarding the general approach: Yes, please!
> =

> I was pondering on the very problematic memory pressure issues during tim=
es when there is no
> working path in any of the prio groups and I came to exactly the
same conclusion: dm-mpath
> should not pretend to be an arbitrarily fast block device and
consume requests from its block
> queue despite knowing that it cannot serve those requests any time
soon.
> =

Precisely.

> Requeuing sounds good and I hope this helps us getting the back pressure =
/ congestion such
> that blocking on the request queue mempool [1,2] will kick in to
prevent memory pressure on
> queue_if_no_path (for which "queue" has a slightly different
meaning with the change but I don't mind).
> =

Well, first of all we won't be accepting any more requests if the
first one is being requeued; blktrace shows a nice requeue game
going on (even with dd and O_DIRECT set) with just a single request
being requeued over and over again, until the 'queue_if_no_path'
scenario is gone.

> One thing I'm still wondering: Would there be any benefit of actually sto=
pping the request
> queue until at least one path becomes available again?
[blk_{start|stop}_queue()] I.e. stop
> in map_io() after we're sure there is no path in any prio group,
and restart in reinstate_path().
> =

Hehe. Thought about that, too.

Problem with that approach is the way multipath currently works.
Currently multipath does _not_ have a flag for 'all paths down and
queue_if_no_path is active, please requeue'.
It rather evaluates all possible paths during map_io, and only
if it determines that no paths are present and queue_if_no_path
is set it'll requeue the I/O.

So if we were to use start/stop queue here the block layer would
never trigger 'map_io', and multipath would never check the path
states and no I/O will be sent, ever.

blk_start/stop_queue works best if you have _alternative_ means
of setting those, besides the normal I/O path.
(It's original idea was to be used from LLDDs, after all).
When one of these functions is being used in the normal I/O path
things are becoming iffy really fast.

That said, it _would_ make sense to use blk_start/stop_queue for
pg_init; we cannot send I/O during pg_init anyway, so there's
no point in retrying I/O here.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

From: Hannes Reinecke <hare@suse.de>
Subject: Re: IO Ordering on Path Failover
Date: Wed, 05 Mar 2014 08:54:45 +0100
Message-ID: <5316D845.7030402@suse.de>
References: <CAPB7CupKZqW_tLZHcYsMS2eyqkFnmb0gDE2JrDoTqRpn43fsgg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPB7CupKZqW_tLZHcYsMS2eyqkFnmb0gDE2JrDoTqRpn43fsgg@mail.gmail.com>
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

On 02/28/2014 11:42 PM, Bob Bawn wrote:
> I am trying to understand how IO ordering safety is enforced with on
> path failover. This is new territory for me so forgive me if this is
> obvious. Consider the sequence:
> =

> 1. client writes(lba=3D0,val=3Dx) on path A.
> 2. multipath declares path A dead and retries write on path B
> 3. retried write on path B completes successfully and client get ack'd
> 4. client writes(lba=3D0,val=3Dy) on path B. It also completes
> successfully and is ack'd to client
> 5. write from (1) completes and corrupts data
> =

> It seems like multipath needs a guarantee at step 2 that the original
> write won't complete after path A has been declared down. I thought it
> would issue something like a LUN RESET on path B and that the response
> to that reset would indicate that it is safe to proceed. This page
> sort of supports that speculation:
> http://scst.sourceforge.net/mc_s.html
> =

No, that assumption is wrong.

Strict ordering is only guaranteed for commands submitted from the
HBA to the wire. Once it's in-flight there are _no_ guarantees about
ordering. Eg in a FC Fabric there might be several paths to the same
target, each of which might have a different latency.
So I/O on one path might actually be faster than the other one.
And with CNA's it's virtually impossible to guarantee any I/O
ordering due to several hardware queues involved etc.

Same goes for the linux block layer; the only _enforced_ ordering of
sorts is done by I/O being sent from the page-cache, as each page
can submit only one I/O at a time.
But as soon as you're using O_DIRECT you don't have any ordering
guarantees, either, and it's up to the application to ensure any
ordering requirements.

Which is also what all filesystems do; for any critical section they
wait for the I/O result before continuing.

So for failover any retries will be covered by the multipath layer,
and only the final I/O result will be returned to the upper layers,
rendering any multipath failover invisible.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

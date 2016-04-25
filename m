From: Hannes Reinecke <hare@suse.de>
Subject: Re: Upcall prioritizer for multipath
Date: Mon, 25 Apr 2016 09:49:50 +0200
Message-ID: <571DCC1E.5000908@suse.de>
References: <571A1D9E.1000805@emea.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <571A1D9E.1000805@emea.nec.com>
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

On 04/22/2016 02:48 PM, Oliver Mangold wrote:
> I'm working with JBODs and would like to access the disks inside through =

> dm-multipath. For performance reasons I would like to use to prioritizer =

> to pin individual disks to different paths. For testing purposes this =

> can be done with the weighted_path prioritizer, but for production use =

> this is unsatisfactory, as neither the device name nor the SCSI address =

> are persistent over reboots. Thus I wrote a new, simple prioritizer to =

> call an external program to determine what the prio should be. I would =

> like to ask if there is interest to include this (or something similar) =

> upstream (see attached patch).
> =

> Remark: After I did this, I've seen the wwn regex mode in the upcoming =

> 0.6 version, which would also provide a solution to the problem I =

> started out with. But using this would still means one had to recreate =

> multipath.conf each time one replaces a failed disk, so I still believe =

> having an external upcall makes sense in some situations.
> =

> Any thoughts?
> =

Ah, the good old days.
You do remember (of course, as you as a diligent developer would
have had a look through the archives, right?) that we original did
precisely that, namely using 'prio' as an external callout.

The reason why we moved away from this is a deadlock:
When all paths are down (ie the _one_ situation where you absolutely
_need_ multipath to work) you cannot reinstate any paths, as for
reinstating you would need to call the prio program.
Which happens to be an external program, which would need to be
loaded from disk.
Which is not available.
Say goodbye to your machine :-(

So we've moved to using a shared library mechanism, which can be
mlock()ed at boot to avoid these situations.

Hence I would really _not_ use this approach.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] dm-mpath: Extend path selector interface
 for	supporting Dell EqualLogic path selector
Date: Tue, 29 Jun 2010 10:32:02 +0200
Message-ID: <4C29AF82.7020703@suse.de>
References: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>, Parind Shah <Parind_Shah@Dell.com>, Jason Shamberger <Jason_Shamberger@Dell.com>, agk@redhat.com, Narendran Ganapathy <Narendran_Ganapathy@Dell.com>
List-Id: dm-devel.ids

Narendran Ganapathy wrote:
> This patch extends the dm-path-selector interface to allow path
> selectors to use extra information from the IO request when selecting a
> path.
> =

> Dell EqualLogic and other iSCSI storage arrays use a distributed
> frameless architecture.  In this architecture, the storage group
> consists of a number of distinct storage arrays ("members"), each having
> independent controllers, disk storage and network adapters.  When a LUN
> is created it is spread across multiple members.  The details of the
> distribution are hidden from initiators connected to this storage
> system.  The storage group exposes a single target discovery portal, no
> matter how many members are being used.  When iSCSI sessions are
> created, each session is connected to an eth port on a single member. =

> Data to a LUN can be sent on any iSCSI session, and if the blocks being
> accessed are stored on another member the IO will be forwarded as
> required.  This forwarding is invisible to the initiator.  The storage
> layout is also dynamic, and the blocks stored on disk may be moved from
> member to member as needed to balance the load.
> =

This sounds surprisingly similar to the upcoming 'Logical block dependent'
ALUA state of the upcoming T10 SPC-4.

Which begs the question if
a) is it implemented as such
and
b) if not why not?

And if it _is_ the logical block dependent ALUA state then yes, we
definitely need to update the multipath infrastructure for this.

However, given the good match between the 'REPORT REFERRALS' command
and the device-mapper table definitions I would rather propose to
use the output of 'REPORT REFERRALS' to create / modify the existing
multipath tables.

Currently we have a strict path-only mapping:

3600508b40008ddd70000600000620000 dm-0 HP,HSV300
[size=3D16G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 6:0:6:1 sde 8:64  [active][ready]
\_ round-robin 0 [prio=3D10][enabled]
 \_ 6:0:5:1 sdd 8:48  [active][ready]

or, in device-mapper output:
0 33554432 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:64 100 ro=
und-robin 0 1 1 8:48 100

With referrals we just need to adjust the 'start' and 'length' parameter to=
 create _several_
device-mapper tables, eg

0 16777216 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:64 100 ro=
und-robin 0 1 1 8:48 100
16777217 33554432 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:48=
 100 round-robin 0 1 1 8:64 100

which would route the first half of the resulting multipath device to path =
'8:64' and the second half
to path '8:48'.

Which I think is far more logical and in match with the current device-mapp=
er architecture.

But no, I don't have a patch for this. I've yet to see an array supporting =
referrals.
I might be tempted to do something here if I had one ...

And if your firmware does _not_ support referrals I would strongly advise t=
o reimplement your
mechanism in the context of referrals.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

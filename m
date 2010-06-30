From: "Jason Shamberger" <Jason_Shamberger@Dell.com>
Subject: Re: [PATCH 1/1] dm-mpath: Extend path selector interface
	for	supporting Dell EqualLogic path selector
Date: Wed, 30 Jun 2010 09:01:47 -0400
Message-ID: <86A3089001A44141B76B882059E7E53B05968D1F@M31.equallogic.com>
References: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
	<4C29AF82.7020703@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4C29AF82.7020703@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>
Cc: christophe varoqui <christophe.varoqui@free.fr>, Parind Shah <Parind_Shah@Dell.com>, Narendran Ganapathy <Narendran_Ganapathy@Dell.com>, agk@redhat.com
List-Id: dm-devel.ids

Hannes,

Thanks for the feedback.  I looked through the spec you mentioned, and the =
logical block dependent ALUA functionality is similar to what we are trying=
 to accomplish, however it is not a good fit with our storage array archite=
cture.  Our storage array exposes all LUNs through a single Target Port Gro=
up, whereas multiple TPGs are needed for the ALUA functionality.  The desig=
n choice of a single TPG was made to simplify the logic on the initiator si=
de.  The client does not need to decide which TPG(s) to connect to, it alwa=
ys connects to the single Target Port Group and the storage array decides w=
here to place the connections through use of iSCSI redirection.

Our goal with this project is to keep the simplicity aspects of our storage=
 array architecture, but add a path selector on the linux initiator to choo=
se the optimal path for each IO.  In this framework, we need additional inf=
ormation to be passed to the path selector to aid it in choosing the optima=
l path.
 =

Jason

-----Original Message-----
From: Hannes Reinecke [mailto:hare@suse.de] =

Sent: Tuesday, June 29, 2010 4:32 AM
To: device-mapper development
Cc: Parind Shah; Jason Shamberger; agk@redhat.com; Narendran Ganapathy; chr=
istophe varoqui
Subject: Re: [dm-devel] [PATCH 1/1] dm-mpath: Extend path selector interfac=
e for supporting Dell EqualLogic path selector

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

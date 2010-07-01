From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] dm-mpath: Extend path selector interface
 for	supporting Dell EqualLogic path selector
Date: Thu, 01 Jul 2010 09:01:55 +0200
Message-ID: <4C2C3D63.1030605@suse.de>
References: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
	<4C29AF82.7020703@suse.de>
	<86A3089001A44141B76B882059E7E53B05968CCF@M31.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <86A3089001A44141B76B882059E7E53B05968CCF@M31.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jason Shamberger <Jason_Shamberger@Dell.com>
Cc: device-mapper development <dm-devel@redhat.com>, Parind Shah <Parind_Shah@Dell.com>, Narendran Ganapathy <Narendran_Ganapathy@Dell.com>, agk@redhat.com, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Jason Shamberger wrote:
> Hannes,
> =

> Thanks for the feedback.  I looked through the spec you mentioned, and th=
e logical block dependent ALUA
> functionality is similar to what we are trying to accomplish, however it =
is not a good fit with our storage
> array architecture.  Our storage array exposes all LUNs through a single =
Target Port Group, whereas multiple
> TPGs are needed for the ALUA functionality.  The design choice of a singl=
e TPG was made to simplify the
> logic on the initiator side.  The client does not need to decide which TP=
G(s) to connect to, it always
> connects to the single Target Port Group and the storage array decides wh=
ere to place the connections
> through use of iSCSI redirection.
> =


I still think it should be possible to use the ALUA infrastructure here.
As you are using iSCSI redirection _all_ nodes in you storage cluster alrea=
dy will have to have
an iSCSI interface. To have your proposed functionality mapped on LB-ALUA y=
ou only have to
expose each of these interfaces, and have the mapping shared between all of=
 these
nodes (which you have to do anyway).

Assume two nodes A and B with iSCSI interfaces A1 and B1 both serving LUN1.
One part LUN1a residing on node A and the other part LUN1b residing on node=
 B.

Each node (and every interface on that node) would reside in it's own SCSI =
Target Port Group,
exposing _the entire_ LUN as LB-ALUA capable. Node A would mark LUN1a as 'a=
ctive/optimized' and
LUN1b as 'active/non-optimized', node B would mark LUN1b as 'active/optimiz=
ed' and LUN1a as
'active/non-optimized'. Any accesses to the 'non-optimized' sections would =
be forwarded
to the other nodes via iSCSI redirection.

In effect access would work even when connecting to a single node, and a go=
od speedup would
be observed when using an LB-ALUA capable initiator.

Yes, you would have to expose several TPGs (basically one group per node), =
but each LUN would
be present in each TPG. So it wouldn't matter much to the functionality her=
e.

> Our goal with this project is to keep the simplicity aspects of our stora=
ge array architecture,
> but add a path selector on the linux initiator to choose the optimal path=
 for each IO.
> In this framework, we need additional information to be passed to the pat=
h selector to
> aid it in choosing the optimal path.
>  =

But you have to fight for it, as you're the only one using this infrastruct=
ure.
If you would support LB-ALUA you wouldn't be alone in this, as we (as the l=
inux
community) would have to support it eventually.
Plus it's simply is more fun to code against an official standard; propriet=
ary
interfaces are a pain to support properly.

And I'd be glad to help in converting multipathing to make it LB-ALUA capab=
le,
but my interest in proprietary interfaces is close to zero :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

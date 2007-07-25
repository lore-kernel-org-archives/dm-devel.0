From: Hannes Reinecke <hare@suse.de>
Subject: Re: Designing a new prio_callout
Date: Wed, 25 Jul 2007 13:37:05 +0200
Message-ID: <46A735E1.4070206@suse.de>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Ethan John wrote:
> I hope I found the right list for this.
>=20
> My company is developing an iSCSI solution, and in looking into Linux
> compatability and performance, we're concerned that our architecture
> doesn't
> play well with the existing multipath configurations that are available=
.
>=20
> We cannot support what Linux calls multibus, or what the fiber world se=
ems
> to call active/active. We will need folks to configure failover
> exclusively.
>=20
> It appears that the current multipathing failover configuration assigns=
 a
> priority to each path (by default, just assigns the same priority to al=
l
> paths). This is bad for us, as we're presenting iSCSI targets across
> multiple machines in a cluster; ideally, a user will have multiple devi=
ces,
> each with a separate path to a separate machine, with failover to the o=
ther
> machines in the cluster. The default setup of multipath will map all
> connections to a single machine, which is no load balancing at all.
>=20
> I've fooled around with various other values for default_prio_callot
> (besides the /bin/true), and the one that seems to work best is actuall=
y
> mpath_prio_random.
>=20
Argl.

> In fact, mpath_prio_random would actually work perfectly, except that i=
t
> seems to swap path priorities extremely often -- several times a minute=
. So
> my company needs to develop a new script, probably much like the
> mpath_prio_emc or mpath_prio_netapp ones, so that we can hint at load
> balancing across devices with failover as the multipathing policy.
>=20
> I've been completely unable to find documentation on this. Where might =
I
> look? Is this even the right direction in which to be looking for a
> solution to this problem?
>=20
Have you looked a ALUA ?
It's in SPC-3 section 5.8: 'Target port group access states'.

This is the preferred way of handling these things.
And is supported by multipath-tools.

Mind you, only implicit ALUA is supported. Explicit ALUA
support will be implemented, too, once someone actually
uses it :-)

Please do not design your own way of handling failover. This
has shown too many difficulties in the past.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

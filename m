From: Hannes Reinecke <hare@suse.de>
Subject: Re: rdac priority checker changing priorities
Date: Thu, 30 Apr 2009 08:25:02 +0200
Message-ID: <49F9443E.7040109@suse.de>
References: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>
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

Hi Lucas,

Lucas Brasilino wrote:
> Hi
>=20
> I don't know if I'm misundertanding something. I've got an DS4700 and I=
'm
> switching from RDAC[1] to multipath, since it's natively supported in
> the distribution I use
> here (SLES 10 SP2).
>=20
> Since RDAC[1] works perfect, I'm trying to use 'rdac' priority in multi=
path.
>=20
> My /etc/multiconf.conf is quite tiny, since I'm building it step-by-ste=
p :-) :
>=20
> blacklist {
> 	devnode "^sda[0-9]*"
> }
>=20
> defaults {
> 	user_friendly_names	yes
> 	prio			rdac
> 	path_checker		tur
> }
>=20
> multipaths {
> 	multipath {
> 		wwid	3600a0b8000327b900000107549f85224
> 		alias	mpath0
> 	}
> }
>=20
> I think that using 'prio rdac' makes multipath to use 'mpath_prio_rdac'=
 tool.
>=20
>  # multipath -v2 -ll
> mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
> [size=3D140G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
> \_ round-robin 0 [prio=3D6][active]
>  \_ 9:0:0:0  sdb 8:16  [active][ready]
> \_ round-robin 0 [prio=3D1][enabled]
>  \_ 10:0:0:0 sdc 8:32  [active][ghost]
>=20
> So the first path has priority 6, as I can confirm:
>=20
> # mpath_prio_rdac /dev/sdb
> 6
> # mpath_prio_rdac /dev/sdc
> 1
>=20
> After the first path (prio=3D6) failure I get:
>=20
> # multipath -v2 -ll
> sdb: rdac prio: inquiry command indicates error
> mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
> [size=3D140G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 9:0:0:0  sdb 8:16  [failed][faulty]
> \_ round-robin 0 [prio=3D1][enabled]
>  \_ 10:0:0:0 sdc 8:32  [active][ghost]
>=20
> Ok.. working great, activating the second path. But after the faulty
> path is restored:
>=20
> # multipath -v2 -ll
> mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
> [size=3D140G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
> \_ round-robin 0 [prio=3D2][enabled]
>  \_ 9:0:0:0  sdb 8:16  [active][ghost]
> \_ round-robin 0 [prio=3D5][active]
>  \_ 10:0:0:0 sdc 8:32  [active][ready]
>=20
> Second path is now priority!!! And of course does not fails back! By
> the way, my LUN is configured in
> DS4700 in sort a way that the first path *is* the path to preferred con=
troller.
>=20
> I think path priorities should not change. If so first path goes back
> to 'active' status.
> Am I misunderstanding something ? Or messing things up?
>=20
You are using an old version of multipathing for SLES10 SP2.
This had a bug triggering priority inversion on RDAC.
Please update to the latest version.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

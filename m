From: Hannes Reinecke <hare@suse.de>
Subject: Re: IBM (Adaptec) DS400 SAN support - sponsorship
Date: Tue, 04 Jul 2006 09:12:59 +0200
Message-ID: <44AA14FB.8080307@suse.de>
References: <1151939929.3663.41.camel@wolfhound.placemark.pmi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1151939929.3663.41.camel@wolfhound.placemark.pmi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kevin Taylor <ktaylor@placemark.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Kevin Taylor wrote:
> Hello devs,
>=20
> I'm hoping that I can find the right person to help me on this list, as
> it seems this list is, by far, the greatest collection of people with
> expertise regarding dm-multipath.
>=20
> My desire:
>=20
> To locate a person who can write a hardware handler for the DS400 that
> will allow proper active/passive fail-over/fail-back, which we would be
> happy to sponsor financially (for contribution back to the project, of
> course).
>=20
> My situation:
>=20
> Our company has an existing IBM DS400 SAN that we are trying to deploy
> as part of a Oracle RAC project.  In doing testing and analysis of the
> device and proper configuration of it for this purpose, I have learned
> that in a two controller configuration, this device is active/passive,
> and that in dm-multipath this results in the following configuration
> profile (from "multipath -ll" with all controllers connected):
>=20
> ---------------------------------------------
>=20
> ora_admin (20000d126733eaf14)
> [size=3D10 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:3 sde 8:64  [active][faulty]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:1:3 sdk 8:160 [active][ready]
>=20
> 20000d126733eaf17
> [size=3D10 MB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:0 sdb 8:16  [active][faulty]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:1:0 sdh 8:112 [active][ready]
>=20
> ora_data1 (20000d126733eaf10)
> [size=3D200 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:5 sdg 8:96  [active][faulty]
> \_ round-robin 0 [prio=3D1][enabled]
>  \_ 1:0:1:5 sdm 8:192 [active][ready]
>=20
> ora_archive (20000d126733eaf15)
> [size=3D50 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:4 sdf 8:80  [active][faulty]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:1:4 sdl 8:176 [active][ready]
>=20
> ora_redo2 (20000d126733eaf0b)
> [size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:0:2 sdd 8:48  [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:2 sdj 8:144 [active][faulty]
>=20
> ora_redo1 (20000d126733eaf0a)
> [size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:0:1 sdc 8:32  [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:1 sdi 8:128 [active][faulty]
>=20
> ---------------------------------------------
>=20
> And when controller 1 is unplugged, the configuration does the
> following:
>=20
> ora_admin (20000d126733eaf14)
> [size=3D10 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:3 sde 8:64  [active][faulty]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:1:3 sdk 8:160 [active][ready]
>=20
> 20000d126733eaf17
> [size=3D10 MB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:0 sdb 8:16  [active][faulty]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:1:0 sdh 8:112 [active][ready]
>=20
> ora_data1 (20000d126733eaf10)
> [size=3D200 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:5 sdg 8:96  [failed][faulty]
> \_ round-robin 0 [prio=3D1][enabled]
>  \_ 1:0:1:5 sdm 8:192 [active][ready]
>=20
> ora_archive (20000d126733eaf15)
> [size=3D50 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:4 sdf 8:80  [failed][faulty]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:1:4 sdl 8:176 [active][ready]
>=20
> ora_redo2 (20000d126733eaf0b)
> [size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [active]
>  \_ 1:0:0:2 sdd 8:48  [failed][faulty]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:2 sdj 8:144 [active][faulty]
>=20
> ora_redo1 (20000d126733eaf0a)
> [size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:1 sdc 8:32  [failed][faulty]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:1 sdi 8:128 [failed][faulty]
>=20
> --------------------------------------------------
>=20
> And when controller 2 is unplugged, the configuration does the
> following:
>=20
> ora_admin (20000d126733eaf14)
> [size=3D10 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:3 sde 8:64  [active][faulty]
> \_ round-robin 0 [active]
>  \_ 1:0:1:3 sdk 8:160 [failed][faulty]
>=20
> 20000d126733eaf17
> [size=3D10 MB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:0 sdb 8:16  [active][faulty]
> \_ round-robin 0 [active]
>  \_ 1:0:1:0 sdh 8:112 [failed][faulty]
>=20
> ora_data1 (20000d126733eaf10)
> [size=3D200 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:5 sdg 8:96  [active][faulty]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:5 sdm 8:192 [active][faulty]
>=20
> ora_archive (20000d126733eaf15)
> [size=3D50 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [enabled]
>  \_ 1:0:0:4 sdf 8:80  [active][faulty]
> \_ round-robin 0 [active]
>  \_ 1:0:1:4 sdl 8:176 [failed][faulty]
>=20
> ora_redo2 (20000d126733eaf0b)
> [size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:0:2 sdd 8:48  [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:2 sdj 8:144 [active][faulty]
>=20
> ora_redo1 (20000d126733eaf0a)
> [size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [prio=3D1][active]
>  \_ 1:0:0:1 sdc 8:32  [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 1:0:1:1 sdi 8:128 [failed][faulty]
>=20
> --------------------------------------------------
>=20
> I believe that without a proper hardware handler to instruct the DS400
> to activate the passive controller and shift all LUNS in a timely
> fashion, that this storage unit will not be able to be used in a
> multipath manner for controller failover.  Of course, it's quite
> possible that I am wrong, and there may be another way to make this
> active/passive configuration work without a hardware handler, and I'd b=
e
> very happy to hear about any alternatives anyone may suggest.
>=20
It looks as it if this is an RDAC style controller.
If you have the latest sg_utils ready you can try to issue an

sg_inq -e /dev/sgX

If there are any pages listed within the 0xc0 - 0xcf range there is a=20
good change this is such a system.
And

sg_inq -e -p=3D0xc2 /dev/sgX

should lists some meaningful info.

Unfortunately there is currently only limited support for RDAC style=20
controllers; you can try using the 'prio_tpc' priority program; this=20
will allow you at least to access the storage properly.
To enable proper failover you'll have to ensure to place the storage in=20
'AVT' mode (Automatic Volume Transfer); but you'll have to look up in=20
the manual on how to do that.
Proper RDAC mode requires an hardware handler; the current=20
multipath-tools / device-mapper does not implement this.

> Would anyone here be willing to talk with me about our sponsorship of
> expanding the supported hardware list for dm-multipath to include this
> device?  Does anyone know a person not already on this list who might b=
e
> a good possibility as a developer for such a project?
>=20
I have started to implement such an hardware handler, but haven't=20
progressed any further due to other tasks.

Drop me a mail if you'd like to support the development.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

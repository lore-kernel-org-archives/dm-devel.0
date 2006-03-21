From: egoggin@emc.com
Subject: RE: multipath -l displays nothing
Date: Tue, 21 Mar 2006 12:08:47 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B13A@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Two problems are very noticeable, pgpolicy should be group_by_prio
instead of failover and the get_prio callout should be set to
/sbin/mpath_prio_emc.=20

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com]=20
> Sent: Tuesday, March 21, 2006 11:56 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] multipath -l displays nothing
>=20
> Hello!
>=20
> I have a Dell PE1850 with a QLA2342 hooked up to a CX600 with 4
> paths. The Dell is running Debian Sarge with a custom rolled 2.6.16
> kernel. I am using multipath-tools 0.4.7 (compiled from source).
>=20
> Simply put, my problem is this:
>=20
> laatikko:~# multipath -l
> laatikko:~#
>=20
> I'm not going to paste the entire output of multipath -v3 here since
> it is 4504 lines long, but here is a clip of what I suspect might be
> the problem:
>=20
> 66:128 ownership set to mpath14
> sdao: not found in pathvec
> sdao: mask =3D 0xc
> sdao: path checker =3D emc_clariion (controler setting)
> sdao: state =3D 2
> sdao: getprio =3D NULL (internal default)
> sdao: prio =3D 1
> 68:16 ownership set to mpath14
> sdbn: not found in pathvec
> sdbn: mask =3D 0xc
> sdbn: path checker =3D emc_clariion (controler setting)
> sdbn: state =3D 2
> sdbn: getprio =3D NULL (internal default)
> sdbn: prio =3D 1
> 8:80 ownership set to mpath14
> sdf: not found in pathvec
> sdf: mask =3D 0xc
> sdf: path checker =3D emc_clariion (controler setting)
> sdf: state =3D 2
> sdf: getprio =3D NULL (internal default)
> sdf: prio =3D 1
> 65:144 ownership set to mpath14
> sdz: not found in pathvec
> sdz: mask =3D 0xc
> sdz: path checker =3D emc_clariion (controler setting)
> sdz: state =3D 2
> sdz: getprio =3D NULL (internal default)
> sdz: prio =3D 1
> mpath14: pgfailback =3D -2 (config file default)
> mpath14: pgpolicy =3D failover (controler setting)
> mpath14: selector =3D round-robin 0 (controler setting)
> mpath14: features =3D 0 (controler setting)
> mpath14: hwhandler =3D 1 emc (controler setting)
> mpath14: rr_weight =3D 1 (internal default)
> mpath14: minio =3D 1000 (config file default)
> mpath14: no_path_retry =3D NONE (internal default)
> mpath14: set ACT_CREATE (map does not exist)
> mpath14: set ACT_CREATE (map does not exist)
> mpath14: domap (0) failure for create/reload map
>          ^^^^^^^^^^^^
>          This shouldn't happen, right?
>=20
> Any ideas on how to fix this?
>=20
> --=20
> Jussi H=E4m=E4l=E4inen         +358 3 3551 8086   University of Tampere
> System administrator     +358 50  5900641   Computer Centre
> ccjuha@uta.fi            TietoPinni  4166  =20
> http://www.uta.fi/laitokset/tkk
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20

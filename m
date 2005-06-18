From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: regarding path failback using HSV110 array.
Date: Sat, 18 Jun 2005 19:39:47 +0200
Message-ID: <1119116387.1515.61.camel@zezette>
References: <3456F611E9329441B12FBB24447B3FA00220F911@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3456F611E9329441B12FBB24447B3FA00220F911@bgeexc01.asiapacific.cpqcorp.net>
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

/var/log/message log would be good to see.

Regards,
cvaroqui

On ven, 2005-06-17 at 15:11 +0530, Murthy, Narasimha Doraswamy (STSD)
wrote:
> In the previous logs, the multipath daemon wasn=E2=80=99t running. Atta=
ched is
> the new log file, which has the path checker logs too.
>=20
> -Murthy
>=20
> =20
>=20
>                                   =20
> ______________________________________________________________________
> From: Murthy, Narasimha Doraswamy (STSD)=20
> Sent: Friday, June 17, 2005 1:02 PM
> To: 'dm-devel@redhat.com'
> Subject: regarding path failback using HSV110 array.
>=20
>=20
> =20
>=20
> Hi Alasdair,
>=20
> As per yesterday=E2=80=99s teleconf, I am sending the snapshot of
> the /var/log/messages, which has the messages logged when testing the
> basic failback functionality.  The testing is conducted on the host
> with RHEL U1 and single controller of HP Storageworks HSV110 array. As
> each HSV110 controller has 2 ports, we effectively see 2 paths per
> lun. I am using 0.4.5.44 version of multipath tools. =20
>=20
> =20
>=20
> Following is the observation during testing the path failback.
>=20
> =20
>=20
> a) When the path is made unavailable (/dev/sdd) for a logical device
> =E2=80=9Cmp1=E2=80=9D on a  multipath target, the status of the path be=
comes
> [faulty][active]
>=20
> =20
>=20
> mp1
>=20
> [size=3D1 GB][features=3D"0"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [active][best]
>=20
>   \_ 0:0:0:1 sda  8:0     [faulty][active]
>=20
> \_ round-robin 0 [enabled]
>=20
>   \_ 1:0:0:1 sdd  8:48    [ready][active]
>=20
> =20
>=20
> b) When an dd is executed on /dev/mapper/mp1 (dd if=3D/dev/zero
> of=3D/dev/devmapper/mp1), the state of the paths is as follows
>=20
> mp1
>=20
> [size=3D1 GB][features=3D"0"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [enabled]
>=20
>   \_ 0:0:0:1 sda  8:0     [faulty][failed]
>=20
> \_ round-robin 0 [active][best]
>=20
>   \_ 1:0:0:1 sdd  8:48    [ready ][active]
>=20
> =20
>=20
> =20
>=20
> c) Now if the path (/dev/sda) is made available for the same logical
> device, the status is as follows
>=20
> mp1
>=20
> [size=3D1 GB][features=3D"0"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [enabled]
>=20
>   \_ 0:0:0:1 sda  8:0     [ready ][failed]
>=20
> \_ round-robin 0 [active][best]
>=20
>   \_ 1:0:0:1 sdd  8:48    [ready ][active]
>=20
> =20
>=20
> Note the path =E2=80=9C/dev/sda=E2=80=9D has become [ready][failed] not
> [ready][active]. For this to change to [ready][active], =E2=80=9Cmultip=
ath =E2=80=93
> v0=E2=80=9D needs to be executed manually.
>=20
> =20
>=20
> d) Now if path =E2=80=9C/dev/sdd=E2=80=9D is made unavailable, then if =
=E2=80=9Cdd=E2=80=9D is run
> on /dev/mapper/mp1, it returns with input/output error, as none of the
> path will be in [ready][active] state. The following is the state now:
>=20
> =20
>=20
> mp1
>=20
> [size=3D1 GB][features=3D"0"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [enabled][best]
>=20
>   \_ 0:0:0:1 sda  8:0     [ready ][failed]
>=20
> \_ round-robin 0 [enabled]
>=20
>   \_ 1:0:0:1 sdd  8:48    [faulty][failed]
>=20
> =20
>=20
> =20
>=20
> If =E2=80=9Cmultipath =E2=80=93v0=E2=80=9D executed from the command pr=
ompt the states get
> updated properly as
>=20
> =20
>=20
> mp1
>=20
> [size=3D1 GB][features=3D"0"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [active][best]
>=20
>   \_ 0:0:0:1 sda  8:0     [ready ][active]
>=20
> \_ round-robin 0 [enabled]
>=20
>   \_ 1:0:0:1 sdd  8:48    [faulty][active]
>=20
> =20
>=20
> After this I will be able to do IO using =E2=80=9Cdd=E2=80=9D.   How do=
 we make the
> path state update properly with out manually invoking =E2=80=9Cmultipat=
h =E2=80=93
> v0=E2=80=9D?=20
>=20
> I am not sure on how to get the debug build of multipath and
> multipathd binaries, if the information in the messages.txt is
> insufficient, I need to test with the debug build and send the new
> log.
>=20
> =20
>=20
> Any help in resolving this problem is appreciated.
>=20
> =20
>=20
> Thanks and regards
>=20
> Murthy
>=20
> =20
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20
christophe varoqui <christophe.varoqui@free.fr>

From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: multipath - AAArgh! How do I turn "features=1
	queue_if_no_path" off?
Date: Wed, 30 Sep 2009 10:22:29 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474E780A7@cosmail01.lsi.com>
References: <4AC333E2.9090005@Calva.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC333E2.9090005@Calva.COM>
Content-Language: en-US
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

You will see "features=3D1 queue_if_no_path" if you have one of the follo=
wing entry in your multipath.conf.

1. Features		"1 queue_if_no_path"

  Or

2. no_path_retry           5


The first option will queue the i/o forever. The second option will queue=
 the i/o only for 5 polling intervals. But, queue_if_no_path will show up=
 as enabled if one of the above is true.

Try "no_path_retry    fail"  then you will not see this feature in your m=
ultipath.conf.

Thanks
Babu Moger=20

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of John Hughes
> Sent: Wednesday, September 30, 2009 5:33 AM
> To: device-mapper development
> Subject: [dm-devel] multipath - AAArgh! How do I turn "features=3D1
> queue_if_no_path" off?
>=20
> I want to turn queue_if_no_path off and use
>=20
>                 polling_interval        5
>                 no_path_retry           5
>=20
> because I've had problems with things hanging when a lun "vanishes" (I
> deleted it from my external raid box).
>=20
> But whatever I put in /etc/multipath.conf when I do a "multipath -l" or
> "multipath-ll" it shows:
>=20
> 360024e80005b3add000001b64ab05c87dm-28 DELL    ,MD3000
> [size=3D68G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
> \_ round-robin 0 [prio=3D3][active]
>  \_ 3:0:1:13 sdad 65:208 [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 4:0:0:13 sdas 66:192 [active][ghost]
>=20
>=20
> How on earth do I turn this damn thing off?
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

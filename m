From: "Herr, Manuel" <mher@msc-ge.com>
Subject: AW: multipathd failback
Date: Wed, 25 Oct 2006 09:02:11 +0200
Message-ID: <C514D40EFDB5C84083DAEB84A1186A8F94CCE1@msc-ex02.msc-ge.mscnet>
References: <453F0902.6030902@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <453F0902.6030902@Voltaire.COM>
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

On which Hardware? (HBAs, SAN)?

> -----Urspr=FCngliche Nachricht-----
> Von: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] Im Auftrag von Yonathan Cohen
> Gesendet: Mittwoch, 25. Oktober 2006 08:50
> An: dm-devel@redhat.com
> Betreff: [dm-devel] multipathd failback
>=20
> Hello.
> My "multipathd" daemon does not FailBack It does not check=20
> the availability of a failed path and of course does not=20
> reinstate it My configuration is as follows:
> cat /etc/multipath.conf
>=20
> defaults {
>=20
>         failback        immediate
> }
> I am using the following packages:
> multipath-tools-0.4.5-0.11
> device-mapper-1.01.01-1.6
> I have them installed on a SUSE LINUX Enterprise Server 9=20
> (x86_64) sp-3 With kernel version: 2.6.5-7.244-smp Please help.
> Thanks.
>=20
> ____________________________________________________________
>=20
> Cohen Yonatan   |  +972-9-9718607 (o) =20
>=20
> Software. Eng,  Storage group
>=20
> Voltaire - _The Grid Backbone_
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20

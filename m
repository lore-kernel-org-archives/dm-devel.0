From: Edward Goggin <egoggin@emc.com>
Subject: RE: multipath and san fabric
Date: Tue, 14 Nov 2006 15:41:44 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D154D@CORPUSMX40A.corp.emc.com>
References: <200611140809.21110.jslittl@hendricks.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <200611140809.21110.jslittl@hendricks.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jslittl@hendricks.org, dm-devel@redhat.com
Cc: James.Smart@emulex.com
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of John Little
> Sent: Tuesday, November 14, 2006 8:09 AM
> To: dm-devel@redhat.com
> Cc: James.Smart@emulex.com; goggin, edward
> Subject: RE: [dm-devel] multipath and san fabric
>=20
> Hi all
>=20
> Wow.  thanks for the responses...
>=20
> James Smart <James.Smart@Emulex.Com> wrote on 11/13/2006 02:54:15 PM:
>=20
> > >>> Example 2:
> > >>>    Fabric A contains HBA1, TargetPort1, and TargetPort3.=20
> > >>> Typically a zone
> > >>>      would exist within Fabric A that contains these 3 ports.
> > >>>    Fabric B contains HBA2, TargetPort2, and TargetPort4.=20
> > >>> Typically a zone
> > >>>      would exist within Fabric B that contains these 3 ports.
> > >>>    The storage array contains 2 controllers, with 2 ports per=20
> > >>> controller.
> > >>>      Meaning TargetPort1 and TargetPort2 are on controller A,=20
> > >>> and TargetPort3
> > >>>      and TargetPort4 are on controller B. The ports are cross=20
> > >>> connected on
> > >>>      the fabrics for redundancy. All storage can be seen from=20
> > >>> any port.
> > >>>    --
> > >>>    This would ahve 4 DM paths
> > >>>    The I_T nexus's are:
> > >>>       HBA1_TargetPort1
> > >>>       HBA1_TargetPort3
> > >>>       HBA2_TargetPort2
> > >>>       HBA2_TargetPort4
>=20
> Ok I'm new to SAN and multipathing so maybe it's just the way=20
> it is worded. =20
> Here is what we have and the instructions that were given to me.
> ####
> FCSW00 xxx.xxx.xxx.233 Fabric A=20
> FCSW01 xxx.xxx.xxx.234 Fabric B
> FCSW02 xxx.xxx.xxx.235 Fabric A
> FCSW03 xxx.xxx.xxx.236 Fabric B
>=20
> Summary: One HBA is attached to each fabric; two zones per=20
> HBA. One is zoned=20
> to a port on SPA and one is zoned to a port on SPB We have a=20
> CX600 which has=20
> 4 ports per SP. So, it could be zoned to SPA0 (0-3)and SPB0(0-3)
> ####
>=20
> If I understand correctly what I have is Example 2 (typo=20
> corrected).

Yes, you have a modified version of James's "Example 2",
since you have 4 ports per CLARiiON controller instead of 2.=20

> Then I=20
> would, for an hba connected to Fabric A on a port on FCSW00,=20
> setup a zone on=20
> FCSW00 and another on FCSW02.  The same would apply for the=20
> hba in Fabric B=20
> using FCSW01 and FCSW03.

You need only configure a single zone for the active zone set
for each fabric as shown below using your terminology from above
to refer to the CLARiiON SP (A,B) and ports (0,1,2,3).

      Fabric A zone =3D {HBA1, SPA0, SPB0}
	Fabric B zone =3D {HBA2, SPA1, SPB1}

>=20
> Is this correct or am I still lost?
>=20
> Thanks,
> John
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
>=20

From: Edward Goggin <egoggin@emc.com>
Subject: RE: multipath and san fabric
Date: Mon, 13 Nov 2006 14:39:08 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D153F@CORPUSMX40A.corp.emc.com>
References: <4558C4E9.9020901@emulex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4558C4E9.9020901@emulex.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Smart@Emulex.Com, dm-devel@redhat.com, jslittl@hendricks.org
List-Id: dm-devel.ids

You may want to also cross connect across the 2 target
controllers (A,B) in case 2.  Doing so provides more
redundancy for asymmetric arrays and better resource
utilization in case of a failure of either an HBA or
target controller which would otherwise prevent
utilization of the other HBA or target controller
for that LU when load sharing I/O across multiple
paths.

So the I_T nexus's for the 4 paths are:

	HBA1_TargetPort1
	HBA1_TargetPort3
	HBA2_TargetPort2
	HBA2_TargetPort4

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of James Smart
> Sent: Monday, November 13, 2006 2:18 PM
> To: jslittl@hendricks.org; device-mapper development
> Subject: Re: [dm-devel] multipath and san fabric
>=20
> If the hba's are on different fabrics - why would you ever put an hba
> that is not in the fabric in a zone in that fabric ?  (e.g.=20
> your second
> option makes no sense).
>=20
> If you are stating that the 2hba's are on different fabrics=20
> (and in zones
> within those fabric) - but they are seeing the same Storage=20
> device on both
> fabrics - then the dm config (note: I'm not talking about=20
> zoning anymore)
> would have a path per I_T nexus. I state it this way to=20
> account for dual-ported
> controllers, which may appear as separate targets, may exist=20
> within the fabric.
>=20
> Example 1:
>    Fabric A contains HBA1 and TargetPort1. Typically a zone=20
> would exist
>      within Fabric A that contains these 2 ports.
>    Fabric B contains HBA2 and TargetPort2. Typically a zone=20
> would exist
>      within Fabric B that contains these 2 ports.
>    The storage array contains 2 controllers with 1 port per=20
> controller, or
>      is a single controller with 2 ports. Either way, the two=20
> ports are
>      TargetPort1 and TargetPort2, are on the same array, and=20
> all storage
>      can be seen from any port.
>    --
>    This would have 2 DM paths.
>    The I_T nexus's are:
>       HBA1_TargetPort1
>       HBA2_TargetPort2
>=20
> Example 2:
>    Fabric A contains HBA1, TargetPort1, and TargetPort3.=20
> Typically a zone
>      would exist within Fabric A that contains these 3 ports.
>    Fabric B contains HBA2, TargetPort2, and TargetPort4.=20
> Typically a zone
>      would exist within Fabric B that contains these 3 ports.
>    The storage array contains 2 controllers, with 2 ports per=20
> controller.
>      Meaning TargetPort1 and TargetPort2 are on controller A,=20
> and TargetPort3
>      and TargetPort4 are on controller B. The ports are cross=20
> connected on
>      the fabrics for redundancy. All storage can be seen from=20
> any port.
>    --
>    This would ahve 4 DM paths
>    The I_T nexus's are:
>       HBA1_TargetPort1
>       HBA1_TargetPort2
>       HBA2_TargetPort3
>       HBA2_TargetPort4
>=20
> -- james
>=20
> John Little wrote:
> > Hi all
> >=20
> > Admittedly this is not the correct forum for this question=20
> but I have googled=20
> > this and the only people I have to ask around here are=20
> people who won't touch=20
> > it because it is Linux.
> >=20
> > My question is this:  I'm using SLES10 with two emulex=20
> hbas, one connected to=20
> > fabric a and one to fabric b.  When zoning the switch for=20
> the hbas do I put=20
> > in only one path to the fabric per hba or do I put in two,=20
> one to each of the=20
> > separate fabrics?
> >=20
> > Again I realize this is not exactly the correct forum but=20
> since I couldn't=20
> > find an answer anywhere else I figured you guys would be the most=20
> > knowledgeable.  If there are some docs somewhere that you=20
> could point me to I=20
> > would appreciate it.
> >=20
> > John
> >=20
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
>=20

From: Lavannya <swap_project@yahoo.com>
Subject: Re: Question regarding multipath WWID
Date: Wed, 10 Jun 2009 13:35:14 -0700 (PDT)
Message-ID: <675831.69032.qm@web32006.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Until  and unless i know   how the WWID is being generated , it is=20

tough to relate what the document is describing. Also to identify the

shared  luns , I need to know more about WWID.

thanks



--- On Wed, 6/10/09, Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Subject: Re: [dm-devel] Question regarding multipath WWID
> To: "device-mapper development" <dm-devel@redhat.com>
> Date: Wednesday, June 10, 2009, 3:54 PM
> What is your purpose for needing to
> know how WWID is generated ?
>=20
> Do you want to identify and name them the same in both the
> nodes ?
>=20
> On Wed, 2009-06-10 at 12:01 -0700, Lavannya wrote:
> > Hi,
> >=20
> > Recently=A0 I am trying to test few=A0 luns with
> multipath , in two of my
> >=20
> > test server.=A0 I worked throughly with PowerPath.
>=20
> >=20
> > I have few questions on multipath:
> >=20
> >=A0 =A0=A0=A0-=A0 what is the logic
> redhat is using=A0 to create the WWID
> >=A0 =A0 =A0 =A0 and what are the fields
> involved
> >=20
> >=A0 =A0=A0=A0-=A0 I am trying to test
> with the shared luns=A0 (devices) between
> >=A0 =A0 =A0 =A0 two nodes.=A0 How i will
> identify=A0 the device id in multipath.
> >=A0 =A0 =A0 =A0 Though=A0 as per Redhat
> ,=A0 they are telling WWID is the identifier.
> >=A0 =A0 =A0 =A0 But how i will identify the
> device id in the WWID?
> >=A0 =A0 =A0 =A0 It is very much needed
> specially for shared luns.=A0 In PowerPath,=20
> >=A0 =A0 =A0 =A0 generally=A0 all the
> devices=A0 are=A0 identified=A0 by the=20
> >=A0 =A0 =A0 =A0 lun id=A0 /device
> id=A0 then ,
> >=A0 =A0 =A0 =A0 I use the Pseudo name
> (linux), for configuring the devices.=A0 I will
> >=A0 =A0 =A0 =A0 assume=A0 that WWID is
> similar=A0 as Pseudoid. If not, pl. correct me.
> >=20
> >=A0 =A0=A0=A0-=A0 Where can i match the
> device id in the WWID..
> >=20
> > It will be really appreciated=A0 , if someone
> clears=A0 all my questions.
> >=20
> > Thanks in advance.
> >=A0 =A0=A0=A0
> >=20
> >=A0 =A0=A0=A0
> >=20
> >=20
> >=A0 =A0 =A0=A0=A0
> >=20
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20


     =20

From: silentphoebus <silentphoebus@voila.fr>
Subject: RE: RE: RAID5 compatibility.
Date: Wed, 27 Feb 2008 17:59:43 +0100 (CET)
Message-ID: <31325860.300541204131583899.JavaMail.www@wwinf4618>
Reply-To: silentphoebus@voila.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Thank you for your answer.
I can't manage the raid5 to work,
here are what what i do :

dmraid -s give me :
*** Group superset isw_hdaagdcbc
--> Subset
name   : isw_hdaagdcbc_RAID5
size   : 1465177344
stride : 128
type   : raid5_la
status : ok
subsets: 0
devs   : 4
spares : 0

dmraid -tay give me :
isw_hdaagdcbc_RAID5: 0 1465177344 raid45 core 2 131072 nosync raid5_la 1 =
128 4 -1 /dev/sda 0 /dev/sdb 0 /dev/sdc 0 /dev/sde 0

and dmraid -ay give me :
ERROR: device-mapper target type "raid45" not in kernel
and the /dev/mapper/ show only the control file.

i have try with the from the cvs tree and the current tools.
i use the latest kernel with raid456 compiled as modules and loaded.

What should i do to make the raid5 work.
Thank you very much.
>=20
>=20
> > Message du 26/02/08 =C3=A0 10h00
> > De : "Cetnerowski, Adam" <adam.cetnerowski@intel.com>
> > A : silentphoebus@voila.fr, "device-mapper development" <dm-devel@red=
hat.com>
> > Copie =C3=A0 :=20
> > Objet : RE: [dm-devel] RAID5 compatibility.
> >=20
> >=20
> >=20
> > > -----Original Message-----
> > > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.c=
om]
> > On > Behalf Of silentphoebus
> > > Sent: Monday, February 25, 2008 8:07 PM
> > > To: dm-devel@redhat.com
> > > Subject: [dm-devel] RAID5 compatibility.
> > >
> > > Hi all,
> > > i found a lot of informations on the internet for intel software ra=
id5
> > > with ICH controler.
> > > So, the best is maybe to ask here.
> > > Is it compatible with the dmraid mapper or not ?
> > > Thank you for taking time to read.
> >=20
> > Hi,
> >=20
> > The software RAID 5 does indeed use device mapper. I would like to no=
te
> > that at the moment it is in the experimental stage, while we work on
> > some of the features.
> >=20
> > Adam Cetnerowski
> > Intel Technology Poland
> >=20
> >

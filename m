From: Dharmesh Kamdar <kamdard71@yahoo.com>
Subject: Re: UDEV with DM-MULTIPATH issue in RHEL 5.1....
Date: Wed, 27 Feb 2008 10:48:10 -0800 (PST)
Message-ID: <158683.6479.qm@web90614.mail.mud.yahoo.com>
References: <20080227182803.GA18357@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080227182803.GA18357@us.ibm.com>
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

Hi,

Thanks for the reply. But since the "dm-X" is NOT
persistent, Red Hat recommends NOT to use that and
recommends to use /dev/mapper/mpathX instead as per
this article
http://kbase.redhat.com/faq/FAQ_96_11196.shtm

But specifying /dev/mapper/<ALIAS> did not work for
us.

Regards,
Dharmesh.


--- malahal@us.ibm.com wrote:

> The kernel names of DM devices show up as /dev/dm-X
> where X is some
> integer. The /dev/mapper/XXX are created by the
> DM/MULTIPATH software
> without any help from udev as far as I know.
>=20
> So, use dm-X pattern instead. It may work.
>=20
> --Malahal.
>=20
> Dharmesh Kamdar [kamdard71@yahoo.com] wrote:
> > Hi,
> >=20
> > The UDEV rules are as follows:
> > /etc/udev/rules.d/51-oracle-raw.rules
> > ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/OCR1p1",
> > RUN+=3D"/bin/raw /dev/raw/rawX %N"
> > ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/OCR2p1",
> > RUN+=3D"/bin/raw /dev/raw/rawX %N"
> > ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/VOTE1p1",
> > RUN+=3D"/bin/raw /dev/raw/rawX %N"
> > ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/VOTE2p1",
> > RUN+=3D"/bin/raw /dev/raw/rawX %N"
> > ACTION=3D=3D"add", KERNEL=3D"/dev/mpath/VOTE3p1",
> > RUN+=3D"/bin/raw /dev/raw/rawX %N"
> > ~                                                =20
>   =20
> > 2) /etc/udev/rules.d/99-raw.rules
> > #-------------------------#
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20



      ___________________________________________________________________=
_________________
Looking for last minute shopping deals? =20
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsear=
ch/category.php?category=3Dshopping

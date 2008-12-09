From: Arvin Schnell <aschnell@suse.de>
Subject: Re: dm targets with spaces in the name
Date: Tue, 9 Dec 2008 14:58:05 +0100
Message-ID: <20081209135805.GA5172@suse.de>
References: <4936BBC6.7000800@cfl.rr.com> <1228405956.23557.74.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1228405956.23557.74.camel@o>
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

On Thu, Dec 04, 2008 at 04:52:36PM +0100, Heinz Mauelshagen wrote:
> Am Mittwoch, den 03.12.2008, 12:03 -0500 schrieb Phillip Susi:
> > Is this allowed?  It looks like you can create a target with a space =
in=20
> > the name, but then you can not refer to it in a rule of another targe=
t.=20
> >   Specifically I am seeing a user with a dmraid setup with raid volum=
es=20
> > using spaces in the name, and dmraid manages to create the stripe tar=
get=20
> > ( /dev/mapper/foo bar ), but then can not create the linear mapping o=
n=20
> > top of it for the partition, because the table looks like it has too=20
> > many arguments due to the space.
>=20
> What you describe here, is essentially caused by bogus names in vendor
> metadata not being detected and handled properly by dmraid.
>=20
> Which metadata format is that being caused by ?
>=20
> Can you send me the metadata sample retrieved via "dmraid -rD"
> (bzip2/tar the resulting *.{dat,offset,size} files before sending) ?

For some other BIOS RAID (AIC-9405 controller) you can find those
metadata in the openSUSE Bugilla:

https://bugzilla.novell.com/show_bug.cgi?id=3D396732#c28

Regards,
  Arvin

--=20
Arvin Schnell, <aschnell@suse.de>
Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

From: Valdis.Kletnieks@vt.edu
Subject: Re: Re: 2.6.24-rc4-mm1
Date: Fri, 07 Dec 2007 13:20:30 -0500
Message-ID: <6593.1197051630@turing-police.cc.vt.edu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
	<20071206040420.6c89c675.akpm@linux-foundation.org>
	<4374.1196968688@turing-police.cc.vt.edu>
	<20071206193843.GA25125@kroah.com>
	<3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
	<2955.1196982750@turing-police.cc.vt.edu>
	<1196983444.2829.38.camel@lov.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1075464336=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: Your message of "Fri, 07 Dec 2007 00:24:04 +0100."
	<1196983444.2829.38.camel@lov.site>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: device-mapper development <dm-devel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============1075464336==
Content-Type: multipart/signed; boundary="==_Exmh_1197051630_3013P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1197051630_3013P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Dec 2007 00:24:04 +0100, Kay Sievers said:
> On Thu, 2007-12-06 at 18:12 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 06 Dec 2007 23:04:12 +0100, Kay Sievers said:
> > 
> > > What's the value of SYSFS_DEPRECATED? Care to set it to yes, if it isn't,
> > > and try again?
> > 
> > I *knew* there was a D'Oh! error in here. ;)
> > 
> > Bisection is fast closing in on gregkh-driver-block-device.patch, which broke
> > my LVM almost the exact same way the *last* time it showed up in -mm ;)
> 
> Oh, it must not, if SYSFS_DEPRECATED=y is set. I hope we fixed all
> issues. Please let us know if it does not work, then we will need to
> look into it.

I changed SYSFS_DEPRECATED to y, and it was able to boot with the same old
initrd I've been using for a while.

Note that I had it set to 'n' for at least the last 4-5 -mm kernels, so it
*was* working fine without it..

> > > A fix for LVM to handle symlinks instead of directories is in the LVM
> > > CVS tree, but there wasn't a release since August.
> > 
> > I seem to recall it was 'nash' rather than LVM that had the indigestion the
> > last time around.
> 
> I think that a recent nash should work, even with SYSFS_DEPRECATED=n.
> Anyway, nothing should change when SYSFS_DEPRECATED set, nash works fine
> here, with that.

It was working fine with =n here until -rc4-mm1 as well, that's why it's a bit
of a surprise.  What got added to the 'deprecated' list in this iteration?

Now for the truly odd part - I just tried with a rebuilt initrd that included
the lvm.static from last night's Rawhide (lvm2-2.02.29-1.fc9).  And that didn't
work any better.

So to summarize: (old lvm == 2.02.24)

release	SYSFS_DEPRECATED	lvm2		works
-rc3-mm2		N	old	yes
-rc4-mm1		N	old	no
-rc4-mm1		Y	old	yes
-rc4-mm1		N	new	no

(I'm sure looking at that, everybody is now going 'WTF??!?' ;)

gregkh-driver-driver-core-fix-class-glue-dir-cleanup-logic.patch and
gregkh-driver-block-device.patch are the only patches left in the (very small)
bisect window that reference SYSFS_DEPRECATED at all (according to grep)

Anybody got any brilliant ideas? :)





--==_Exmh_1197051630_3013P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHWY7ucC3lWbTT17ARAqaWAKDuUACTkOjPdhc/8MsYUYCmmIW2zACgihYh
1LDyFqmjT6mLdHldes8KUP4=
=mXXh
-----END PGP SIGNATURE-----

--==_Exmh_1197051630_3013P--


--===============1075464336==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1075464336==--

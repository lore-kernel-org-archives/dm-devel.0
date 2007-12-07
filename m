From: Valdis.Kletnieks@vt.edu
Subject: Re: Re: 2.6.24-rc4-mm1
Date: Fri, 07 Dec 2007 15:28:23 -0500
Message-ID: <4192.1197059303@turing-police.cc.vt.edu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
	<20071206040420.6c89c675.akpm@linux-foundation.org>
	<4374.1196968688@turing-police.cc.vt.edu>
	<20071206193843.GA25125@kroah.com>
	<3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
	<2955.1196982750@turing-police.cc.vt.edu>
	<1196983444.2829.38.camel@lov.site>
	<6593.1197051630@turing-police.cc.vt.edu>
	<1197053069.5483.8.camel@lov.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0930102351=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: Your message of "Fri, 07 Dec 2007 19:44:29 +0100."
	<1197053069.5483.8.camel@lov.site>
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

--===============0930102351==
Content-Type: multipart/signed; boundary="==_Exmh_1197059303_2992P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1197059303_2992P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Dec 2007 19:44:29 +0100, Kay Sievers said:

> > Anybody got any brilliant ideas? :)
> 
> I guess it's nash again, which version is it?

Confirmed - nash again.  6.0.9 does not work, upgrading to 6.0.19 works.

init/Kconfig says this for SYSFS_DEPRECATED (which is where I got lead astray,
as most of my laptop is Fedora Rawhide and therefor "released this week"):

          If you are using a distro that was released in 2006 or later,
          it should be safe to say N here.

nash 6.0.9 came out in April 2007, and I suspect, but can't prove, that the
relevant change was this one:

* Mon Aug 27 2007 Peter Jones <pjones@redhat.com> - 6.0.12-2
- Fix segfault in scsi vpd probe code
- Fix block device creation

That was just over 3 months ago.  We probably need to fix that help text,
but I admit not being sure what guidance we should give now....

--==_Exmh_1197059303_2992P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHWazncC3lWbTT17ARAs16AKDXkv2UrOsdk3oLKLYGqsUyYzYpnACg8KSp
C3+qRTiLDfiaNruTEzgHqx0=
=v8o5
-----END PGP SIGNATURE-----

--==_Exmh_1197059303_2992P--


--===============0930102351==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0930102351==--

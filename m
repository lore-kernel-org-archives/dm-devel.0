From: valdis.kletnieks@vt.edu
Subject: Re: next-20180605 - kernel tried to execute NX-protected page - exploit attempt?
Date: Fri, 08 Jun 2018 16:07:19 -0400
Message-ID: <248061.1528488439@turing-police.cc.vt.edu>
References: <21051.1528404057@turing-police.cc.vt.edu> <20180607211401.GD4481@redhat.com>
 <136327.1528411295@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1528488438_2490P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <136327.1528411295@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids

--==_Exmh_1528488438_2490P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Jun 2018 18:41:35 -0400, valdis.kletnieks@vt.edu said:
> On Thu, 07 Jun 2018 17:14:01 -0400, Mike Snitzer said:
> > Can you please share what you test is?  We've gotten lots of reports
> > with failure following wake_up but I don't have a canned test to trigger
>
> Just a laptop with 16G of RAM, no clear reproducer -  Chrome with a lot of
> tabs, a mail reader, a bunch of SSH windows, and the next thing I know, it's
> locked up good and solid with wreckage in /sys/fs/pstore :)
>
> I got bit a third time a little while ago.  Will test the patches and see if
> they help - looks like I'm averaging two hours or so of active use before it
> hits, so it shouldn't take long before I know if the issue is swatted...

Looks like those two patches from Jens fixed the issue - this build has been up for
20 hours, and has survived a kernel build, an OpenWRT/Lede build, and a backup,
along with a bunch of other stuff.

--==_Exmh_1528488438_2490P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWxrh9o0DS38y7CIcAQIoOAgArMCJ+83NSdQ/HHzyiJTpC2oKap6ySTfe
kNntFO9zUdFqxDibhOreLDe7y2RX82GOaJdF1NWA/zC5C/v6jOsLfZeCCeHHtsW5
cIBDoAOW+OWeNfDkV98KanHytd+EfJ5OxkbGGBkE9jI2Gkj8KMt2N6uK+cxOGcHE
7xtsq18oKw4YARUJceQPARt29a6i5W6SgQMHfAOSzy2RtdHs8bd6E51VYKNCL5w+
WP/FHLvz03wDiKY0/g783AQF1dPxqAYXqsvEDZOLGQOTjOujDiJQhSrTOnxRFq0P
vDOt6n23fQM9HGXOMLCPDYj+9B0jbE6uUFEVoFqVYtmCYVHD3S3EHA==
=hZJw
-----END PGP SIGNATURE-----

--==_Exmh_1528488438_2490P--

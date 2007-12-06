From: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.24-rc4-mm1
Date: Thu, 06 Dec 2007 15:04:25 -0500
Message-ID: <7466.1196971465@turing-police.cc.vt.edu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
	<20071206040420.6c89c675.akpm@linux-foundation.org>
	<4374.1196968688@turing-police.cc.vt.edu>
	<20071206193843.GA25125@kroah.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0994251487=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: Your message of "Thu, 06 Dec 2007 11:38:43 PST."
	<20071206193843.GA25125@kroah.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0994251487==
Content-Type: multipart/signed; boundary="==_Exmh_1196971465_2829P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1196971465_2829P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Dec 2007 11:38:43 PST, Greg KH said:
> > Would I be remiss in hypothesising that something in gregkh-driver-kobject-*
> > changed something, and now we need a agk-dm-dm-kobject-fixupage.patch?
> 
> I don't know, it all depends on what is in the dm patches.  Hopefully
> everything that I have changed will manifest with a build breakage to
> obviously detect that something needs to be fixed up.
> 
> But I've been known to mess things up that I didn't intend to :)

Given that it *didn't* totally break the build, it's likely a fencepost error
or some similar issue...

> If there's anything that I can do to test this, please let me know.

I wanted to give a heads-up, in case there was a D'Oh! patch hiding. At worst,
I just need another 6 or 7 bisects to figure out which of those 120-ish patches
is the culprit.  With luck I'll end up stopped on a patch that in retrospect
was obviously busticated.  If not, we'll have to apply the usual more drastic
measures.  If you don't have a box that's already demonstrating it, and you
don't have any obvious candidates, it's likely that the most productive
use of everybody's time is for you to chase down any other kobject issues
while I bisect the problem down further...

--==_Exmh_1196971465_2829P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHWFXJcC3lWbTT17ARApgEAJ9pJDSM7zZqycRF0neS4dgz9JOnAgCfUyh8
MgzWo8mGixxHoRSnzFCNNh0=
=TOhE
-----END PGP SIGNATURE-----

--==_Exmh_1196971465_2829P--


--===============0994251487==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0994251487==--
